Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:54945 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaH1Hsu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 03:48:50 -0400
Received: by mail-wg0-f43.google.com with SMTP id a1so347523wgh.2
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2014 00:48:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1409172214-24149-1-git-send-email-greearb@candelatech.com>
References: <1409172214-24149-1-git-send-email-greearb@candelatech.com>
Date: Thu, 28 Aug 2014 09:48:48 +0200
Message-ID: <CA+BoTQmBTOqp3O45_qqF=-YtyO4uVPJVydP6MfmrWUSc5mTQNw@mail.gmail.com> (sfid-20140828_094854_433737_0C412BDF)
Subject: Re: [PATCH v3] ath10k: save firmware debug log messages.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 August 2014 22:43,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> They may be dumped through the firmware dump debugfs
> file.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>
> v3:  Re-worked byte-order related stuff again,
>    thanks to Michael's comments on IRC.
>    Fix problem reported by smatch, possible NPE.
>
>
> v2:  Remove some #ifdefs
>      rebase:  Fix logging, deal with byte-order differences
>        when reading firmware memory.
>
> Tested on x86-64.  smatch is clean, but it seems it cannot detect
> le v/s cpu endian issues on x86-64, so I could have easily missed
> something.
>
>  drivers/net/wireless/ath/ath10k/core.h  | 18 +++++++
>  drivers/net/wireless/ath/ath10k/debug.c | 87 +++++++++++++++++++++++++++++-
>  drivers/net/wireless/ath/ath10k/debug.h |  5 ++
>  drivers/net/wireless/ath/ath10k/hw.h    | 21 ++++++++
>  drivers/net/wireless/ath/ath10k/pci.c   | 95 +++++++++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath10k/wmi.c   |  9 ++++
>  6 files changed, 233 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index 4ef4760..5109b0f 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -280,6 +280,22 @@ struct ath10k_vif_iter {
>         struct ath10k_vif *arvif;
>  };
>
> +/* This will store at least the last 128 entries.  Each dbglog message
> + * is a max of 7 32-bit integers in length, but the length can be less
> + * than that as well.
> + */
> +#define ATH10K_DBGLOG_DATA_LEN (128 * 7)
> +struct ath10k_dbglog_entry_storage {

ath10k_dbglog_circular_buffer? or ring_buffer?

> +       u32 next_idx; /* Where to write next chunk of data */
> +       u32 first_idx; /* Index of first msg */

Since this is a circular buffer perhaps "head_idx", and "tail_idx"
would be more suitable? No need for comments then.


> +       __le32 data[ATH10K_DBGLOG_DATA_LEN];
> +};
> +
> +/* Just enough info to decode firmware debug-log argument length */
> +#define DBGLOG_NUM_ARGS_OFFSET           26
> +#define DBGLOG_NUM_ARGS_MASK             0xFC000000 /* Bit 26-31 */
> +#define DBGLOG_NUM_ARGS_MAX              5 /* firmware tool chain limit */
> +
>  /* used for crash-dump storage, protected by data-lock */
>  struct ath10k_fw_crash_data {
>         bool crashed_since_read;
> @@ -307,6 +323,8 @@ struct ath10k_debug {
>         u8 htt_max_amsdu;
>         u8 htt_max_ampdu;
>
> +       struct ath10k_dbglog_entry_storage dbglog_entry_data;
> +
>         struct ath10k_fw_crash_data *fw_crash_data;
>  };
>
> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> index f3f0a80..5ff3abc 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -32,10 +32,11 @@
>  /**
>   * enum ath10k_fw_crash_dump_type - types of data in the dump file
>   * @ATH10K_FW_CRASH_DUMP_REGDUMP: Register crash dump in binary format
> + * @ATH10K_FW_ERROR_DUMP_DBGLOG:  Recent firmware debug log entries
>   */
>  enum ath10k_fw_crash_dump_type {
>         ATH10K_FW_CRASH_DUMP_REGISTERS = 0,
> -
> +       ATH10K_FW_CRASH_DUMP_DBGLOG = 1,
>         ATH10K_FW_CRASH_DUMP_MAX,
>  };
>
> @@ -673,7 +674,6 @@ ath10k_debug_get_new_fw_crash_data(struct ath10k *ar)
>
>         lockdep_assert_held(&ar->data_lock);
>
> -       crash_data->crashed_since_read = true;
>         uuid_le_gen(&crash_data->uuid);
>         getnstimeofday(&crash_data->timestamp);
>
> @@ -681,17 +681,83 @@ ath10k_debug_get_new_fw_crash_data(struct ath10k *ar)
>  }
>  EXPORT_SYMBOL(ath10k_debug_get_new_fw_crash_data);
>
> +static void ath10k_dbg_drop_dbg_buffer(struct ath10k *ar)
> +{

+ lockdep_assert_held(&ar->data_lock);


> +       /* Find next message boundary */
> +       u32 lg_hdr;
> +       int acnt;
> +       int first_idx = ar->debug.dbglog_entry_data.first_idx;
> +       int h_idx = (first_idx + 1) % ATH10K_DBGLOG_DATA_LEN;
> +
> +       /* Log header is second 32-bit word */
> +       lg_hdr = le32_to_cpu(ar->debug.dbglog_entry_data.data[h_idx]);
> +
> +       acnt = (lg_hdr & DBGLOG_NUM_ARGS_MASK) >> DBGLOG_NUM_ARGS_OFFSET;

Can we have a structure definition for this, please?


> +
> +       if (acnt > DBGLOG_NUM_ARGS_MAX) {
> +               /* Some sort of corruption it seems, recover as best we can. */
> +               ath10k_err(ar, "Invalid dbglog arg-count: %i %i %i\n",
> +                          acnt, ar->debug.dbglog_entry_data.first_idx,
> +                          ar->debug.dbglog_entry_data.next_idx);

Lower case, please.


> +               ar->debug.dbglog_entry_data.first_idx =
> +                       ar->debug.dbglog_entry_data.next_idx;
> +               return;
> +       }
> +
> +       /* Move forward over the args and the two header fields */
> +       ar->debug.dbglog_entry_data.first_idx =
> +               (first_idx + acnt + 2) % ATH10K_DBGLOG_DATA_LEN;
> +}
> +
> +void ath10k_dbg_save_fw_dbg_buffer(struct ath10k *ar, __le32 *buffer, int len)
> +{
> +       int i;
> +       int z;
> +
> +       lockdep_assert_held(&ar->data_lock);
> +
> +       z = ar->debug.dbglog_entry_data.next_idx;
> +
> +       /* Don't save any new logs until user-space reads this. */
> +       if (ar->debug.fw_crash_data &&
> +           ar->debug.fw_crash_data->crashed_since_read) {
> +               ath10k_warn(ar, "Dropping dbg buffer due to crash since read.\n");

Lower case without the following dot, please.


> +               return;
> +       }
> +
> +       for (i = 0; i < len; i++) {
> +               ar->debug.dbglog_entry_data.data[z] = buffer[i];
> +               z++;
> +               if (z >= ATH10K_DBGLOG_DATA_LEN)
> +                       z = 0;
> +
> +               /* If we are about to over-write an old message, move the
> +                * first_idx to the next message.  If idx's are same, we
> +                * are empty.
> +                */
> +               if (z == ar->debug.dbglog_entry_data.first_idx)
> +                       ath10k_dbg_drop_dbg_buffer(ar);
> +
> +               ar->debug.dbglog_entry_data.next_idx = z;
> +       }
> +}
> +EXPORT_SYMBOL(ath10k_dbg_save_fw_dbg_buffer);
> +
> +

