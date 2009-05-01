Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52810 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbZEAWow (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 May 2009 18:44:52 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org
Subject: [PATCH] cfg80211: fix race condition with wiphy_apply_custom_regulatory()
Date: Fri,  1 May 2009 18:44:50 -0400
Message-Id: <1241217890-11650-1-git-send-email-lrodriguez@atheros.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We forgot to lock using the cfg80211_mutex in
wiphy_apply_custom_regulatory(). Without the lock
there is possible race between processing a reply from CRDA
and a driver calling wiphy_apply_custom_regulatory(). During
the processing of the reply from CRDA we free last_request and
wiphy_apply_custom_regulatory() eventually accesses an
element from last_request in the through freq_reg_info_regd().

This is very difficult to reproduce (I haven't), it takes us
3 hours and you need to be banging hard, but the race is obvious
by looking at the code.

This should only affect those who use this caller, which currently
is ath5k, ath9k, and ar9170.

EIP: 0060:[<f8ebec50>] EFLAGS: 00210282 CPU: 1
EIP is at freq_reg_info_regd+0x24/0x121 [cfg80211]
EAX: 00000000 EBX: f7ca0060 ECX: f5183d94 EDX: 0024cde0
ESI: f8f56edc EDI: 00000000 EBP: 00000000 ESP: f5183d44
DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 14617, ti=f5182000 task=f3934d10 task.ti=f5182000)
Stack: c0505300 f7ca0ab4 f5183d94 0024cde0 f8f403a6 f8f63160 f7ca0060 00000000
00000000 f8ebedf8 f5183d90 f8f56edc 00000000 00000004 00000f40 f8f56edc
f7ca0060 f7ca1234 00000000 00000000 00000000 f7ca14f0 f7ca0ab4 f7ca1289
Call Trace:
[<f8ebedf8>] wiphy_apply_custom_regulatory+0x8f/0x122 [cfg80211]
[<f8f3f798>] ath_attach+0x707/0x9e6 [ath9k]
[<f8f45e46>] ath_pci_probe+0x18d/0x29a [ath9k]
[<c023c7ba>] pci_device_probe+0xa3/0xe4
[<c02a860b>] really_probe+0xd7/0x1de
[<c02a87e7>] __driver_attach+0x37/0x55
[<c02a7eed>] bus_for_each_dev+0x31/0x57
[<c02a83bd>] driver_attach+0x16/0x18
[<c02a78e6>] bus_add_driver+0xec/0x21b
[<c02a8959>] driver_register+0x85/0xe2
[<c023c9bb>] __pci_register_driver+0x3c/0x69
[<f8e93043>] ath9k_init+0x43/0x68 [ath9k]
[<c010112b>] _stext+0x3b/0x116
[<c014a872>] sys_init_module+0x8a/0x19e
[<c01049ad>] sysenter_do_call+0x12/0x21
[<ffffe430>] 0xffffe430
=======================
Code: 0f 94 c0 c3 31 c0 c3 55 57 56 53 89 c3 83 ec 14 8b 74 24 2c 89 54 24 0c 89 4c 24 08 85 f6 75
06 8b 35 c8 bb ec f8 a1 cc bb ec f8 <8b> 40 04 83 f8 03 74 3a 48 74 37 8b 43 28 85 c0 74 30 89 c6
8b
EIP: [<f8ebec50>] freq_reg_info_regd+0x24/0x121 [cfg80211] SS:ESP 0068:f5183d44

Cc: stable@kernel.org
Reported-by: Nataraj Sadasivam <Nataraj.Sadasivam@Atheros.com>
Reported-by: Vivek Natarajan <Vivek.Natarajan@Atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 9fea910..11481b4 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -906,6 +906,7 @@ EXPORT_SYMBOL(freq_reg_info);
 int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 *bandwidth,
 			 const struct ieee80211_reg_rule **reg_rule)
 {
+	assert_cfg80211_lock();
 	return freq_reg_info_regd(wiphy, center_freq,
 		bandwidth, reg_rule, NULL);
 }
@@ -1177,6 +1178,8 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
 
+	assert_cfg80211_lock();
+
 	sband = wiphy->bands[band];
 	BUG_ON(chan_idx >= sband->n_channels);
 	chan = &sband->channels[chan_idx];
@@ -1215,10 +1218,13 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
 				   const struct ieee80211_regdomain *regd)
 {
 	enum ieee80211_band band;
+
+	mutex_lock(&cfg80211_mutex);
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		if (wiphy->bands[band])
 			handle_band_custom(wiphy, band, regd);
 	}
+	mutex_unlock(&cfg80211_mutex);
 }
 EXPORT_SYMBOL(wiphy_apply_custom_regulatory);
 
-- 
1.5.6.4

