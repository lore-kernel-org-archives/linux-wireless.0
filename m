Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196C8489FBE
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 13:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789134414; cv=none; b=esixQqMWuz7/+Nxwi8cB5sRvOqC3l4J1QDG+LpX0O4xLdMha4r4IXdbgg8GzI5rMyIm/vVqy3fJg5JmMQqsp8cXHGPV0SemoMoh96VC5bzYz6+tTY+F573ynL54U/REzhckUouhPOm26iwjN538vEzU+aIRZmV2TBqmJbcINCVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789134414; c=relaxed/simple;
	bh=PKHIYdVpQCIGviuiDI5pQz0EJpNbRrIERl2cOYZ4mFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDPJGJmnT2t/OI3IkwwrWxdVHtUFksNEOG6jJUIvZj3zqbaDSD1OH/CkpNNa9XEx+ZgUD+qRFFnUE+Obksxa3fHmpXjZlmAU57KvID68DO33IgjJKJZ6zS4+krT+FNNxwRtayL3pslDYw2lOMo1UvyewojbzJNyigpGmTk8ssh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=fSapaBU2; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="fSapaBU2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=fEAZmInlK2Ijn6SbhW/4jDaNGy1U3XDWjUbLDXpiKbc=;
	t=1789134409; x=1790344009; b=fSapaBU2vR0/oTEN+6BSXepcQUu9Wju+sXRwNNmdGmJfyMj
	Rt/iFDzbQHvfWzgT0Q3HUfeJNMUAyYq7KQJtAPPnHuxmgE9FqRFLemd3Bf/IfvkpRPt4mJ13JqSE2
	L86dfhsqg/GV63Zv9Cuyx4JXeKrMkQxGt+vGGyCVlHBdGTwbL1vPVbXbwbBa08dbYu9AIsr094xNS
	fS2TFNBe03yLkOE4F6epWORUThbn1C5Qvss1XzJmgX/fexUE+OMatKxQ+Qqms/cr+hLm5BWFLBT5U
	pBAds/nDUvabDDxucgVFLTqHSL1JJNsW7Y53eyBz1Y0PQP+ea4IjYkDpft6A4npA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x51aP-0000000C1Tc-340Q;
	Fri, 11 Sep 2026 15:46:38 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 2/2] wifi: mac80211_hwsim: overwrite report SKB
Date: Fri, 11 Sep 2026 15:46:30 +0200
Message-ID: <20260911154632.c06da6d18055.Iaba24acec4c5765fbad77376418b17d1b863791b@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911154632.44cf5d8492c2.I9448bd3cea76eb90554ae73fc77e0a3092ff1271@changeid>
References: <20260911154632.44cf5d8492c2.I9448bd3cea76eb90554ae73fc77e0a3092ff1271@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

In a new test framework for hwsim I'm working on,
tests can modify the frame as it passes through
the wmediumd APIs. If then the original frame is
reported on the monitor interface, things get a
bit confusing.

