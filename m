Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59233 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab1L0JEC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Dec 2011 04:04:02 -0500
Date: Tue, 27 Dec 2011 11:03:53 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Advertise TX/RX support for frames in AP mode
Message-ID: <20111227090353.GA14432@jouni.qca.qualcomm.com> (sfid-20111227_100405_729582_CF8D2C5C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed to fix current hostapd/wpa_supplicant AP operations for
frame registration. P2P GO mode already advertised these, but AP mode
was forgotten and could not be used after the hostapd/wpa_supplicant
frame registration changes.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index f74762e..c756425 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2572,6 +2572,12 @@ ath6kl_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
 		BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
 	},
+	[NL80211_IFTYPE_AP] = {
+		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_RESP >> 4),
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
+	},
 	[NL80211_IFTYPE_P2P_CLIENT] = {
 		.tx = BIT(IEEE80211_STYPE_ACTION >> 4) |
 		BIT(IEEE80211_STYPE_PROBE_RESP >> 4),
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