2 empty newlines?


>  static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
>  {
>         struct ath10k_fw_crash_data *crash_data = ar->debug.fw_crash_data;
>         struct ath10k_dump_file_data *dump_data;
>         struct ath10k_tlv_dump_data *dump_tlv;
> +       struct ath10k_dbglog_entry_storage *dbglog_storage;
>         int hdr_len = sizeof(*dump_data);
>         unsigned int len, sofar = 0;
>         unsigned char *buf;
> +       int tmp, tmp2;
>
>         len = hdr_len;
>         len += sizeof(*dump_tlv) + sizeof(crash_data->registers);
> +       len += sizeof(*dump_tlv) + sizeof(ar->debug.dbglog_entry_data);
>
>         sofar += hdr_len;
>
> @@ -750,8 +816,25 @@ static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
>                sizeof(crash_data->registers));
>         sofar += sizeof(*dump_tlv) + sizeof(crash_data->registers);
>
> +       /* Gather dbg-log */
> +       tmp = sizeof(ar->debug.dbglog_entry_data);
> +       tmp2 = tmp/sizeof(u32);

I don't see why you'd need tmp2 now?


> +       dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
> +       dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_DBGLOG);
> +       dump_tlv->tlv_len = cpu_to_le32(tmp);
> +       dbglog_storage =
> +               (struct ath10k_dbglog_entry_storage *)(dump_tlv->tlv_data);
> +       memcpy(dbglog_storage, &ar->debug.dbglog_entry_data,
> +              sizeof(*dbglog_storage));
> +       /* Convert indexes to le32, data is already le32 */
> +       dbglog_storage->next_idx = cpu_to_le32(dbglog_storage->next_idx);
> +       dbglog_storage->first_idx = cpu_to_le32(dbglog_storage->first_idx);

