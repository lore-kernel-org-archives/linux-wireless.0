Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71DE4E8DF0
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 15:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788534079; cv=none; b=MGPdh9YdN0cc9DQncWOQ3iQ7qcY6PAkMIFzgRTLEYnuvhRVPqi9yHf87uqGQyz+S0PmeKDJVygWRvEn8+bJ0kJd2LJH2q0af+cS/aoZFQ+E+tF0nrZrz6HXnd8xcgrSnNneDP/fjKBnV+cvqh4WCUvgYlpfqga+YpjT5F3xos4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788534079; c=relaxed/simple;
	bh=xWD0E9lEKyMwE+AKr5hFYp5+ZJN1KrNn1aWaPFm06+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRIq5doQ/WW1Twkp2+W0T8Vdhh6WLjCOez/kFnjbuWmoMVtQetJ/mSeLYmc2xc1oVubftZ1DCQJo5Nt0wSi6PY+sf5fE1gal+CbzwTLuIUjEO6h5csCVoKlPpg1y54XuuXiEAVQbwW2yeh11KhzMeu5rYLUTgdH97MV2WMLx0UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=kM9+rlWp; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="kM9+rlWp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=1BxM+bqIN/Ls5B+9zdtk5V0LFeoQhFftwRtukGedJPY=;
	t=1788534076; x=1789743676; b=kM9+rlWpy4GldOH+WnPIvDk4dAtGBDsHniTd7oBfbHro5hl
	qEoCF/EToM5c18SjyLGNd6eLf02/kogaflG+wufo3PG+ILMcwWN4zZpmJ1EvQsWk0CuPIf3Ca5fPV
	DisGLx+kCqzax4CwbLpyMGz2o8f0vMMawS4ZfM6qLSkwMO3Oq0HBbRAKe3XQBWjsWoqgzrzn5H3Hj
	miTQxiZ8PrdCFRDfR49lm+k58dJcyjSFvUpfGdXeYy682pzO1T4ZbxNVgTw24fVyeXPwG8OKrCOWp
	WKQIMoOgfD+EYeYT7yxpeSAmVUxqcNpnQZBDh9Edu1VcSMCbSbrP3FYKraGSlwVA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VPj-00000001SeL-3yWB;
	Fri, 04 Sep 2026 17:01:12 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+435fdb053cf98bfa5778@syzkaller.appspotmail.com
Subject: [PATCH wireless 01/10] wifi: mac80211: don't allow injecting frames wider than the chanctx
Date: Fri,  4 Sep 2026 16:58:00 +0200
Message-ID: <20260904170057.d9ece19b7307.I51d783668ff3b22f5bb0faaa93ed8f45b129f2b8@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904150057.424369-12-johannes@sipsolutions.net>
References: <20260904150057.424369-12-johannes@sipsolutions.net>
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
index 4c34c3287eb4..9c10d2f0b8b4 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -967,7 +967,7 @@ static u16 ieee80211_monitor_select_queue(struct net_device *dev,
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

