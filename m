Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38399 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab1A2BFs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 20:05:48 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/3] ath9k:  Show channel type in debugfs.
Date: Fri, 28 Jan 2011 17:05:41 -0800
Message-Id: <1296263143-12404-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 25ea746... c3f495b... M	drivers/net/wireless/ath/ath9k/debug.c
 drivers/net/wireless/ath/ath9k/debug.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 25ea746..c3f495b 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -398,12 +398,30 @@ static const char * ath_wiphy_state_str(enum ath_wiphy_state state)
 	return "?";
 }
 
+static const char *channel_type_str(enum nl80211_channel_type t)
+{
+	switch (t) {
+	case NL80211_CHAN_NO_HT:
+		return "no ht";
+	case NL80211_CHAN_HT20:
+		return "ht20";
+	case NL80211_CHAN_HT40MINUS:
+		return "ht40-";
+	case NL80211_CHAN_HT40PLUS:
+		return "ht40+";
+	default:
+		return "???";
+	}
+}
+
 static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
 			       size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
 	struct ath_wiphy *aphy = sc->pri_wiphy;
 	struct ieee80211_channel *chan = aphy->hw->conf.channel;
+	struct ieee80211_conf *conf = &(aphy->hw->conf);
+
 	char buf[512];
 	unsigned int len = 0;
 	int i;
@@ -411,11 +429,12 @@ static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
 	u32 tmp;
 
 	len += snprintf(buf + len, sizeof(buf) - len,
-			"primary: %s (%s chan=%d ht=%d)\n",
+			"primary: %s (%s chan=%d  channel-type: %d (%s))\n",
 			wiphy_name(sc->pri_wiphy->hw->wiphy),
 			ath_wiphy_state_str(sc->pri_wiphy->state),
 			ieee80211_frequency_to_channel(chan->center_freq),
-			aphy->chan_is_ht);
+			conf->channel_type,
+			channel_type_str(conf->channel_type));
 
 	put_unaligned_le32(REG_READ_D(sc->sc_ah, AR_STA_ID0), addr);
 	put_unaligned_le16(REG_READ_D(sc->sc_ah, AR_STA_ID1) & 0xffff, addr + 4);
-- 
1.7.2.3

