Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:51759 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1ADXtH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 18:49:07 -0500
Subject: [RFC PATCH 09/17] zd1211rw: implement seq_num for
	IEEE80211_TX_CTL_ASSIGN_SEQ
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>
Date: Wed, 05 Jan 2011 01:49:02 +0200
Message-ID: <20110104234902.25309.49677.stgit@fate.lan>
In-Reply-To: <20110104234745.25309.72030.stgit@fate.lan>
References: <20110104234745.25309.72030.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |   21 +++++++++++++++++++++
 drivers/net/wireless/zd1211rw/zd_mac.h |    2 ++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 6be406e..aace010 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -654,6 +654,24 @@ static int zd_mac_config_beacon(struct ieee80211_hw *hw, struct sk_buff *beacon)
 			(full_len << 19));
 }
 
+static void create_tx_desc_seq(struct zd_mac *mac, struct ieee80211_hdr *hdr,
+			       struct ieee80211_tx_info *info)
+{
+	unsigned long irqflags;
+
+	if (!(info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ))
+		return;
+
+	spin_lock_irqsave(&mac->seqlock, irqflags);
+
+	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
+		mac->seqno += 0x10;
+	hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
+	hdr->seq_ctrl |= cpu_to_le16(mac->seqno);
+
+	spin_unlock_irqrestore(&mac->seqlock, irqflags);
+}
+
 static int fill_ctrlset(struct zd_mac *mac,
 			struct sk_buff *skb)
 {
@@ -678,6 +696,8 @@ static int fill_ctrlset(struct zd_mac *mac,
 
 	cs_set_control(mac, cs, hdr, info);
 
+	create_tx_desc_seq(mac, hdr, info);
+
 	packet_length = frag_len + sizeof(struct zd_ctrlset) + 10;
 	ZD_ASSERT(packet_length <= 0xffff);
 	/* ZD1211B: Computing the length difference this way, gives us
@@ -1117,6 +1137,7 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
 
 	memset(mac, 0, sizeof(*mac));
 	spin_lock_init(&mac->lock);
+	spin_lock_init(&mac->seqlock);
 	mac->hw = hw;
 
 	mac->type = NL80211_IFTYPE_UNSPECIFIED;
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.h b/drivers/net/wireless/zd1211rw/zd_mac.h
index 0ec6bde..e663451 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.h
+++ b/drivers/net/wireless/zd1211rw/zd_mac.h
@@ -186,6 +186,8 @@ struct zd_mac {
 	struct ieee80211_channel channels[14];
 	struct ieee80211_rate rates[12];
 	struct ieee80211_supported_band band;
+	spinlock_t seqlock;
+	u16 seqno;
 
 	/* Short preamble (used for RTS/CTS) */
 	unsigned int short_preamble:1;

