Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14421 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592AbaFPQiT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:38:19 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 05/25] wil6210: print more info about BSS found
Date: Mon, 16 Jun 2014 19:37:03 +0300
Message-ID: <1402936643-31819-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140616_183839_033567_C12CA973)
In-Reply-To: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

print essential info to dmesg

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 6cc0e18..1c5e6e9 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -327,6 +327,17 @@ static void wmi_evt_rx_mgmt(struct wil6210_priv *wil, int id, void *d, int len)
 
 	if (ieee80211_is_beacon(fc) || ieee80211_is_probe_resp(fc)) {
 		struct cfg80211_bss *bss;
+		u64 tsf = le64_to_cpu(rx_mgmt_frame->u.beacon.timestamp);
+		u16 cap = le16_to_cpu(rx_mgmt_frame->u.beacon.capab_info);
+		u16 bi = le16_to_cpu(rx_mgmt_frame->u.beacon.beacon_int);
+		const u8 *ie_buf = rx_mgmt_frame->u.beacon.variable;
+		size_t ie_len = d_len - offsetof(struct ieee80211_mgmt,
+						 u.beacon.variable);
+		wil_dbg_wmi(wil, "Capability info : 0x%04x\n", cap);
+		wil_dbg_wmi(wil, "TSF : 0x%016llx\n", tsf);
+		wil_dbg_wmi(wil, "Beacon interval : %d\n", bi);
+		wil_hex_dump_wmi("IE ", DUMP_PREFIX_OFFSET, 16, 1, ie_buf,
+				 ie_len, true);
 
 		bss = cfg80211_inform_bss_frame(wiphy, channel, rx_mgmt_frame,
 						d_len, signal, GFP_KERNEL);
-- 
1.9.1

