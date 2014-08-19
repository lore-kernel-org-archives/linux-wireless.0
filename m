Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:43881 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbaHSJdR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 05:33:17 -0400
Received: by mail-wi0-f179.google.com with SMTP id f8so4974614wiw.6
        for <linux-wireless@vger.kernel.org>; Tue, 19 Aug 2014 02:33:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140819082253.16842.32433.stgit@potku.adurom.net>
References: <20140819082038.16842.46876.stgit@potku.adurom.net>
	<20140819082253.16842.32433.stgit@potku.adurom.net>
Date: Tue, 19 Aug 2014 11:33:15 +0200
Message-ID: <CA+BoTQn2aq5EV4mvTs3Ww4i9gAJsmMM5iDfrFd=YfC0YxMi2WQ@mail.gmail.com> (sfid-20140819_113322_833034_AC22BCE3)
Subject: Re: [PATCH v7 2/8] ath10k: provide firmware crash info via debugfs
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 August 2014 10:22, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> Store the firmware crash registers and last 128 or so
> firmware debug-log ids and present them to user-space
> via debugfs.
>
> Should help with figuring out why the firmware crashed.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
[...]
> +struct ath10k_dump_file_data {
> +       /* dump file information */
> +
> +       /* "ATH10K-FW-DUMP" */
> +       char df_magic[16];
> +
> +       __le32 len;
> +
> +       /* file dump version */
> +       __le32 version;
> +
> +       /* some info we can get from ath10k struct that might help */
> +
> +       u8 uuid[16];
> +
> +       __le32 chip_id;
> +
> +       /* 0 for now, in place for later hardware */
> +       __le32 bus_type;
> +
> +       __le32 target_version;
> +       __le32 fw_version_major;
> +       __le32 fw_version_minor;
> +       __le32 fw_version_release;
> +       __le32 fw_version_build;
> +       __le32 phy_capability;
> +       __le32 hw_min_tx_power;
> +       __le32 hw_max_tx_power;
> +       __le32 ht_cap_info;
> +       __le32 vht_cap_info;
> +       __le32 num_rf_chains;

Hmm.. some of these values don't really change once driver is loaded
so we could probably just export them as separate debugfs entries but
perhaps that's an overkill just for dumping.


> +
> +       dump_data->kernel_ver_code = cpu_to_le32(LINUX_VERSION_CODE);
> +       strlcpy(dump_data->kernel_ver, VERMAGIC_STRING,
> +               sizeof(dump_data->kernel_ver));
> +
> +       dump_data->tv_sec = cpu_to_le64(crash_data->timestamp.tv_sec);
> +       dump_data->tv_nsec = cpu_to_le64(crash_data->timestamp.tv_nsec);
> +
> +       /* Gather dbg-log */
> +       dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
> +       dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_DBGLOG);
> +       dump_tlv->tlv_len = cpu_to_le32(sizeof(crash_data->dbglog_entry_data));

Hmm should this really be sizeof()? Not next_idx (which effectively
defines number of bytes of the dbglog)?


> +       memcpy(dump_tlv->tlv_data, &crash_data->dbglog_entry_data,
> +              sizeof(crash_data->dbglog_entry_data));
> +       sofar += sizeof(*dump_tlv) + sizeof(crash_data->dbglog_entry_data);
> +
> +       /* Gather crash-dump */
> +       dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
> +       dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_REGDUMP);
> +       dump_tlv->tlv_len = cpu_to_le32(sizeof(crash_data->reg_dump_values));
> +       memcpy(dump_tlv->tlv_data, &crash_data->reg_dump_values,
> +              sizeof(crash_data->reg_dump_values));
> +       sofar += sizeof(*dump_tlv) + sizeof(crash_data->reg_dump_values);

I haven't seen you mention that your latest patchset is based on my
patches that remove implicit byte swap from some diag functions so I
infer you're might've missed that reg_dump_values will be byte swapped
on big-endian hosts and userspace will remain unaware of that since
there is no endianess indication in the crash dump structure anymore.

reg_dump_values must be swapped cpu_to_le32 here (or should be never
implicit byte swapped in the first place).

It's probably worth stating in the comments that
ATH10K_FW_CRASH_DUMP_REGDUMP returns a list of __le32.


> +               ret = ath10k_pci_diag_read_mem(ar, dbuf.buffer, buffer,
> +                                              dbuf.length);
> +               if (ret != 0) {
> +                       ath10k_warn("failed to read debug log buffer from address 0x%x: %d\n",
> +                                   dbuf.buffer, ret);
> +                       kfree(buffer);
> +                       return;
> +               }
> +
> +               ath10k_debug_dbglog_add(ar, buffer, dbuf.length);
> +               kfree(buffer);

Is the `buffer` really a string of bytes (u8) or just u32 in disguise?
If it's the former then on big-endian host the implicit byte swap will
mess it up and userspace will have no way of knowing that now.


Michał
