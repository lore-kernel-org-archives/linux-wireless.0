Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54264 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab1AaShl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:37:41 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] ath9k:  Show channel type and frequency in debugfs.
Date: Mon, 31 Jan 2011 10:37:36 -0800
Message-Id: <1296499056-6666-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
v2:  Merge with upstream code (virtual wiphy removal)

:100644 100644 2a813d7... e803b5c... M	drivers/net/wireless/ath/ath9k/debug.c
 drivers/net/wireless/ath/ath9k/debug.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 2a813d7..e803b5c 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -381,21 +381,40 @@ static const struct file_operations fops_interrupt = {
 	.llseek = default_llseek,
 };
 
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
 	struct ieee80211_channel *chan = sc->hw->conf.channel;
+	struct ieee80211_conf *conf = &(sc->hw->conf);
 	char buf[512];
 	unsigned int len = 0;
 	u8 addr[ETH_ALEN];
 	u32 tmp;
 
 	len += snprintf(buf + len, sizeof(buf) - len,
-			"%s (chan=%d ht=%d)\n",
+			"%s (chan=%d  center-freq: %d MHz  channel-type: %d (%s))\n",
 			wiphy_name(sc->hw->wiphy),
 			ieee80211_frequency_to_channel(chan->center_freq),
-			conf_is_ht(&sc->hw->conf));
+			chan->center_freq,
+			conf->channel_type,
+			channel_type_str(conf->channel_type));
 
 	put_unaligned_le32(REG_READ_D(sc->sc_ah, AR_STA_ID0), addr);
 	put_unaligned_le16(REG_READ_D(sc->sc_ah, AR_STA_ID1) & 0xffff, addr + 4);
-- 
1.7.2.3

