Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4231 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbZC3MFe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 08:05:34 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] ath5k: reduce exported channel list
Date: Mon, 30 Mar 2009 08:05:29 -0400
Message-Id: <1238414729-29358-1-git-send-email-me@bobcopeland.com> (sfid-20090330_140547_645991_14FE60FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Claiming every available 5 ghz channel has a couple of negative
side-effects: scanning takes a long time, and the channel list
overflows the available buffer space for netlink commands,
resulting in:

    $ iw phy phy0 info
    command failed: No buffer space available (-105)

This patch adds a modparam so people who want to see all the channels
can do so by passing all_channels=1.  By default users will see a
smaller list of channels.  This also halves scan time, from 10 seconds
down to less than 5 when using world regulatory.

Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 5d57d77..a018106 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -64,6 +64,10 @@ static int modparam_nohwcrypt;
 module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
+static int modparam_all_channels;
+module_param_named(all_channels, modparam_all_channels, int, 0444);
+MODULE_PARM_DESC(all_channels, "Expose all channels the device can use.");
+
 
 /******************\
 * Internal defines *
@@ -862,6 +866,20 @@ ath5k_ieee2mhz(short chan)
 		return 2212 + chan * 20;
 }
 
+/*
+ * Returns true for the channel numbers used without all_channels modparam.
+ */
+static bool ath5k_is_standard_channel(short chan)
+{
+	return ((chan <= 14) ||
+		/* UNII 1,2 */
+		((chan & 3) == 0 && chan >= 36 && chan <= 64) ||
+		/* midband */
+		((chan & 3) == 0 && chan >= 100 && chan <= 140) ||
+		/* UNII-3 */
+		((chan & 3) == 1 && chan >= 149 && chan <= 165));
+}
+
 static unsigned int
 ath5k_copy_channels(struct ath5k_hw *ah,
 		struct ieee80211_channel *channels,
@@ -899,6 +917,9 @@ ath5k_copy_channels(struct ath5k_hw *ah,
 		if (!ath5k_channel_ok(ah, freq, chfreq))
 			continue;
 
+		if (!modparam_all_channels && !ath5k_is_standard_channel(ch))
+			continue;
+
 		/* Write channel info and increment counter */
 		channels[count].center_freq = freq;
 		channels[count].band = (chfreq == CHANNEL_2GHZ) ?
-- 
1.6.0.6


