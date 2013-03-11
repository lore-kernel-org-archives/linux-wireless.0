Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.nanl.de ([217.115.11.12]:52701 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab3CKQpA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 12:45:00 -0400
From: Jonas Gorski <jogo@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>
Subject: [PATCH] mwl8k: don't overwrite regulatory settings on fw reload
Date: Mon, 11 Mar 2013 17:44:21 +0100
Message-Id: <1363020261-27559-1-git-send-email-jogo@openwrt.org> (sfid-20130311_174506_135185_46B73EAD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the caps are parsed on every firmware reload, causing any
channel flags to be cleared.
When there is a firmware to interface mode mismatch, the triggered
firmware reload causes a reset of the regulatory settings, causing all
channels to become available:

root@openrouter:/# iw phy phy0 info
Wiphy phy0
        Band 1:
		(...)
                Frequencies:
                        * 2412 MHz [1] (0.0 dBm)
                        * 2417 MHz [2] (0.0 dBm)
                        * 2422 MHz [3] (0.0 dBm)
                        * 2427 MHz [4] (0.0 dBm)
                        * 2432 MHz [5] (0.0 dBm)
                        * 2437 MHz [6] (0.0 dBm)
                        * 2442 MHz [7] (0.0 dBm)
                        * 2447 MHz [8] (0.0 dBm)
                        * 2452 MHz [9] (0.0 dBm)
                        * 2457 MHz [10] (0.0 dBm)
                        * 2462 MHz [11] (0.0 dBm)
                        * 2467 MHz [12] (0.0 dBm)
                        * 2472 MHz [13] (0.0 dBm)
                        * 2484 MHz [14] (0.0 dBm)
		(...)

To prevent this, only parse the caps on the first firmware load during
hardware probe, and store them locally to know we have already parsed
them.

Signed-off-by: Jonas Gorski <jogo@openwrt.org>
---
 drivers/net/wireless/mwl8k.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index aaaf10d..0640e7d 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -232,6 +232,7 @@ struct mwl8k_priv {
 	u16 num_mcaddrs;
 	u8 hw_rev;
 	u32 fw_rev;
+	u32 caps;
 
 	/*
 	 * Running count of TX packets in flight, to avoid
@@ -2410,6 +2411,9 @@ mwl8k_set_caps(struct ieee80211_hw *hw, u32 caps)
 {
 	struct mwl8k_priv *priv = hw->priv;
 
+	if (priv->caps)
+		return;
+
 	if ((caps & MWL8K_CAP_2GHZ4) || !(caps & MWL8K_CAP_BAND_MASK)) {
 		mwl8k_setup_2ghz_band(hw);
 		if (caps & MWL8K_CAP_MIMO)
@@ -2421,6 +2425,8 @@ mwl8k_set_caps(struct ieee80211_hw *hw, u32 caps)
 		if (caps & MWL8K_CAP_MIMO)
 			mwl8k_set_ht_caps(hw, &priv->band_50, caps);
 	}
+
+	priv->caps = caps;
 }
 
 static int mwl8k_cmd_get_hw_spec_sta(struct ieee80211_hw *hw)
-- 
1.7.10.4

