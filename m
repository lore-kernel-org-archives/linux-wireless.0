Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66348538D7C
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 12:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788870527; cv=none; b=BM9GHaPd5aVL/1KcIfmi3k8p/IhIF5WHYgM5skLsJgYegYf+jr5iKCfd3TBSX8ZZjqkv0TsouVTceeGfpaLhP9DPckjL11RqBo1FhPvqm1ekcDduh6HK/7X0/8NZ95OY46mimhfV5bmQpnbOdDGDUZ/UhNoR5Mr/++gcBwmxL4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788870527; c=relaxed/simple;
	bh=QdDcX+74XzaRXCN8QATuw7b3pur6GQmwPyMaeFdpWv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDjJoINRi/l6RrZF21e1kUnDAjrH272i1LSz5Gk4w6SuB7B4RLYw37I3EIIDAJwogxKoiDNs8okQFW702B1Y2b5be7jrBtiRblejMgs8TXFKzAoE2CsgLB2MNG8loCuvIkwgy5fGwyaCO0aeVtLImHNrDI+ILNP45314TjrL5r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=qv+WmX3p; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="qv+WmX3p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=UelDERXWoTu7IP2uKYssh4HncoR31tsxCI3k13kHAgw=;
	t=1788870525; x=1790080125; b=qv+WmX3pIyvuV/wbbg1gmEidlfVUWmuR3sxnJR3IHC3w9LB
	NyplTQ6kDcmbpt95EKITwed5YTlZu63TreNKj1Azi/DGWABJctTxvnStOj4GKvPQL7Rc9ZlOjewtb
	qfnQlZp6FIlFokzmdZQVaFlNJiER4XU0eVI2NKwDsrLS/aqat27Fesv15iqADP3D3xX9kW3r+sB87
	nGmPXaOOAbJZEhlIOHT8MEhvkXM6VLkSssIATlDwG/SHoZzkFJjrMTXMMbDKJ/Rdw1kSUEygQpCzs
	ew2cfUflNk2lPdzsSgoUt+HHwsDCPaL++RJCfVOkERpQdP1JMfbW2tLANoFyOMCw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3uwM-0000000670J-15Q8;
	Tue, 08 Sep 2026 14:28:42 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+435fdb053cf98bfa5778@syzkaller.appspotmail.com
Subject: [PATCH RESEND wireless 01/10] wifi: mac80211: don't allow injecting frames wider than the chanctx
Date: Tue,  8 Sep 2026 14:28:12 +0200
Message-ID: <20260908122838.201719-13-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908122838.201719-12-johannes@sipsolutions.net>
References: <20260908122838.201719-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Frames injected on a monitor interface can carry a radiotap
field requesting a bandwidth, which mac80211 passes down to
the driver regardless of the the actual operational bandwidth.

If the bandwidth requested is too wide, that triggers a warning
in hwsim:

  WARN_ON(hwsim_get_chanwidth(bw) > hwsim_get_chanwidth(confbw))

Drop such frames entirely instead since they cannot be sent.

Assisted-by: LLM
Fixes: 646e76bb5daf ("mac80211: parse VHT info in injected frames")
Reported-by: syzbot+435fdb053cf98bfa5778@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=435fdb053cf98bfa5778
Link: https://patch.msgid.link/20260904170057.d9ece19b7307.I51d783668ff3b22f5bb0faaa93ed8f45b129f2b8@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |  5 ++++-
 net/mac80211/iface.c   |  2 +-
 net/mac80211/tx.c      | 28 ++++++++++++++++++++++++++--
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9d1fac6e8082..ed6a5874ff96 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -7638,11 +7638,14 @@ bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
  *
  * @skb: packet injected by userspace
  * @dev: the &struct device of this 802.11 device
+ * @chandef: the channel definition the frame will be transmitted on, or
+ *	%NULL to skip the bandwidth checks
  *
  * Return: %true if the radiotap header was parsed, %false otherwise
  */
 bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
-				 struct net_device *dev);
+				 struct net_device *dev,
+				 const struct cfg80211_chan_def *chandef);
 
 /**
  * struct ieee80211_noa_data - holds temporary data for tracking P2P NoA state
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 842bfb4a7cb6..ca66eb493ac7 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -991,7 +991,7 @@ static u16 ieee80211_monitor_select_queue(struct net_device *dev,
 	/* reset flags and info before parsing radiotap header */
 	memset(info, 0, sizeof(*info));
 
-	if (!ieee80211_parse_tx_radiotap(skb, dev))
+	if (!ieee80211_parse_tx_radiotap(skb, dev, NULL))
 		return 0; /* doesn't matter, frame will be dropped */
 
 	len_rthdr = ieee80211_get_radiotap_len(skb->data);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d155fb319a55..c343ed56506a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2105,8 +2105,29 @@ static bool ieee80211_validate_radiotap_len(struct sk_buff *skb)
 	return true;
 }
 
+static bool ieee80211_rate_bw_usable(u16 rate_flags,
+				     const struct cfg80211_chan_def *chandef)
+{
+	int width;
+
+	if (!chandef)
+		return true;
+
+	if (rate_flags & IEEE80211_TX_RC_160_MHZ_WIDTH)
+		width = 160;
+	else if (rate_flags & IEEE80211_TX_RC_80_MHZ_WIDTH)
+		width = 80;
+	else if (rate_flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+		width = 40;
+	else
+		return true;
+
+	return width <= cfg80211_chandef_get_width(chandef);
+}
+
 bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
-				 struct net_device *dev)
+				 struct net_device *dev,
+				 const struct cfg80211_chan_def *chandef)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_radiotap_iterator iterator;
@@ -2280,6 +2301,9 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 		struct ieee80211_supported_band *sband =
 			local->hw.wiphy->bands[info->band];
 
+		if (!ieee80211_rate_bw_usable(rate_flags, chandef))
+			return false;
+
 		info->control.flags |= IEEE80211_TX_CTRL_RATE_INJECT;
 
 		for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
@@ -2479,7 +2503,7 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	 * selected chandef above to accurately set injection rates and
 	 * retransmissions.
 	 */
-	if (!ieee80211_parse_tx_radiotap(skb, dev))
+	if (!ieee80211_parse_tx_radiotap(skb, dev, chandef))
 		goto fail_rcu;
 
 	/* remove the injection radiotap header */
-- 
2.55.0