Overwrite the frame that will be reported to the
monitor with the frame reported for RX if both
transmitter and cookie attributes are present
(wmediumd doesn't set them).

Also add a HWSIM_ATTR_NO_MONITOR flag to allow a
frame to be dropped entirely from monitor report,
e.g. in case it was never delivered to any peer.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/virtual/mac80211_hwsim.h |  5 +-
 .../wireless/virtual/mac80211_hwsim_main.c    | 52 ++++++++++++++++++-
 2 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.h b/drivers/net/wireless/virtual/mac80211_hwsim.h
index a022cd5c0f1c..1d2fd06c585a 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.h
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.h
@@ -3,7 +3,7 @@
  * mac80211_hwsim - software simulator of 802.11 radio(s) for mac80211
  * Copyright (c) 2008, Jouni Malinen <j@w1.fi>
  * Copyright (c) 2011, Javier Lopez <jlopex@gmail.com>
- * Copyright (C) 2020, 2022-2025 Intel Corporation
+ * Copyright (C) 2020, 2022-2026 Intel Corporation
  */
 
 #ifndef __MAC80211_HWSIM_H
@@ -162,6 +162,8 @@ enum hwsim_commands {
  *	each radio instead of for the wiphy.
  * @HWSIM_ATTR_SUPPORT_NAN_DEVICE: support NAN Device virtual interface (flag)
  * @HWSIM_ATTR_SUPPORT_BACKGROUND_RADAR: background radar/CAC support (flag)
+ * @HWSIM_ATTR_NO_MONITOR: skip monitor report for this TX status, e.g. in case
+ *	the frame was never reported to any receiver (flag)
  * @__HWSIM_ATTR_MAX: enum limit
  */
 enum hwsim_attrs {
@@ -197,6 +199,7 @@ enum hwsim_attrs {
 	HWSIM_ATTR_MULTI_RADIO,
 	HWSIM_ATTR_SUPPORT_NAN_DEVICE,
 	HWSIM_ATTR_SUPPORT_BACKGROUND_RADAR,
+	HWSIM_ATTR_NO_MONITOR,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index 4e73b9c7fdab..fca4bf823ef4 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -895,6 +895,7 @@ static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
 	[HWSIM_ATTR_MULTI_RADIO] = { .type = NLA_FLAG },
 	[HWSIM_ATTR_SUPPORT_NAN_DEVICE] = { .type = NLA_FLAG },
 	[HWSIM_ATTR_SUPPORT_BACKGROUND_RADAR] = { .type = NLA_FLAG },
+	[HWSIM_ATTR_NO_MONITOR] = { .type = NLA_FLAG },
 };
 
 #if IS_REACHABLE(CONFIG_VIRTIO)
@@ -6393,6 +6394,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	int i;
 	unsigned long flags;
 	bool found = false;
+	bool no_monitor;
 	u32 freq;
 
 	if (!info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER] ||
@@ -6405,6 +6407,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	src = (void *)nla_data(info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER]);
 	hwsim_flags = nla_get_u32(info->attrs[HWSIM_ATTR_FLAGS]);
 	ret_skb_cookie = nla_get_u64(info->attrs[HWSIM_ATTR_COOKIE]);
+	no_monitor = nla_get_flag(info->attrs[HWSIM_ATTR_NO_MONITOR]);
 
 	data2 = get_hwsim_data_ref_from_addr(src);
 	if (!data2)
@@ -6441,7 +6444,9 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 
 	txi = IEEE80211_SKB_CB(skb);
 	freq = (uintptr_t)txi->rate_driver_data[1];
-	mac80211_hwsim_monitor_rx(data2->hw, skb, freq);
+
+	if (!no_monitor)
+		mac80211_hwsim_monitor_rx(data2->hw, skb, freq);
 
 	/* Tx info received because the frame was broadcasted on user space,
 	 so we get all the necessary info: tx attempts and skb control buff */
@@ -6537,6 +6542,51 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 			goto out;
 	}
 
+	/* look for the skb matching the cookie passed back from user */
+	if (info->attrs[HWSIM_ATTR_COOKIE] &&
+	    info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER]) {
+		u64 cookie = nla_get_u64(info->attrs[HWSIM_ATTR_COOKIE]);
+		struct sk_buff *orig_skb, *found = NULL;
+		struct mac80211_hwsim_data *txdata;
+		struct ieee80211_tx_info *txi;
+		const u8 *transmitter;
+		unsigned long flags;
+
+		transmitter = nla_data(info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER]);
+		txdata = get_hwsim_data_ref_from_addr(transmitter);
+		if (!txdata || txdata->netgroup != data2->netgroup)
+			goto out;
+
+		spin_lock_irqsave(&txdata->pending.lock, flags);
+		skb_queue_walk(&txdata->pending, orig_skb) {
+			uintptr_t skb_cookie;
+
+			txi = IEEE80211_SKB_CB(orig_skb);
+			skb_cookie = (uintptr_t)txi->rate_driver_data[0];
+
+			if (skb_cookie == cookie) {
+				found = orig_skb;
+				break;
+			}
+		}
+
+		/* that's weird */
+		if (!found) {
+			spin_unlock_irqrestore(&txdata->pending.lock, flags);
+			goto out;
+		}
+
+		if (frame_data_len > found->len &&
+		    pskb_expand_head(found, 0, frame_data_len - found->len,
+				     GFP_ATOMIC)) {
+			spin_unlock_irqrestore(&txdata->pending.lock, flags);
+			goto out;
+		}
+		skb_trim(found, 0);
+		skb_put_data(found, frame_data, frame_data_len);
+		spin_unlock_irqrestore(&txdata->pending.lock, flags);
+	}
+
 	/* check if radio is configured properly */
 
 	if ((data2->idle && !data2->tmp_chan) || !data2->started)
-- 
2.55.0

