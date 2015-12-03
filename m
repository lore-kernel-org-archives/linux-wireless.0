Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:35857 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbbLCT5D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 14:57:03 -0500
Received: by lfs39 with SMTP id 39so94597704lfs.3
        for <linux-wireless@vger.kernel.org>; Thu, 03 Dec 2015 11:57:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAF7g2REe-gFm9y2SsXz5nSn9ofHevNkr80YNV720W+XB815qsA@mail.gmail.com>
References: <CAF7g2REe-gFm9y2SsXz5nSn9ofHevNkr80YNV720W+XB815qsA@mail.gmail.com>
Date: Thu, 3 Dec 2015 21:57:00 +0200
Message-ID: <CANUX_P3WRatRnY7Mciv_W0-azk86uHsFThXYu=+QgCu8qw=GAg@mail.gmail.com> (sfid-20151203_205707_574562_0F926028)
Subject: Re: iw set txpower error
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Kobi Cohen-Arazi <kobi.cohenarazi@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 3, 2015 at 8:10 PM, Kobi Cohen-Arazi
<kobi.cohenarazi@gmail.com> wrote:
> Hi all,
>
> I’m trying to change txpower with iw. Using AR9580 HW + ath9k driver
> with Kernel 4.1.6.
>
> The call fails in mac80211 with the following error: "Failed
> check-sdata-in-driver check, flags: 0x0".
> stack:
> ---------------------------------  start stack

Try that one:

https://kernel.googlesource.com/pub/scm/linux/kernel/git/jberg/mac80211/+/5ad11b50fda1306b5317124f97f0a7a4c022b022

