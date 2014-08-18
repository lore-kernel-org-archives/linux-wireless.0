Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39158 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaHRLjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2014 07:39:23 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v6 2/8] ath10k: provide firmware crash info via debugfs
References: <20140809180552.29215.58612.stgit@potku.adurom.net>
	<20140809180805.29215.45232.stgit@potku.adurom.net>
	<CA+BoTQ=dO0kr+0tnXpJRoPd7iwGDtPj_cWM=vvMsRgGn1we5ow@mail.gmail.com>
Date: Mon, 18 Aug 2014 14:39:14 +0300
In-Reply-To: <CA+BoTQ=dO0kr+0tnXpJRoPd7iwGDtPj_cWM=vvMsRgGn1we5ow@mail.gmail.com>
	(Michal Kazior's message of "Mon, 18 Aug 2014 10:54:35 +0200")
Message-ID: <878ummdo2l.fsf@kamboji.qca.qualcomm.com> (sfid-20140818_133930_435418_66342173)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 9 August 2014 20:08, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Store the firmware crash registers and last 128 or so
>> firmware debug-log ids and present them to user-space
>> via debugfs.
>>
>> Should help with figuring out why the firmware crashed.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/core.h  |   27 +++
>>  drivers/net/wireless/ath/ath10k/debug.c |  273 +++++++++++++++++++++++++++++++
>>  drivers/net/wireless/ath/ath10k/debug.h |   22 ++
>>  drivers/net/wireless/ath/ath10k/hw.h    |   30 +++
>>  drivers/net/wireless/ath/ath10k/pci.c   |  133 ++++++++++++++-
>>  drivers/net/wireless/ath/ath10k/pci.h   |    3
>>  6 files changed, 478 insertions(+), 10 deletions(-)
> [...]
>
>> +struct ath10k_dump_file_data {
>> +       /* dump file information */
>> +
>> +       /* "ATH10K-FW-DUMP" */
>> +       char df_magic[16];
>> +
>> +       u32 len;
>> +
>> +       /* 0x1 if host is big-endian */
>> +       u32 big_endian;
>
> This isn't entirely correct. Depending on host endianess you'll end up
> with 0x1 or 0x1000000. This will still work if you do a boolean
> evaluation of it in userspace or compare it to 0, but god forbid to
> compare it with 0x1.

That's true. Didn't you at one point suggest just always using little
endian? I think that's simplest approach here.

>> +
>> +       /* file dump version, 1 for now. */
>> +       u32 version;
>
> I think this should have a #define instead of the comment. You'll need
> to update 2 values when you bump the version with comment+hardcode
> approach.

Good point, I'll add that.

>> +       /* some info we can get from ath10k struct that might help */
>> +
>> +       u8 uuid[16];
>> +
>> +       u32 chip_id;
>> +
>> +       /* 0 for now, in place for later hardware */
>> +       u32 bus_type;
>
> Maybe we should have an enum for that instead of using a hardcoded 0?

We had that but you removed it in 3a0861fffd223 =)

>> +       /* time-of-day stamp, nano-seconds */
>> +       u64 tv_nsec;
>> +
>> +
>> +       /* LINUX_VERSION_CODE */
>> +       u32 kernel_ver_code;
>
> 2 empty newlines?

Will fix.

>> +static struct ath10k_dump_file_data *ath10k_build_dump_file(struct ath10k *ar)
>> +{
>> +       struct ath10k_fw_crash_data *crash_data = ar->debug.fw_crash_data;
>> +       struct ath10k_dump_file_data *dump_data;
>> +       struct ath10k_tlv_dump_data *dump_tlv;
>> +       int hdr_len = sizeof(*dump_data);
>> +       unsigned int len, sofar = 0;
>> +       unsigned char *buf;
>> +
>> +       lockdep_assert_held(&ar->conf_mutex);
>> +
>> +       spin_lock_bh(&ar->data_lock);
>> +
>> +       if (!crash_data->crashed_since_read) {
>> +               spin_unlock_bh(&ar->data_lock);
>> +               return NULL;
>> +       }
>> +
>> +       spin_unlock_bh(&ar->data_lock);
>> +
>> +       len = hdr_len;
>> +       len += sizeof(*dump_tlv) + sizeof(crash_data->reg_dump_values);
>> +       len += sizeof(*dump_tlv) + sizeof(crash_data->dbglog_entry_data);
>> +
>> +       sofar += hdr_len;
>> +
>> +       /* This is going to get big when we start dumping FW RAM and such,
>> +        * so go ahead and use vmalloc.
>> +        */
>> +       buf = vmalloc(len);
>> +       if (!buf)
>> +               return NULL;
>> +
>> +       spin_lock_bh(&ar->data_lock);
>
> The current code doesn't seem to allow it, but according to comments
> crashed_since_read is protected by data_lock only. As such it might've
> changed while the lock was released.

Another good point.

> Current code, however, guarantees it remains true while conf_mutex is
> held.
>
> Perhaps the vmalloc() should be done before spin_lock is acquired

That sounds the simple way to do it. We get a useless allocation when
there's no crash data, but that's so bad.

> and/or the memory should be allocated outside this function completely
> and make it consume the crashed_since_read (i.e. set it to false) once
> it's done (while the data_lock is still held).

You mean like allocating the memory in advance, for example during
module probe time? Then we would have a big chunk of memory we don't use
for anything most of the time.

>> +       memset(buf, 0, len);
>> +       dump_data = (struct ath10k_dump_file_data *)(buf);
>> +       strlcpy(dump_data->df_magic, "ATH10K-FW-DUMP",
>> +               sizeof(dump_data->df_magic));
>> +       dump_data->len = len;
>> +
>> +#ifdef __BIG_ENDIAN
>> +       dump_data->big_endian = 1;
>> +#else
>> +       dump_data->big_endian = 0;
>> +#endif
>
> Yuck.

Yeah. I'm thinking of switching to little endian more and more :)

>> +static int ath10k_fw_crash_dump_open(struct inode *inode, struct file *file)
>> +{
>> +       struct ath10k *ar = inode->i_private;
>> +       struct ath10k_dump_file_data *dump;
>> +       int ret;
>> +
>> +       mutex_lock(&ar->conf_mutex);
>> +
>> +       dump = ath10k_build_dump_file(ar);
>> +       if (!dump) {
>> +               ret = -ENODATA;
>> +               goto out;
>> +       }
>> +
>> +       file->private_data = dump;
>
>> +       ar->debug.fw_crash_data->crashed_since_read = false;
>
> According to comments this should be protected by data_lock, but
> isn't.

Yup. I'll move crashed_since_read handling to ath10k_build_dump_file().

>
>> +       ret = 0;
>> +
>> +out:
>> +       mutex_unlock(&ar->conf_mutex);
>> +       return ret;
>> +}
>
>
>>  static int ath10k_debug_htt_stats_req(struct ath10k *ar)
>>  {
>>         u64 cookie;
>> @@ -913,6 +1178,10 @@ static const struct file_operations fops_dfs_stats = {
>>
>>  int ath10k_debug_create(struct ath10k *ar)
>>  {
>> +       ar->debug.fw_crash_data = vzalloc(sizeof(*ar->debug.fw_crash_data));
>> +       if (!ar->debug.fw_crash_data)
>> +               return -ENOMEM;
>> +
>>         ar->debug.debugfs_phy = debugfs_create_dir("ath10k",
>>                                                    ar->hw->wiphy->debugfsdir);
>
> I think there's a check if debug_phy is NULL. If it is it does return
> -ENOMEM. This means you leak fw_crash_data.

Indeed. I'll fix that.

>> +/* Target debug log related defines and structs */
>> +
>> +/* Target is 32-bit CPU, so we just use u32 for
>> + * the pointers.  The memory space is relative to the
>> + * target, not the host.
>> + */
>> +struct ath10k_fw_dbglog_buf {
>> +       /* pointer to dblog_buf_s */
>> +       u32 next;
>> +
>> +       /* pointer to u8 buffer */
>> +       u32 buffer;
>> +
>> +       u32 bufsize;
>> +       u32 length;
>> +       u32 count;
>> +       u32 free;
>> +} __packed;
>> +
>> +struct ath10k_fw_dbglog_hdr {
>> +       /* pointer to dbglog_buf_s */
>> +       u32 dbuf;
>> +
>> +       u32 dropped;
>> +} __packed;
>
> This is confusing.

Sorry, what are referring to here? I don't understand your comment.

> Target is a 32-bit *Little-Endian* CPU but due to implicit byteswap in
> ath10k_pci_diag_* functions everything is already in host endianess.

I think I'll that as a comment here.

-- 
Kalle Valo
