Return-Path: <SRS0=/Gk3=PL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8FE4C43387
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jan 2019 22:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68C6721479
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jan 2019 22:52:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ZeZu4jSX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728571AbfACWwb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Jan 2019 17:52:31 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41750 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfACWwa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Jan 2019 17:52:30 -0500
Received: by mail-ed1-f68.google.com with SMTP id a20so23550264edc.8
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jan 2019 14:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=a/odM8fggI/u8LvKteDoh+j6VWdmd683+bv4niqHV1A=;
        b=ZeZu4jSX7eUstiYo0yJQswNJ+qifd9SpYjr7fv+xjkSrnp0+T5MOP0Z8al1r6xQJZB
         mReDtQ5wwrhPPLmvutM09CqD4Wt0uV96g8rnVzUyxdTcx7TZEyXf5tJ+RtYGljz1ENgW
         H9JYbZojlc/NnZYRqsaf/r8Re5DG5E20G4XU0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a/odM8fggI/u8LvKteDoh+j6VWdmd683+bv4niqHV1A=;
        b=nGWB71T+qr5twRwSrR/sKC1K8RZWEp71UEl6JM45iukGmP7W2KXf/q3gyoBXXkbvnS
         GziRj8DNooZB8dND69OZUwK0Y4+klCG6WL+nt0ElPaboAi+yOdEebTNLKLvkupmQ9IB2
         UdkjLJEP2EhVmoTVPnX6BKMfntb3RGNSDXVbwASH2Uzgb6r0tHdsoPK9pQXLR6HAGABv
         BOCU28zfsACxXEJ5Ll4c3cCW9X1b2CI3vLoIpTLnrpMVp/4N6PxyVlrZsu07lflJT6Ba
         Y+tF29xgoZDKf/RlqhmOKtLu567qhptd55K0/1fr4RUzNRiA8YUEAFEwrhtIWsPT+gh/
         BxcA==
X-Gm-Message-State: AA+aEWbckBR6CSzAGVaMAJswKfiZlTAmBnMpcX2HfXQjCwz2OsEJkayM
        z+xeBMe8m2jitKbhbWCuYbNxUa2uMYmmjxU3f+qDQF/Y+SuznFg+kr9DISa81Kp4XE/LYDmhz81
        gSovO5yKWz4ny3lsAUpHsC29UpVVw5Ad3V28TaZMK56copMA1WPyWc7UZDfR4bBq6a5+eeN1pXZ
        BkAR5tka4g1xrX+Q==
X-Google-Smtp-Source: AFSGD/U3e6RHGtCypqIC/13yiEJpI5fl0gurPageT+RKKJL17GGzAmLEHqyKa5sf5b0sXmqNZMSCqQ==
X-Received: by 2002:a50:fc07:: with SMTP id i7mr44400665edr.153.1546555947001;
        Thu, 03 Jan 2019 14:52:27 -0800 (PST)
Received: from [10.177.251.104] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id v20-v6sm13081232eju.37.2019.01.03.14.52.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Jan 2019 14:52:26 -0800 (PST)
Subject: Re: nl80211 related warning w/ 4-way handshake offload and failure to
 associate
