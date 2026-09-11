Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9486B489886
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 13:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789134414; cv=none; b=n9YqCgidXVExVtnOaUTQdTmtRkvbGxk7caI+9Zvjt5+9qCDrO4r0oupzSXu8zhDmvQF1x/NurD1hn6cSy8tro0Crne1Td/hfzvPgJ9f69EUa+kFMyfOjL/DAbfyHf1/2val4D6+U7Wa4kCIzVgKuV+3TlavFd8VYSwADnV186Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789134414; c=relaxed/simple;
	bh=ZM5AbXaQI6HqW+pZ8c4VK5TYq2Kf/3DOWiNa2j3np18=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u3RzsfuiaA86YgycGRgm3ltL+WyhgP10QU4pnJTEcor6RDtu5VNpUXUCIIXbkNV0jFeBbjoinSdafDJH2O+Hi3PTuRAqew76WewIIPKpgOWeGGHZVOANeRqmzf4KP1ctXVfyyIjBvo+qhXbCmFAU4POqlyqdVYr5f2ejmnuo/lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=CC+1DavA; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="CC+1DavA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=sDirhTxcEkDP5Q3L+SBZVklGqMTq4CstewpEaPbxWBo=; t=1789134407; x=1790344007; 
	b=CC+1DavAOdNTb8kgm6eR42oSatMRNHBVq8YxwRZ6bsDOL/wqpT2D5eag1PzhsE4eTgvYxXlxnyr
	0Iy8lRPFVdcVY0BOdc7AuL18Xqe45IOgapUj3MnLm/lkDT6ez8rogKP/HRIVziigydkj5N2oFAwgr
	JfmoB5g2BbbBSSqoY+32s3h4GqUsxvC7Uga8ftndEigQJBk2JXwvxmvpYt2OCPB+Ltg7GOesocnM5
	6DCy63Ns3e8+hYRXA0DpWG+N2C6MaRZ5VULd4caAIQM8i2tBddM6RMQXcmdyX0/weHg/JEdqNDhiR
	1EQlru/jq2gefA0Leno6iER2CIZT6b7lQV8Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x51aN-0000000C1Tc-3wDg;
	Fri, 11 Sep 2026 15:46:36 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 1/2] wifi: mac80211_hwsim: fix potential channel crash
Date: Fri, 11 Sep 2026 15:46:29 +0200
Message-ID: <20260911154632.44cf5d8492c2.I9448bd3cea76eb90554ae73fc77e0a3092ff1271@changeid>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

If wmediumd is used together with a hwsim radio that has
channel contexts enabled, the channel pointer can be NULL.

Track the frequency so we don't need it at that point,
avoiding the crash but still reporting the right freq.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 .../wireless/virtual/mac80211_hwsim_main.c    | 26 ++++++++++---------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index 02b6d81cccd1..4e73b9c7fdab 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -1337,7 +1337,7 @@ mac80211_hwsim_get_tx_rate(struct ieee80211_hw *hw,
 
 static void mac80211_hwsim_monitor_rx(struct ieee80211_hw *hw,
 				      struct sk_buff *tx_skb,
-				      struct ieee80211_channel *chan)
+				      u32 freq)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
 	struct sk_buff *skb;
@@ -1369,7 +1369,7 @@ static void mac80211_hwsim_monitor_rx(struct ieee80211_hw *hw,
 	hdr->rt_tsft = __mac80211_hwsim_get_tsf(data);
 	hdr->rt_flags = 0;
 	hdr->rt_rate = bitrate / 5;
-	hdr->rt_channel = cpu_to_le16(chan->center_freq);
+	hdr->rt_channel = cpu_to_le16(freq);
 	flags = IEEE80211_CHAN_2GHZ;
 	if (txrate && txrate->flags & IEEE80211_RATE_ERP_G)
 		flags |= IEEE80211_CHAN_OFDM;
@@ -1387,8 +1387,7 @@ static void mac80211_hwsim_monitor_rx(struct ieee80211_hw *hw,
 }
 
 
-static void mac80211_hwsim_monitor_ack(struct ieee80211_channel *chan,
-				       const u8 *addr)
+static void mac80211_hwsim_monitor_ack(u32 freq, const u8 *addr)
 {
 	struct sk_buff *skb;
 	struct hwsim_radiotap_ack_hdr *hdr;
@@ -1410,7 +1409,7 @@ static void mac80211_hwsim_monitor_ack(struct ieee80211_channel *chan,
 					  (1 << IEEE80211_RADIOTAP_CHANNEL));
 	hdr->rt_flags = 0;
 	hdr->pad = 0;
-	hdr->rt_channel = cpu_to_le16(chan->center_freq);
+	hdr->rt_channel = cpu_to_le16(freq);
 	flags = IEEE80211_CHAN_2GHZ;
 	hdr->rt_chbitmask = cpu_to_le16(flags);
 
@@ -1735,6 +1734,9 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 	if (nla_put_u64_64bit(skb, HWSIM_ATTR_COOKIE, cookie, HWSIM_ATTR_PAD))
 		goto nla_put_failure;
 
+	/* track the frequency */
+	info->rate_driver_data[1] = (void *)(uintptr_t)channel->center_freq;
+
 	genlmsg_end(skb, msg_head);
 
 	if (hwsim_virtio_enabled) {
@@ -1912,7 +1914,7 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 
 	mac80211_hwsim_write_tsf(data, skb, sim_tsf);
 
-	mac80211_hwsim_monitor_rx(hw, skb, chan);
+	mac80211_hwsim_monitor_rx(hw, skb, chan->center_freq);
 
 	memset(&rx_status, 0, sizeof(rx_status));
 	rx_status.flag |= RX_FLAG_MACTIME_START;
@@ -2276,7 +2278,7 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 	ack = mac80211_hwsim_tx_frame_no_nl(hw, skb, channel);
 
 	if (ack && skb->len >= 16)
-		mac80211_hwsim_monitor_ack(channel, hdr->addr2);
+		mac80211_hwsim_monitor_ack(channel->center_freq, hdr->addr2);
 
 	ieee80211_tx_info_clear_status(txi);
 
@@ -6391,6 +6393,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	int i;
 	unsigned long flags;
 	bool found = false;
+	u32 freq;
 
 	if (!info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER] ||
 	    !info->attrs[HWSIM_ATTR_FLAGS] ||
@@ -6436,7 +6439,9 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	if (!found)
 		goto out;
 
-	mac80211_hwsim_monitor_rx(data2->hw, skb, data2->channel);
+	txi = IEEE80211_SKB_CB(skb);
+	freq = (uintptr_t)txi->rate_driver_data[1];
+	mac80211_hwsim_monitor_rx(data2->hw, skb, freq);
 
 	/* Tx info received because the frame was broadcasted on user space,
 	 so we get all the necessary info: tx attempts and skb control buff */
@@ -6445,8 +6450,6 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 		       info->attrs[HWSIM_ATTR_TX_INFO]);
 
 	/* now send back TX status */
-	txi = IEEE80211_SKB_CB(skb);
-
 	ieee80211_tx_info_clear_status(txi);
 
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
@@ -6466,8 +6469,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	if (!(hwsim_flags & HWSIM_TX_CTL_NO_ACK) &&
 	   (hwsim_flags & HWSIM_TX_STAT_ACK)) {
 		if (skb->len >= 16)
-			mac80211_hwsim_monitor_ack(data2->channel,
-						   hdr->addr2);
+			mac80211_hwsim_monitor_ack(freq, hdr->addr2);
 		txi->flags |= IEEE80211_TX_STAT_ACK;
 	}
 
-- 
2.55.0