> ----------------------------------------
> [44387.506210] WARNING: CPU: 2 PID: 19731 at
> net/mac80211/driver-ops.h:12
> ieee80211_bss_info_change_notify+0x1d2/0x1e0 [mac80211]()
> [44387.506211] wlp2s0:  Failed check-sdata-in-driver check, flags: 0x0
> [44387.506212] Modules linked in: ath9k(OE) ath9k_common(OE)
> ath9k_hw(OE) ath(OE) mac80211 cfg80211 rfkill nfsv3 rpcsec_gss_krb5
> nfsv4 dns_resolver nfs fscache xt_CHECKSUM iptable_mangle xt_conntrack
> ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4
> nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype tun br_netfilter nf_nat
> nf_conntrack bridge stp llc dm_thin_pool dm_persistent_data
> dm_bio_prison libcrc32c loop arc4 intel_rapl iosf_mbi
> x86_pkg_temp_thermal coretemp kvm_intel kvm snd_hda_codec_hdmi
> snd_hda_codec_realtek snd_hda_codec_generic crct10dif_pclmul
> snd_soc_rt5640 snd_hda_intel crc32_pclmul snd_soc_rl6231
> snd_hda_controller crc32c_intel snd_soc_core snd_hda_codec
> ghash_clmulni_intel snd_hda_core snd_compress snd_pcm_dmaengine
> snd_hwdep snd_seq iTCO_wdt iTCO_vendor_support snd_seq_device
> [44387.506241]  ir_lirc_codec lirc_dev ir_xmp_decoder
> ir_mce_kbd_decoder ir_sharp_decoder ir_sanyo_decoder ir_sony_decoder
> ir_jvc_decoder ir_nec_decoder ir_rc6_decoder ir_rc5_decoder rc_rc6_mce
> snd_pcm nuvoton_cir tpm_tis dw_dmac i2c_hid regmap_i2c tpm rc_core
> dw_dmac_core snd_timer i2c_designware_platform i2c_i801
> i2c_designware_core snd_soc_sst_acpi snd lpc_ich soundcore shpchp
> mfd_core nfsd auth_rpcgss nfs_acl lockd grace sunrpc i915 i2c_algo_bit
> drm_kms_helper e1000e drm ptp pps_core sdhci_acpi sdhci mmc_core video
> [last unloaded: rfkill]
> [44387.506264] CPU: 2 PID: 19731 Comm: iwconfig Tainted: G        W
> OE   4.1.6-100.fc21.x86_64 #1
> WYLPT10H.86A.0035.2015.0126.1814 01/26/2015
> [44387.506267]  0000000000000000 00000000a8ea5b62 ffff8800942cbb58
> ffffffff817940d5
> [44387.506269]  0000000000000000 ffff8800942cbbb0 ffff8800942cbb98
> ffffffff810a163a
> [44387.506270]  ffff8800942cbc20 ffff8800d49b2840 0000000000000001
> ffff8801c92c86a0
> [44387.506272] Call Trace:
> [44387.506278]  [<ffffffff817940d5>] dump_stack+0x45/0x57
> [44387.506281]  [<ffffffff810a163a>] warn_slowpath_common+0x8a/0xc0
> [44387.506283]  [<ffffffff810a16c5>] warn_slowpath_fmt+0x55/0x70
> [44387.506286]  [<ffffffff8177f3e0>] ? iw_handler_get_private+0x70/0x70
> [44387.506293]  [<ffffffffa095fe32>]
> ieee80211_bss_info_change_notify+0x1d2/0x1e0 [mac80211]
> [44387.506300]  [<ffffffffa0975005>]
> ieee80211_recalc_txpower+0x35/0x40 [mac80211]
> [44387.506309]  [<ffffffffa097d08c>] ieee80211_set_tx_power+0x4c/0x1b0
> [mac80211]
> [44387.506320]  [<ffffffffa075684f>]
> cfg80211_wext_siwtxpower+0x9f/0x1c0 [cfg80211]
> [44387.506334]  [<ffffffff8177e672>] ioctl_standard_call+0x52/0xe0
> [44387.506336]  [<ffffffff8177f3e0>] ? iw_handler_get_private+0x70/0x70
> [44387.506340]  [<ffffffff8177e620>] ? ioctl_standard_iw_point+0x390/0x390
> [44387.506342]  [<ffffffff8177dcae>] wireless_process_ioctl+0x17e/0x1d0
> [44387.506345]  [<ffffffff8177e918>] wext_handle_ioctl+0x78/0xe0
> [44387.506348]  [<ffffffff81693443>] dev_ioctl+0x2c3/0x5d0
> [44387.506353]  [<ffffffff811dd8df>] ? handle_mm_fault+0x117f/0x17f0
> [44387.506356]  [<ffffffff8166045c>] ? sk_prot_alloc+0xdc/0x180
> [44387.506359]  [<ffffffff8165b472>] sock_ioctl+0x132/0x2c0
> [44387.506362]  [<ffffffff81241e9e>] ? __d_instantiate+0x9e/0x100
> [44387.506365]  [<ffffffff8123d398>] do_vfs_ioctl+0x2f8/0x500
> [44387.506369]  [<ffffffff81068cc1>] ? __do_page_fault+0x1c1/0x450
> [44387.506372]  [<ffffffff8123d621>] SyS_ioctl+0x81/0xa0
> [44387.506375]  [<ffffffff81068f7f>] ? do_page_fault+0x2f/0x80
> [44387.506378]  [<ffffffff8179a9ae>] system_call_fastpath+0x12/0x71
> [44387.506380] ---[ end trace de552a3121eef335 ]---
> --------------------------------------- end stack
> -----------------------------------------------------------
>
> The call in driver-ops.h:check_sdata_in_driver() fails:
>
> static inline bool check_sdata_in_driver(struct ieee80211_sub_if_data *sdata)
> {
>                 return !WARN(!(sdata->flags & IEEE80211_SDATA_IN_DRIVER),
>                                      "%s:  Failed
> check-sdata-in-driver check, flags: 0x%x\n",
>                                      sdata->dev ? sdata->dev->name :
> sdata->name, sdata->flags);
> }
>
> AFAIU, this should not happen.
> ath9k_add_interface is being called before trying to set txpower. I verified it.
> When ath9k_add_interface returns, driver-ops.h:drv_add_interface()
> should set SDATA_IN_DRIVER flag.
>
> Any idea why the sdata->flags would still show up with 0x0 in the
> above function ?
>
> Thank you,
> Kobi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