To:     Eric Blau <eblau@eblau.com>, linux-wireless@vger.kernel.org
References: <CADU241NrgYUq+eEyaNXteTA+KkPgcLXRHraR9y1OZm2bYY7U3g@mail.gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d834abf2-c6cd-175d-5a88-47b0ca83b100@broadcom.com>
Date:   Thu, 3 Jan 2019 23:52:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <CADU241NrgYUq+eEyaNXteTA+KkPgcLXRHraR9y1OZm2bYY7U3g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/3/2019 5:29 PM, Eric Blau wrote:
> Hi folks,
> 
> Myself and several others are hitting a issue with the latest
> wpa_supplicant version (2.7). wpa_supplicant has added support for
> 4-way handshake offload for 802.1X. With this new version,
> wpa_supplicant fails to associate and hits a kernel warning which
> appears related to how the driver or firmware advertises 4-way
> handshake offload support.
> 
> There is an Arch Linux bug open on this with a bunch of details here:
> 
> https://bugs.archlinux.org/task/61119
> 
> The wpa_supplicant folks note that this appears to be a driver issue
> and suggested I report the problem here. Reverting to wpa_supplicant
> 2.6 without 4-way handshake offload support works around the problem.
> 
> Here is the kernel warning:
> 
> kernel: WARNING: CPU: 0 PID: 16169 at
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:5130
> brcmf_cfg80211_set_pmk+0x50/0x70 [brcmfmac]
> kernel: Modules linked in: brcmfmac ipt_MASQUERADE
> nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo fuse iptable_nat
> nf_nat_ipv4 xt_addrtype iptable_filter xt_conntrack nf_nat
> nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c crc32c_generic
> br_netfilter bridge stp llc cmac bnep nls_iso8859_1 nls_cp437 vfat fat
> snd_hda_codec_hdmi sg crypto_user btusb btrtl btbcm btintel bluetooth
> asix usbnet joydev mii mousedev bcm5974 input_leds libphy ecdh_generic
> crc16 msr ofpart cmdlinepart intel_spi_platform intel_spi brcmutil
> intel_rapl spi_nor x86_pkg_temp_thermal intel_powerclamp coretemp
> kvm_intel mtd cfg80211 iTCO_wdt iTCO_vendor_support i915 kvmgt
> vfio_mdev mdev vfio_iommu_type1 vfio kvm i2c_algo_bit drm_kms_helper
> drm snd_hda_codec_cirrus snd_hda_codec_generic snd_hda_intel
> snd_hda_codec applesmc irqbypass input_polldev intel_cstate
> snd_hda_core mmc_core intel_uncore snd_hwdep intel_rapl_perf snd_pcm
> thunderbolt mei_me pcspkr lpc_ich intel_gtt i2c_i801 intel_pch_thermal
> snd_timer
> kernel: agpgart mei rfkill snd syscopyarea spi_pxa2xx_pci sysfillrect
> sysimgblt acpi_als fb_sys_fops soundcore kfifo_buf sbs evdev
> industrialio sbshc mac_hid spi_pxa2xx_platform ac apple_bl pcc_cpufreq
> facetimehd(OE) videobuf2_dma_sg videobuf2_memops videobuf2_v4l2
> videobuf2_common videodev media ip_tables x_tables zfs(POE)
> zunicode(POE) zavl(POE) icp(POE) zcommon(POE) znvpair(POE) spl(OE)
> algif_skcipher af_alg hid_apple hid_generic usbhid hid dm_crypt dm_mod
> sd_mod crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel
> ahci libahci libata scsi_mod aesni_intel xhci_pci aes_x86_64
> crypto_simd xhci_hcd cryptd glue_helper [last unloaded: brcmfmac]
> kernel: CPU: 0 PID: 16169 Comm: wpa_supplicant Tainted: P W OE
> 4.20.0-arch1-1-ARCH #1
> kernel: Hardware name: Apple Inc. MacBookPro12,1/Mac-E43C1C25D4880AD6,
> BIOS MBP121.88Z.0177.B00.1806051659 06/05/2018
> kernel: RIP: 0010:brcmf_cfg80211_set_pmk+0x50/0x70 [brcmfmac]
> kernel: Code: 8b 83 c8 08 00 00 83 b8 80 07 00 00 02 75 1b 0f b6 55 08
> 80 fa 20 77 1c 48 8b 75 10 48 8d bb c0 08 00 00 5b 5d e9 80 fe ff ff
> <0f> 0b b8 ea ff ff ff 5b 5d c3 b8 de ff ff ff eb f6 66 66 2e 0f 1f
> kernel: RSP: 0018:ffffaad283d0ba98 EFLAGS: 00010293
> kernel: RAX: ffff9aa6ee816000 RBX: ffff9aa6ee811000 RCX: ffff9aa80a77c000
> kernel: RDX: ffffffffc10b8b7d RSI: ffffffffc10ade80 RDI: 0000000000000002
> kernel: RBP: ffffaad283d0bab0 R08: 00000000000000fe R09: ffff9aa80a77c000
> kernel: R10: 0000000000000000 R11: ffffffff848f5e58 R12: ffff9aa6ee816050
> kernel: R13: ffff9aa6ee811000 R14: ffff9aa76cc10000 R15: ffff9aa76cc10300
> kernel: FS: 00007fcfeb90a480(0000) GS:ffff9aa826a00000(0000)
> knlGS:0000000000000000
> kernel: CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> kernel: CR2: 000055d5ae8e5fe0 CR3: 0000000227530005 CR4: 00000000003606f0
> kernel: Call Trace:
> kernel: nl80211_set_pmk+0x178/0x270 [cfg80211]
> kernel: genl_family_rcv_msg+0x1c4/0x3c0
> kernel: ? sock_def_readable+0xe/0x80
> kernel: ? __netlink_sendskb+0x3d/0x50
> kernel: genl_rcv_msg+0x47/0x90
> kernel: ? __kmalloc_node_track_caller+0x1ed/0x290
> kernel: ? genl_family_rcv_msg+0x3c0/0x3c0
> kernel: netlink_rcv_skb+0x4c/0x120
> kernel: genl_rcv+0x24/0x40
> kernel: netlink_unicast+0x196/0x240
> kernel: netlink_sendmsg+0x1fd/0x3c0
> kernel: sock_sendmsg+0x33/0x40
> kernel: ___sys_sendmsg+0x295/0x2f0
> kernel: ? dev_get_by_name_rcu+0x73/0x90
> kernel: ? dev_ioctl+0x171/0x3d0
> kernel: ? __check_object_size+0xa0/0x189
> kernel: ? preempt_count_add+0x79/0xb0
> kernel: ? __inode_wait_for_writeback+0x7f/0xf0
> kernel: ? preempt_count_add+0x79/0xb0
> kernel: ? _raw_spin_lock+0x13/0x30
> kernel: ? _raw_spin_unlock+0x16/0x30
> kernel: ? __dentry_kill+0x116/0x160
> kernel: __sys_sendmsg+0x57/0xa0
> kernel: do_syscall_64+0x5b/0x170
> kernel: entry_SYSCALL_64_after_hwframe+0x44/0xa9
> kernel: RIP: 0033:0x7fcfebe41fd8
> kernel: Code: 89 02 48 c7 c0 ff ff ff ff eb b5 0f 1f 80 00 00 00 00 f3
> 0f 1e fa 48 8d 05 65 65 0c 00 8b 00 85 c0 75 17 b8 2e 00 00 00 0f 05
> <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 41 54 41 89 d4 55
> kernel: RSP: 002b:00007ffdff680c48 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> kernel: RAX: ffffffffffffffda RBX: 000055cd5d162040 RCX: 00007fcfebe41fd8
> kernel: RDX: 0000000000000000 RSI: 00007ffdff680c80 RDI: 0000000000000005
> kernel: RBP: 000055cd5d189110 R08: 0000000000000004 R09: 00007fcfebf04150
> kernel: R10: 00007ffdff680d54 R11: 0000000000000246 R12: 000055cd5d161f50
> kernel: R13: 00007ffdff680c80 R14: ffffffffffffffff R15: 0000000000000000
> kernel: ---[ end trace 462c92ab814d0cda ]---
> 
> 
> The problem looks related to this commit:
> 
> commit 2526ff21aa77c205f72e8263335f20b7d7e636fc
> Author: Arend van Spriel <arend.vanspriel@broadcom.com>
> AuthorDate: Fri Jun 9 13:08:48 2017 +0100
> Commit: Kalle Valo <kvalo@codeaurora.org>
> CommitDate: Fri Jun 30 09:38:22 2017 +0300
> 
> brcmfmac: support 4-way handshake offloading for 802.1X
> 
> Adding callbacks for PMK provisioning. If firmware supports offloading
> it is indicated to user-space that 802.1X offload is supported.
> 
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> 
> 
> ChangeLog for wpa_supplicant:
> 
> 2018-12-02 - v2.7
> * added support for nl80211 to offload 4-way handshake into the driver
> 
> 
> Thanks in advance for your help.

