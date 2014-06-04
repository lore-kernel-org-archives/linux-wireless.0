Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:33535 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaFDJE7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 05:04:59 -0400
Received: by mail-we0-f172.google.com with SMTP id k48so8201923wev.3
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 02:04:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401812719-25061-1-git-send-email-greearb@candelatech.com>
References: <1401812719-25061-1-git-send-email-greearb@candelatech.com>
Date: Wed, 4 Jun 2014 11:04:57 +0200
Message-ID: <CA+BoTQnvAzCHvKwib39dOZnN6SEyNG_=U9Jgx5arM819dUoMYw@mail.gmail.com> (sfid-20140604_110513_800785_DE728874)
Subject: Re: [RFC 1/4] ath10k: provide firmware crash info via debugfs.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 June 2014 18:25,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> Store the firmware crash registers and last 128 or so
> firmware debug-log ids and present them to user-space
> via debugfs.
>
> Should help with figuring out why the firmware crashed.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>
> This series is compile-tested only at this point.  Hoping
> for feedback on general approach at least.
>
>
> drivers/net/wireless/ath/ath10k/core.h  |  41 +++++++++++
>  drivers/net/wireless/ath/ath10k/debug.c | 124 ++++++++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath10k/debug.h |  25 +++++++
>  drivers/net/wireless/ath/ath10k/pci.c   |  86 +++++++++++++++++++++-
>  4 files changed, 273 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index 68ceef6..4068910 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -41,6 +41,8 @@
>  #define ATH10K_FLUSH_TIMEOUT_HZ (5*HZ)
>  #define ATH10K_NUM_CHANS 38
>
> +#define REG_DUMP_COUNT_QCA988X 60 /* from pci.h */

I don't like this.


[...]
> +struct ath10k_tlv_dump_data {
> +       u32 type; /* see ath10k_fw_error_dump_type above */
> +       u32 tlv_len; /* in bytes */
> +       u8 tlv_data[]; /* Pad to 32-bit boundaries as needed. */
> +} __packed;
> +
> +struct ath10k_dump_file_data {
> +       u32 len;
> +       u32 magic; /* 0x01020304, tells us byte-order of host if we care */
> +       struct ath10k_tlv_dump_data data; /* more may follow */
> +} __packed;
> +
> +/* This will store at least the last 128 entries. */
> +#define ATH10K_DBGLOG_DATA_LEN (128 * 7 * 4)

Where does the 7 and 4 come from? Can't we use sizeof() to compute this?

The 128 should probably be a separate #define?

[...]
> +static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
> +{
> +       unsigned int len = (sizeof(ar->dbglog_entry_data)
> +                           + sizeof(ar->reg_dump_values));
> +       unsigned int sofar = 0;
> +       char *buf;
> +       struct ath10k_tlv_dump_data *dump_tlv;
> +       struct ath10k_dump_file_data *dump_data;
> +       int hdr_len = sizeof(*dump_data) - sizeof(dump_data->data);

You call this with conf_mutex held so it's a good idea to have a
lockdep here, isn't it?


[...]
> +       /* Gather crash-dump */
> +       dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
> +       dump_tlv->type = ATH10K_FW_ERROR_DUMP_REGDUMP;
> +       dump_tlv->tlv_len = sizeof(ar->reg_dump_values);
> +       memcpy(dump_tlv->tlv_data, &ar->reg_dump_values, dump_tlv->tlv_len);
> +       sofar += sizeof(*dump_tlv) + dump_tlv->tlv_len;
> +
> +       return dump_data;
> +}
> +
> +
> +
> +static int ath10k_fw_error_dump_open(struct inode *inode, struct file *file)

3 newlines?


