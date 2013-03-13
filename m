Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:20103 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348Ab3CMMNV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 08:13:21 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/14] wil6210: use cfg80211_inform_bss_frame()
Date: Wed, 13 Mar 2013 14:12:44 +0200
Message-ID: <1363176771-10082-8-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130313_131355_018720_C303C4A0)
In-Reply-To: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid unnecessary frame parsing

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index dd3b7b1..9c06942 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -324,17 +324,9 @@ static void wmi_evt_rx_mgmt(struct wil6210_priv *wil, int id, void *d, int len)
 
 	if (ieee80211_is_beacon(fc) || ieee80211_is_probe_resp(fc)) {
 		struct cfg80211_bss *bss;
-		u64 tsf = le64_to_cpu(rx_mgmt_frame->u.beacon.timestamp);
-		u16 cap = le16_to_cpu(rx_mgmt_frame->u.beacon.capab_info);
-		u16 bi = le16_to_cpu(rx_mgmt_frame->u.beacon.beacon_int);
-		const u8 *ie_buf = rx_mgmt_frame->u.beacon.variable;
-		size_t ie_len = d_len - offsetof(struct ieee80211_mgmt,
-						 u.beacon.variable);
-		wil_dbg_wmi(wil, "Capability info : 0x%04x\n", cap);
-
-		bss = cfg80211_inform_bss(wiphy, channel, rx_mgmt_frame->bssid,
-					  tsf, cap, bi, ie_buf, ie_len,
-					  signal, GFP_KERNEL);
+
+		bss = cfg80211_inform_bss_frame(wiphy, channel, rx_mgmt_frame,
+						d_len, signal, GFP_KERNEL);
 		if (bss) {
 			wil_dbg_wmi(wil, "Added BSS %pM\n",
 				    rx_mgmt_frame->bssid);
-- 
1.7.10.4