Hi Eric,

Not sure what the root cause is yet, but the warning means wpa_s is 
issuing a NL80211_CMD_SET_PMK, but it did not pass the 
NL80211_ATTR_WANT_1X_4WAY_HS flag attribute in the NL80211_CMD_CONNECT.

So at first glance it looks like user-space does not adhere to the api 
description:

/**
  * DOC: WPA/WPA2 EAPOL handshake offload
  *
  * By setting @NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_PSK flag drivers
  * can indicate they support offloading EAPOL handshakes for WPA/WPA2
  * preshared key authentication. In %NL80211_CMD_CONNECT the preshared
  * key should be specified using %NL80211_ATTR_PMK. Drivers supporting
  * this offload may reject the %NL80211_CMD_CONNECT when no preshared
  * key material is provided, for example when that driver does not
  * support setting the temporal keys through %CMD_NEW_KEY.
  *
  * Similarly @NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X flag can be
  * set by drivers indicating offload support of the PTK/GTK EAPOL
  * handshakes during 802.1X authentication. In order to use the offload
  * the %NL80211_CMD_CONNECT should have %NL80211_ATTR_WANT_1X_4WAY_HS
  * attribute flag. Drivers supporting this offload may reject the
  * %NL80211_CMD_CONNECT when the attribute flag is not present.
  *
  * For 802.1X the PMK or PMK-R0 are set by providing %NL80211_ATTR_PMK
  * using %NL80211_CMD_SET_PMK. For offloaded FT support also
  * %NL80211_ATTR_PMKR0_NAME must be provided.
  */

However, better make sure there is nothing wrong in the driver. Could 
you apply the patch below and let me know what the warning looks like.

Regards,
Arend
---
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c 
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index ce2c547..106322e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5122,12 +5122,15 @@ static int brcmf_cfg80211_set_pmk(struct wiphy 
*wiphy, struct net_device *dev,
  				  const struct cfg80211_pmk_conf *conf)
  {
  	struct brcmf_if *ifp;
+	enum brcmf_profile_fwsup use_fwsup;

  	brcmf_dbg(TRACE, "enter\n");

  	/* expect using firmware supplicant for 1X */
  	ifp = netdev_priv(dev);
-	if (WARN_ON(ifp->vif->profile.use_fwsup != BRCMF_PROFILE_FWSUP_1X))
+	use_fwsup = ifp->vif->profile.use_fwsup;
+	if (WARN(use_fwsup != BRCMF_PROFILE_FWSUP_1X,
+		 "use_fwsup=%X\n", use_fwsup))
  		return -EINVAL;

  	if (conf->pmk_len > BRCMF_WSEC_MAX_PSK_LEN)
