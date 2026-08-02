Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3156322576E
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 21:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785705515; cv=none; b=FF9DEPiDzJ2O0thM9fZXYWkqpNhIAWKTbs1DHbaq2PpVirYYMRKwEuotq4onKaQLuahwgUkg5vD5tRQ1U+WrXXXX0PtYpXqkQMXdIz5iiQswPSlhYDR8TVduaJhaZ4GK4zIvm9gh+hRWZtnhPXpPqXUUZzBaIWmJqDoXFA735qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785705515; c=relaxed/simple;
	bh=Hu6wuO1SNJA5jEeX1X8chWiEhaoijpdAxWBLbEnZDdc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tQ1N8c0LZyzou4KJYdWWLewUE3mNoIgCA9wvSivB2ps7nJ0HS+/sceihxLFnt2YHrT7UsLFttxFl/QrH9Nsz0YgSLiIdWV9eiAZxkt1+yC5sBf9XObI9q0lwshlNoHYWjJ5FP17GdOZ/ZmbMnMMnNeBzjtooKyGY6KKl3boQ/VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=e0zbHWVK; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="e0zbHWVK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=EOL0Izqb+cKqreAM50hWouywO9yGpOwwb+j/hEfzyQA=; t=1785705507; x=1786915107; 
	b=e0zbHWVKnuLAmwh+uJmAL5FmgmV0UT8Y24I3kiGbKQ/sLZ92+Twaw5ZWJQXGaDS2NAvRtLqbWji
	X3D93HKQm872FfWgWJ7WlQGzGmPC9vo5lOG4C1tZ6EBPg/PPGbVIFdgZdm+H1cTQEdvgDsXGlqKO1
	VFYJrMxt79Dtu06mrz4SSypePNJMAicZSepRlon4zaBxMuHBPZo3W4kTPCYgP2yUs1kpBdEATxnYH
	b1BmZo4ngqLoBNg670r5y9Bg6+T0q9MUZxa7f3SKC334TGFvuxgtewNRtwcwhc9d7Gp7sxz3aXBZ1
	MK7BlQ9yGNhCj+iEoOSIoc39cQV9AEFkHGFA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqdZe-0000000E1TG-0mSN;
	Sun, 02 Aug 2026 23:18:22 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: mac80211: remove ieee80211_sta_ps_transition() return value
Date: Sun,  2 Aug 2026 23:18:20 +0200
Message-ID: <20260802211819.1738465-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Nothing cares, so no point calculating it. Also simplify
the "no need to do anything" check and fix some docs that
should refer to this function instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 18 +++++-------------
 net/mac80211/rx.c      |  8 +++-----
 2 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9d1fac6e8082..638b8aa5214d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2919,8 +2919,8 @@ struct ieee80211_txq {
  *	autonomously manages the PS status of connected stations. When
  *	this flag is set mac80211 will not trigger PS mode for connected
  *	stations based on the PM bit of incoming frames.
- *	Use ieee80211_start_ps()/ieee8021_end_ps() to manually configure
- *	the PS mode of connected stations.
+ *	Use ieee80211_sta_ps_transition() to manually toggle the PS mode
+ *	of connected stations.
  *
  * @IEEE80211_HW_TX_AMPDU_SETUP_IN_HW: The device handles TX A-MPDU session
  *	setup strictly in HW. mac80211 should not attempt to do this in
@@ -5499,10 +5499,8 @@ static inline void ieee80211_rx_ni(struct ieee80211_hw *hw,
  *
  * @sta: currently connected sta
  * @start: start or stop PS
- *
- * Return: 0 on success. -EINVAL when the requested PS mode is already set.
  */
-int ieee80211_sta_ps_transition(struct ieee80211_sta *sta, bool start);
+void ieee80211_sta_ps_transition(struct ieee80211_sta *sta, bool start);
 
 /**
  * ieee80211_sta_ps_transition_ni - PS transition for connected sta
@@ -5514,19 +5512,13 @@ int ieee80211_sta_ps_transition(struct ieee80211_sta *sta, bool start);
  *
  * @sta: currently connected sta
  * @start: start or stop PS
- *
- * Return: Like ieee80211_sta_ps_transition().
  */
-static inline int ieee80211_sta_ps_transition_ni(struct ieee80211_sta *sta,
+static inline void ieee80211_sta_ps_transition_ni(struct ieee80211_sta *sta,
 						  bool start)
 {
-	int ret;
-
 	local_bh_disable();
-	ret = ieee80211_sta_ps_transition(sta, start);
+	ieee80211_sta_ps_transition(sta, start);
 	local_bh_enable();
-
-	return ret;
 }
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5e26be8e27d8..40ed03a775ba 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1744,7 +1744,7 @@ static void sta_ps_end(struct sta_info *sta)
 	ieee80211_sta_ps_deliver_wakeup(sta);
 }
 
-int ieee80211_sta_ps_transition(struct ieee80211_sta *pubsta, bool start)
+void ieee80211_sta_ps_transition(struct ieee80211_sta *pubsta, bool start)
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 	bool in_ps;
@@ -1753,15 +1753,13 @@ int ieee80211_sta_ps_transition(struct ieee80211_sta *pubsta, bool start)
 
 	/* Don't let the same PS state be set twice */
 	in_ps = test_sta_flag(sta, WLAN_STA_PS_STA);
-	if ((start && in_ps) || (!start && !in_ps))
-		return -EINVAL;
+	if (start == in_ps)
+		return;
 
 	if (start)
 		sta_ps_start(sta);
 	else
 		sta_ps_end(sta);
-
-	return 0;
 }
 EXPORT_SYMBOL(ieee80211_sta_ps_transition);
 
-- 
2.55.0

