Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:45763 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967082AbdEWI6U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 May 2017 04:58:20 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH] cfg80211: make cfg80211_sched_scan_results() work from atomic context
Date: Tue, 23 May 2017 09:58:07 +0100
Message-Id: <1495529887-14542-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170523_105911_494941_3D88E5E5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers should be able to call cfg80211_sched_scan_results() from atomic
context. However, with the introduction of multiple scheduled scan feature
this requirement was not taken into account resulting in regression shown
below.

[  119.021594] BUG: scheduling while atomic: irq/47-iwlwifi/517/0x00000200
[  119.021604] Modules linked in: xt_tcpudp ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_raw ip6table_security ip6table_mangle iptable_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_security iptable_mangle ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables rfcomm bnep binfmt_misc arc4 iTCO_wdt iTCO_vendor_support uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core videodev intel_rapl cdc_mbim iwlmvm x86_pkg_temp_thermal intel_powerclamp mac80211 media cdc_wdm btusb coretemp cdc_ncm kvm_intel usbnet mii cdc_acm iwlwifi kvm btintel joydev pcspkr serio_raw cfg80211 snd_hda_codec_hdmi
[  119.021701]  bluetooth lpc_ich snd_hda_codec_realtek snd_hda_codec_generic shpchp sg ecdh_generic snd_hda_intel thinkpad_acpi snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_timer nvram snd soundcore evdev tpm_tis tpm_tis_core tpm algif_skcipher af_alg crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel rtsx_pci_sdmmc mmc_core aesni_intel aes_x86_64 crypto_simd cryptd glue_helper psmouse i2c_i801 sd_mod ehci_pci ehci_hcd e1000e rtsx_pci mfd_core ptp xhci_pci pps_core xhci_hcd
[  119.021759] CPU: 1 PID: 517 Comm: irq/47-iwlwifi Not tainted 4.12.0-rc2-t440s-20170522+ #1
[  119.021763] Hardware name: LENOVO 20AQS03H00/20AQS03H00, BIOS GJET91WW (2.41 ) 09/21/2016
[  119.021766] Call Trace:
[  119.021778]  ? dump_stack+0x5c/0x84
[  119.021784]  ? __schedule_bug+0x4c/0x70
[  119.021792]  ? __schedule+0x496/0x5c0
[  119.021798]  ? schedule+0x2d/0x80
[  119.021804]  ? schedule_preempt_disabled+0x5/0x10
[  119.021810]  ? __mutex_lock.isra.0+0x18e/0x4c0
[  119.021817]  ? __wake_up+0x2f/0x50
[  119.021833]  ? cfg80211_sched_scan_results+0x19/0x60 [cfg80211]
[  119.021844]  ? cfg80211_sched_scan_results+0x19/0x60 [cfg80211]
[  119.021859]  ? iwl_mvm_rx_lmac_scan_iter_complete_notif+0x17/0x30 [iwlmvm]
[  119.021869]  ? iwl_pcie_rx_handle+0x2a9/0x7e0 [iwlwifi]
[  119.021878]  ? iwl_pcie_irq_handler+0x17c/0x730 [iwlwifi]
[  119.021884]  ? irq_forced_thread_fn+0x60/0x60
[  119.021887]  ? irq_thread_fn+0x16/0x40
[  119.021892]  ? irq_thread+0x109/0x180
[  119.021896]  ? wake_threads_waitq+0x30/0x30
[  119.021901]  ? kthread+0xf2/0x130
[  119.021905]  ? irq_thread_dtor+0x90/0x90
[  119.021910]  ? kthread_create_on_node+0x40/0x40
[  119.021915]  ? ret_from_fork+0x26/0x40

Fixes: b34939b98369 ("cfg80211: add request id to cfg80211_sched_scan_*() api")
Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 net/wireless/scan.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 14d5f0c..9f0901f 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -322,9 +322,9 @@ static void cfg80211_del_sched_scan_req(struct cfg80211_registered_device *rdev,
 {
 	struct cfg80211_sched_scan_request *pos;
 
-	ASSERT_RTNL();
+	WARN_ON_ONCE(!rcu_read_lock_held() && !lockdep_rtnl_is_held());
 
-	list_for_each_entry(pos, &rdev->sched_scan_req_list, list) {
+	list_for_each_entry_rcu(pos, &rdev->sched_scan_req_list, list) {
 		if (pos->reqid == reqid)
 			return pos;
 	}
@@ -398,13 +398,13 @@ void cfg80211_sched_scan_results(struct wiphy *wiphy, u64 reqid)
 	trace_cfg80211_sched_scan_results(wiphy, reqid);
 	/* ignore if we're not scanning */
 
-	rtnl_lock();
+	rcu_read_lock();
 	request = cfg80211_find_sched_scan_req(rdev, reqid);
 	if (request) {
 		request->report_results = true;
 		queue_work(cfg80211_wq, &rdev->sched_scan_res_wk);
 	}
-	rtnl_unlock();
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(cfg80211_sched_scan_results);
 
-- 
1.9.1
