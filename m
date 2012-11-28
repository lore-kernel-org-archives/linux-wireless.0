Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45215 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab2K1UxW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 15:53:22 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mwifiex: fix struct member mismatch
Date: Wed, 28 Nov 2012 21:53:45 +0100
Message-Id: <1354136025-21915-1-git-send-email-johannes@sipsolutions.net> (sfid-20121128_215325_599969_E5DEF234)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Using bss->information_elements and treating
bss->len_beacon_ies as its size is wrong, the
real size is len_information_elements.

Found while I was reviewing the use of this
cfg80211 API (as it is actually potentially
broken due to races.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 24af6ba..f92047d 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -161,8 +161,9 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 	int ret;
 	u8 *beacon_ie;
 	struct mwifiex_bss_priv *bss_priv = (void *)bss->priv;
+	size_t beacon_ie_len = bss->len_information_elements;
 
-	beacon_ie = kmemdup(bss->information_elements, bss->len_beacon_ies,
+	beacon_ie = kmemdup(bss->information_elements, beacon_ie_len,
 			    GFP_KERNEL);
 	if (!beacon_ie) {
 		dev_err(priv->adapter->dev, " failed to alloc beacon_ie\n");
@@ -172,7 +173,7 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 	memcpy(bss_desc->mac_address, bss->bssid, ETH_ALEN);
 	bss_desc->rssi = bss->signal;
 	bss_desc->beacon_buf = beacon_ie;
-	bss_desc->beacon_buf_size = bss->len_beacon_ies;
+	bss_desc->beacon_buf_size = beacon_ie_len;
 	bss_desc->beacon_period = bss->beacon_interval;
 	bss_desc->cap_info_bitmap = bss->capability;
 	bss_desc->bss_band = bss_priv->band;
-- 
1.8.0

