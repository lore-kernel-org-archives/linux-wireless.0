Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44498 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754257AbcHaWYl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Aug 2016 18:24:41 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7VLukxO078825
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2016 18:24:39 -0400
Received: from e28smtp04.in.ibm.com (e28smtp04.in.ibm.com [125.16.236.4])
        by mx0b-001b2d01.pphosted.com with ESMTP id 255q2tk7hn-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2016 18:24:38 -0400
Received: from localhost
        by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-wireless@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
        Thu, 1 Sep 2016 03:54:35 +0530
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
        by d28dlp01.in.ibm.com (Postfix) with ESMTP id 30BB8E005A
        for <linux-wireless@vger.kernel.org>; Thu,  1 Sep 2016 03:53:36 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
        by d28relay01.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u7VMOWTv11665532
        for <linux-wireless@vger.kernel.org>; Thu, 1 Sep 2016 03:54:32 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
        by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u7VMOVIS008400
        for <linux-wireless@vger.kernel.org>; Thu, 1 Sep 2016 03:54:32 +0530
Subject: linux-4.8-rcX:  ath9k traceback
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Wed, 31 Aug 2016 18:24:27 -0400
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Message-Id: <1472682267.2607.8.camel@linux.vnet.ibm.com> (sfid-20160901_002502_539875_F185E5CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

There weren't any problems on linux-4.7 kernels.  I'm getting the
following traceback on linux-4.8-rc1/-rc4 kernels.  Let me know if you
need any additional information.

[   64.006529] WARNING: CPU: 3 PID: 94 at drivers/net/wireless/ath/ath9k/beacon.c:642 ath9k_beacon_config+0x12c/0x140 [ath9k]
[   64.008714] Modules linked in: ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw bnep dm_crypt arc4 ath9k ath9k_common ath9k_hw ath mac80211 snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic intel_rapl coretemp kvm_intel snd_hda_intel snd_intel_sst_acpi snd_intel_sst_core kvm snd_soc_sst_mfld_platform snd_hda_codec snd_soc_core snd_hwdep cfg80211 ath3k snd_hda_core snd_compress btusb btrtl btbcm snd_soc_sst_match btintel bluetooth vfat irqbypass uvcvideo crct10dif_pclmul
[   64.018692]  crc32_pclmul fat snd_seq videobuf2_vmalloc iTCO_wdt videobuf2_memops crc32c_intel hid_sensor_rotation hid_rmi hid_sensor_magn_3d ghash_clmulni_intel iTCO_vendor_support videobuf2_v4l2 hid_sensor_als dcdbas intel_cstate dell_smm_hwmon hid_sensor_incl_3d hid_sensor_accel_3d hid_sensor_gyro_3d i2c_i801 hid_sensor_trigger i2c_smbus snd_seq_device pcspkr videobuf2_core mei_txe hid_sensor_iio_common shpchp lpc_ich mei videodev industrialio_triggered_buffer kfifo_buf snd_pcm industrialio joydev media rfkill_gpio snd_timer i2c_designware_platform i2c_designware_core rfkill snd dw_dmac dell_smo8800 wmi soundcore dw_dmac_core i915 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm hid_multitouch sdhci_acpi serio_raw sdhci mmc_core video i2c_hid hid_sensor_hub mfd_core

[   64.035203] CPU: 3 PID: 94 Comm: kworker/u8:2 Not tainted 4.8.0-rc4+ #664
[   64.038046] Hardware name: Dell Inc. Inspiron 11 - 3147/0TWP67, BIOS A09 11/13/2015
[   64.040929] Workqueue: phy0 ieee80211_iface_work [mac80211]
[   64.043783]  0000000000000286 0000000089a65213 ffff880173023608 ffffffff813b8cce
[   64.046668]  0000000000000000 0000000000000000 ffff880173023648 ffffffff8109005b
[   64.049536]  00000282a0869df7 ffff880171869580 0000000000000000 ffff8801787cc028
[   64.052402] Call Trace:
[   64.055257]  [<ffffffff813b8cce>] dump_stack+0x63/0x85
[   64.058133]  [<ffffffff8109005b>] __warn+0xcb/0xf0
[   64.061006]  [<ffffffff8109018d>] warn_slowpath_null+0x1d/0x20
[   64.063918]  [<ffffffffa0866efc>] ath9k_beacon_config+0x12c/0x140 [ath9k]
[   64.066867]  [<ffffffffa086b346>] ath9k_calculate_summary_state+0x126/0x370 [ath9k]
[   64.069836]  [<ffffffffa086bda6>] ath9k_bss_info_changed+0x186/0x1a0 [ath9k]
[   64.072840]  [<ffffffffa0741d95>] ieee80211_bss_info_change_notify+0xb5/0x1d0 [mac80211]
[   64.075867]  [<ffffffffa07ac352>] ieee80211_assoc_success+0x68d/0x9bc [mac80211]
[   64.078873]  [<ffffffff8117ca7d>] ? irq_work_queue+0x6d/0x80
[   64.081877]  [<ffffffff810e71b4>] ? wake_up_klogd+0x34/0x40
[   64.084860]  [<ffffffff810e76f1>] ? console_unlock+0x531/0x560
[   64.087822]  [<ffffffff810e79db>] ? vprintk_emit+0x2bb/0x520
[   64.090769]  [<ffffffff810e7e19>] ? vprintk_default+0x29/0x40

thanks,

Mimi