> +{
> +       struct ath10k *ar = inode->i_private;
> +       int ret;
> +       struct ath10k_dump_file_data *dump;
> +
> +       if (!ar)
> +               return -EINVAL;
> +
> +       mutex_lock(&ar->conf_mutex);
> +
> +       dump = ath10k_build_dump_file(ar);
> +

Maybe it's just me, but this newline bugs me :)


> +       if (!dump) {
> +               ret = -ENODATA;
> +               goto out;
> +       }
> +
> +       file->private_data = dump;
> +       ar->crashed_since_read = false;
> +       ret = 0;
> +
> +out:
> +       mutex_unlock(&ar->conf_mutex);
> +       return ret;
> +}
> +
> +
> +static ssize_t ath10k_fw_error_dump_read(struct file *file,

2 newlines?


[...]
>  static int ath10k_debug_htt_stats_req(struct ath10k *ar)
>  {
>         u64 cookie;
> @@ -861,6 +981,9 @@ int ath10k_debug_create(struct ath10k *ar)
>         debugfs_create_file("simulate_fw_crash", S_IRUSR, ar->debug.debugfs_phy,
>                             ar, &fops_simulate_fw_crash);
>
> +       debugfs_create_file("fw_error_dump", S_IRUSR, ar->debug.debugfs_phy,
> +                           ar, &fops_fw_error_dump);
> +
>         debugfs_create_file("chip_id", S_IRUSR, ar->debug.debugfs_phy,
>                             ar, &fops_chip_id);
>
> @@ -931,4 +1054,5 @@ void ath10k_dbg_dump(enum ath10k_debug_mask mask,
>  }
>  EXPORT_SYMBOL(ath10k_dbg_dump);
>
> +

What is this newline doing here?


>  #endif /* CONFIG_ATH10K_DEBUG */
> diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
> index a582499..d9629f9 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.h
> +++ b/drivers/net/wireless/ath/ath10k/debug.h
> @@ -19,6 +19,7 @@
>  #define _DEBUG_H_
>
>  #include <linux/types.h>
> +#include "pci.h"
>  #include "trace.h"

Not really sure if we should be mixing pci in debug?

This actually gets me thinking we could have some stuff in hw.h that
isn't really related to the transport. I can imagine usb transport
would have pretty much the same hardware at the other side.


>  enum ath10k_debug_mask {
> @@ -110,4 +111,28 @@ static inline void ath10k_dbg_dump(enum ath10k_debug_mask mask,
>  {
>  }
>  #endif /* CONFIG_ATH10K_DEBUG */
> +
> +
> +/* Target debug log related defines and structs */
> +
> +/* Target is 32-bit CPU, so we just use u32 for
> + * the pointers.  The memory space is relative to the
> + * target, not the host.
> + */
> +struct dbglog_buf_s {
> +       u32 next; /* pointer to dblog_buf_s. */
> +       u32 buffer; /* pointer to u8 buffer */
> +       u32 bufsize;
> +       u32 length;
> +       u32 count;
> +       u32 free;
> +} __packed;
> +
> +struct dbglog_hdr_s {
> +       u32 dbuf; /* pointer to dbglog_buf_s */
> +       u32 dropped;
> +} __packed;

These structure names look strange. Why the _s suffix? Shouldn't these
be called simply ath10k_dbglog_buf and ath10k_dbglog_hdr? Or
ath10k_{fw/hw/dev/target}_dbglog_buf/hdr? (In case you want to have a
clearer distinction these structures aren't ath10k's per se).


[...]
> +       while (dbufp) {
> +               struct dbglog_buf_s dbuf;
> +
> +               ret = ath10k_pci_diag_read_mem(ar, dbufp,
> +                                              &dbuf, sizeof(dbuf));
> +               if (ret != 0) {
> +                       ath10k_err("could not read Debug Log Area: 0x%x\n",
> +                                  dbufp);
> +                       goto save_regs_and_restart;
> +               }
> +
> +               /* We have a buffer of data */
> +               /* TODO:  Do we need to worry about bit order on some
> +                * architectures?  This seems to work fine with
> +                * x86-64 host, at least.
> +                */

ath10k_pci_diag* performs byte-swap so you're good as long as you read
word-like data from the target. I suspect this might not work so great
if you read something like, say, a mac address which might be stored
as a raw byte stream instead.

What kind of data can we expect from the dbglog?


> +               ath10k_err("[%i] next: 0x%x buf: 0x%x sz: %i len: %i count: %i free: %i\n",
> +                          i, dbuf.next, dbuf.buffer, dbuf.bufsize, dbuf.length,
> +                          dbuf.count, dbuf.free);
> +               if (dbuf.buffer && dbuf.length) {
> +                       u8 *buffer = kmalloc(dbuf.length, GFP_ATOMIC);
> +
> +                       if (buffer) {
> +                               ret = ath10k_pci_diag_read_mem(ar, dbuf.buffer,
> +                                                              buffer,
> +                                                              dbuf.length);
> +                               if (ret != 0) {
> +                                       ath10k_err("could not read Debug Log buffer: 0x%x\n",
> +                                                  dbuf.buffer);
> +                                       kfree(buffer);
> +                                       goto save_regs_and_restart;
> +                               }
> +
> +                               ath10k_dbg_save_fw_dbg_buffer(ar, buffer,
> +                                                             dbuf.length);
> +                               kfree(buffer);
> +                       }
> +               }
> +               dbufp = dbuf.next;
> +               if (dbufp == dbg_hdr.dbuf) {
> +                       /* It is a circular buffer it seems, bail if next
> +                        * is head
> +                        */

Hmm, we seem to be mixing comment styles in ath10k now I guess (this
applies to other instances of multi-line comments in your patch). What
multi-line comment style should we really be using in ath10k? Kalle?


Michał
