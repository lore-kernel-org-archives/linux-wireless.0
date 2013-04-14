Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.nanl.de ([217.115.11.12]:52893 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab3DNMNe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Apr 2013 08:13:34 -0400
From: Jonas Gorski <jogo@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Adrian Chadd <adrian@freebsd.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] mwl8k: remove nonstandard rate 72 Mbps
Date: Sun, 14 Apr 2013 14:11:58 +0200
Message-Id: <1365941518-4963-1-git-send-email-jogo@openwrt.org> (sfid-20130414_141346_740464_E0A058E9)
In-Reply-To: <1365849071-2389-1-git-send-email-jogo@openwrt.org>
References: <1365849071-2389-1-git-send-email-jogo@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This rate causes an overflow in the extended rates IE's data rate field,
with the overflowing bit setting the Basic Rate Set membership. This
results in a bogus 8 Mpbs basic rate, making clients checking them refuse
association.

Since the rate is likely unused anyway (HT will yield better rates between
supporting chips), we can just remove it.

This fixes association from wpa_supplicant and Android 4.x and newer.

Signed-off-by: Jonas Gorski <jogo@openwrt.org>
---
Changes from RFC -> v1
 * only remove 72 Mbps, as that's the problematic one
 * reword everything, add real cause

 drivers/net/wireless/mwl8k.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index ee1778c..6820fce 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -193,10 +193,10 @@ struct mwl8k_priv {
 	struct rxd_ops *rxd_ops;
 	struct ieee80211_supported_band band_24;
 	struct ieee80211_channel channels_24[14];
-	struct ieee80211_rate rates_24[14];
+	struct ieee80211_rate rates_24[13];
 	struct ieee80211_supported_band band_50;
 	struct ieee80211_channel channels_50[4];
-	struct ieee80211_rate rates_50[9];
+	struct ieee80211_rate rates_50[8];
 	u32 ap_macids_supported;
 	u32 sta_macids_supported;
 
@@ -366,7 +366,6 @@ static const struct ieee80211_rate mwl8k_rates_24[] = {
 	{ .bitrate = 360, .hw_value = 72, },
 	{ .bitrate = 480, .hw_value = 96, },
 	{ .bitrate = 540, .hw_value = 108, },
-	{ .bitrate = 720, .hw_value = 144, },
 };
 
 static const struct ieee80211_channel mwl8k_channels_50[] = {
@@ -385,7 +384,6 @@ static const struct ieee80211_rate mwl8k_rates_50[] = {
 	{ .bitrate = 360, .hw_value = 72, },
 	{ .bitrate = 480, .hw_value = 96, },
 	{ .bitrate = 540, .hw_value = 108, },
-	{ .bitrate = 720, .hw_value = 144, },
 };
 
 /* Set or get info from Firmware */
@@ -3083,11 +3081,11 @@ static void legacy_rate_mask_to_array(u8 *rates, u32 mask)
 	int j;
 
 	/*
-	 * Clear nonstandard rates 4 and 13.
+	 * Clear nonstandard rate 4.
 	 */
 	mask &= 0x1fef;
 
-	for (i = 0, j = 0; i < 14; i++) {
+	for (i = 0, j = 0; i < 13; i++) {
 		if (mask & (1 << i))
 			rates[j++] = mwl8k_rates_24[i].hw_value;
 	}
-- 
1.7.10.4

