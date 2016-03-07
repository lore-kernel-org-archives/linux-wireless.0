Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40209 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbcCGHMm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 02:12:42 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH] mac80211: Allow probe response frame rx to user space in AP mode
Date: Mon, 7 Mar 2016 12:42:11 +0530
Message-ID: <1457334731-6456-1-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20160307_081245_432511_51D98DBF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Especially during off-channel scan user space might be interested
in probe reponse frames along with beacon to build a list
of preferred channel and bssid which could be sent to the stations
around for better spectrum management. Do not drop probe response
frame in AP mode and advertise driver's capability to receive probe
response frame in AP mode to user space.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 net/mac80211/main.c | 2 ++
 net/mac80211/rx.c   | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 8190bf2..c8a97da 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -401,6 +401,7 @@ ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 		.rx = BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
 			BIT(IEEE80211_STYPE_REASSOC_REQ >> 4) |
 			BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
+			BIT(IEEE80211_STYPE_PROBE_RESP >> 4) |
 			BIT(IEEE80211_STYPE_DISASSOC >> 4) |
 			BIT(IEEE80211_STYPE_AUTH >> 4) |
 			BIT(IEEE80211_STYPE_DEAUTH >> 4) |
@@ -412,6 +413,7 @@ ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 		.rx = BIT(IEEE80211_STYPE_ASSOC_REQ >> 4) |
 			BIT(IEEE80211_STYPE_REASSOC_REQ >> 4) |
 			BIT(IEEE80211_STYPE_PROBE_REQ >> 4) |
+			BIT(IEEE80211_STYPE_PROBE_RESP >> 4) |
 			BIT(IEEE80211_STYPE_DISASSOC >> 4) |
 			BIT(IEEE80211_STYPE_AUTH >> 4) |
 			BIT(IEEE80211_STYPE_DEAUTH >> 4) |
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 9127957..9d8f8ea 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3464,6 +3464,8 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 				return false;
 			if (ieee80211_is_public_action(hdr, skb->len))
 				return true;
+			if (ieee80211_is_probe_resp(hdr->frame_control))
+				return true;
 			return ieee80211_is_beacon(hdr->frame_control);
 		}
 
-- 
1.9.1