Obviously this violates typing. You assign __le32 to a u32.

You either need a separate structure that is used for the actual dump
blob or use __le32 in the dbglog_storage all the time.

The comment becomes unnecessary then.


> +
> +       sofar += sizeof(*dump_tlv) + tmp;
> +
>         ar->debug.fw_crash_data->crashed_since_read = false;
>
> +       WARN_ON(sofar != len);
>         spin_unlock_bh(&ar->data_lock);
>
>         return dump_data;
> diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
> index 5674653..c168cdb 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.h
> +++ b/drivers/net/wireless/ath/ath10k/debug.h
> @@ -114,6 +114,7 @@ void ath10k_dbg_dump(struct ath10k *ar,
>                      enum ath10k_debug_mask mask,
>                      const char *msg, const char *prefix,
>                      const void *buf, size_t len);
> +void ath10k_dbg_save_fw_dbg_buffer(struct ath10k *ar, __le32 *buffer, int len);
>  #else /* CONFIG_ATH10K_DEBUG */
>
>  static inline int ath10k_dbg(struct ath10k *ar,
> @@ -129,5 +130,9 @@ static inline void ath10k_dbg_dump(struct ath10k *ar,
>                                    const void *buf, size_t len)
>  {
>  }
> +static inline void ath10k_dbg_save_fw_dbg_buffer(struct ath10k *ar,
> +                                                __le32 *buffer, int len)
> +{
> +}
>  #endif /* CONFIG_ATH10K_DEBUG */
>  #endif /* _DEBUG_H_ */
> diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
> index 13568b0..73439f9 100644
> --- a/drivers/net/wireless/ath/ath10k/hw.h
> +++ b/drivers/net/wireless/ath/ath10k/hw.h
> @@ -364,4 +364,25 @@ enum ath10k_mcast2ucast_mode {
>
>  #define RTC_STATE_V_GET(x) (((x) & RTC_STATE_V_MASK) >> RTC_STATE_V_LSB)
>
> +/* Target debug log related defines and structs */
> +
> +/* Target is 32-bit CPU, so we just use u32 for
> + * the pointers.  The memory space is relative to the
> + * target, not the host.  Values are converted to host
> + * byte order when reading from firmware.
> + */
> +struct ath10k_fw_dbglog_buf {
> +       __le32 next; /* pointer to dblog_buf_s. */

s/dbglog_buf_s/ath10k_fw_dbglog_buf/ ?


> +       __le32 buffer; /* pointer to u8 buffer */
> +       __le32 bufsize;
> +       __le32 length;
> +       __le32 count;
> +       __le32 free;
> +} __packed;
> +
> +struct ath10k_fw_dbglog_hdr {
> +       __le32 dbuf; /* pointer to dbglog_buf_s */

s/dbglog_buf_s/ath10k_fw_dbglog_buf/ ?


> +       __le32 dropped;
> +} __packed;
> +
>  #endif /* _HW_H_ */
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
> index 1ff2f34..b641782 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -1024,6 +1024,97 @@ static void ath10k_pci_dump_registers(struct ath10k *ar,
>                 crash_data->registers[i] = reg_dump_values[i];
>  }
>
> +static void ath10k_pci_dump_dbglog(struct ath10k *ar)
> +{
> +       struct ath10k_fw_dbglog_hdr dbg_hdr;
> +       u32 dbufp; /* pointer in target memory space */
> +       struct ath10k_fw_dbglog_buf dbuf;
> +       u8 *buffer;
> +       int ret;
> +       int i;
> +       int len;
> +
> +       /* Dump the debug logs on the target */
> +       ret = ath10k_pci_diag_read_hi(ar, &dbg_hdr, hi_dbglog_hdr,
> +                                     sizeof(dbg_hdr));

I don't see how this comment fits here.


> +       if (ret != 0) {
> +               ath10k_err(ar, "failed to dump debug log area: %d\n", ret);
> +               return;
> +       }
> +
> +       ath10k_dbg(ar, ATH10K_DBG_PCI,
> +                  "Debug Log Header, dbuf: 0x%x  dropped: %i\n",
> +                  le32_to_cpu(dbg_hdr.dbuf), le32_to_cpu(dbg_hdr.dropped));

Lower case, please.


> +       dbufp = le32_to_cpu(dbg_hdr.dbuf);
> +
> +       /* i is for logging purposes and sanity check in case firmware buffers
> +        * are corrupted and will not properly terminate the list.
> +        * In standard firmware, it appears there are no more than 2
> +        * buffers, so 10 should be safe upper limit even if firmware
> +        * changes quite a bit.
> +        */
> +       i = 0;
> +       while (dbufp && i < 10) {
> +               ret = ath10k_pci_diag_read_mem(ar, dbufp, &dbuf, sizeof(dbuf));
> +               if (ret != 0) {
> +                       ath10k_err(ar, "failed to read debug log area: %d (addr 0x%x)\n",
> +                                  ret, dbufp);
> +                       return;
> +               }
> +
> +               len = le32_to_cpu(dbuf.length);
> +
> +               /* We have a buffer of data */

Not really sure why we need this comment?


> +               ath10k_dbg(ar, ATH10K_DBG_PCI,
> +                          "[%i] next: 0x%x buf: 0x%x sz: %i len: %i count: %i free: %i\n",
> +                          i, le32_to_cpu(dbuf.next), le32_to_cpu(dbuf.buffer),
> +                          le32_to_cpu(dbuf.bufsize), len,
> +                          le32_to_cpu(dbuf.count), le32_to_cpu(dbuf.free));
> +               if (dbuf.buffer == 0 || len == 0)
> +                       goto next;
> +
> +               /* Pick arbitrary upper bound in case firmware is corrupted for
> +                * whatever reason.
> +                */
> +               if (len > 4096) {
> +                       ath10k_err(ar,
> +                                  "debuglog buf length is out of bounds: %d\n",
> +                                  len);
> +                       /* Do not trust the next pointer either... */
> +                       return;
> +               }
> +
> +               buffer = kmalloc(len, GFP_ATOMIC);
> +
> +               if (!buffer)
> +                       goto next;
> +
> +               ret = ath10k_pci_diag_read_mem(ar, le32_to_cpu(dbuf.buffer),
> +                                              buffer, len);
> +               if (ret != 0) {
> +                       ath10k_err(ar, "failed to read debug log buffer: %d (addr 0x%x)\n",
> +                                  ret, le32_to_cpu(dbuf.buffer));
> +                       kfree(buffer);
> +                       return;
> +               }
> +
> +               WARN_ON(len & 0x3);
> +
> +               ath10k_dbg_save_fw_dbg_buffer(ar, (__le32 *)(buffer), len >> 2);
> +               kfree(buffer);
> +
> +next:
> +               dbufp = le32_to_cpu(dbuf.next);
> +               if (dbufp == le32_to_cpu(dbg_hdr.dbuf)) {
> +                       /* It is a circular buffer it seems, bail if next
> +                        * is head
> +                        */
> +                       break;
> +               }
> +               i++;
> +       } /* While we have a debug buffer to read */
> +}
> +
>  static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
>  {
>         struct ath10k_fw_crash_data *crash_data;
> @@ -1042,6 +1133,10 @@ static void ath10k_pci_fw_crashed_dump(struct ath10k *ar)
>         ath10k_print_driver_info(ar);
>         ath10k_pci_dump_registers(ar, crash_data);
>

I think we can pack this up without an empty newline. It just
stretches out the code needlessly.


> +       ath10k_pci_dump_dbglog(ar);
> +       if (crash_data)
> +               crash_data->crashed_since_read = true;
> +
>         spin_unlock_bh(&ar->data_lock);
>
>         queue_work(ar->workqueue, &ar->restart_work);
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index e500a3c..b306eaf 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -1290,6 +1290,15 @@ static int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb)
>
>         trace_ath10k_wmi_dbglog(skb->data, skb->len);
>
> +       spin_lock_bh(&ar->data_lock);
> +       /* First 4 bytes are a messages-dropped-due-to-overflow counter,
> +        * and should not be recorded in the dbglog buffer, so we skip
> +        * them.
> +        */
> +       ath10k_dbg_save_fw_dbg_buffer(ar, (__le32 *)(skb->data + 4),
> +                                     (skb->len - 4)/sizeof(u32));

I think I've already mentioned this in another review of this patch,
but isn't a structure better suited here? You already reveal the
structure in the comment and code. Having an explicit structure is a
lot better than some pointer arithmetic voodoo with a comment.


Michał
