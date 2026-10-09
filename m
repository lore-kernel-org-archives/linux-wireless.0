Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C291B399CE9
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 14:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557837; cv=none; b=Ak96jRCeSCQ+e53gnIwJhT1Rz8yASsXVJRKENqjsilZWNkmH6xVcav27uo3RRrjWD3B/jUzotfjpYyzIczwUjE8uXaz+KgxiK2UIBrmWBuensmZvV+LW4sYzUGQhBlOIJocPZAy+CaNwtMZGlNZz1B/MYsSllKMAWEbzUjggObA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557837; c=relaxed/simple;
	bh=0+MsifQ2Y/5QVP/uB21BGewbAzTEUvYZvwFpUptAd8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/jP11kXpp1TnN+jU9ZBIdVX5ztEyRZb29+twgnBHE+Qe0q24qVZgHGBBusa8YxDZnebEufYF8j/GauvIzTSdFm2ctvyrY4+K96j6TgVSurYUgZPe32G+b2jW7DgMdAlS71T5Ifo6VT/7NZOo2tajD08c/diwYRLn87numEp7DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=uq5JvcrE; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="uq5JvcrE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=dngO6HlMOU83J1F8ByUrYN3P3s2hIAoHFYt3L5HdWUY=;
	t=1791557835; x=1792767435; b=uq5JvcrE33zeExZfK6xiYFHwb7D0N81WkNwvOsZU23ful8/
	z8FLrPB8muFBz6ywgfPCS731VXMjI9IAXV3sbvbsi9nlPbLf7QCHzLBBrfaZckTgBputXAbKrPzVL
	BneDkJRUYI0u7ZClLB8+dZtrxMl8dKKbxiKhniMxQ3SNoj4kNJ0TKv/OW8DIYTGYqEE9m5BLF4vVD
	7Cc7U4+wsJDlevIOftthbY8dR+GNYMv5bLNG0MioMeO9Ia9nkDPnuvVi3uQqRgkdMnIl9hPxsS7ow
	nVkCMPQulVWbR2DXAFutFY0/igz3siQKxvuGSJTpCdbtmuPO+yPtKgiU2SnqUeFw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFC24-0000000AlEW-49rH;
	Fri, 09 Oct 2026 16:57:13 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 8/9] wifi: mac80211: don't hold RTNL for rate control algo
Date: Fri,  9 Oct 2026 16:56:23 +0200
Message-ID: <20261009165703.5b4bcd828435.I81141b28351e7c1ca23770616364346c33d7e08e@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009145703.243031-11-johannes@sipsolutions.net>
References: <20261009145703.243031-11-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Back when we supported algorithm switching at runtime, this
was needed for the open_count check. Now we don't have that
any more, so the check and RTNL section can go away.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/main.c | 4 +---
 net/mac80211/rate.c | 5 -----
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index ad7dfc07ee63..28480f983932 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1567,10 +1567,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (result)
 		goto fail_flows;
 
-	rtnl_lock();
 	result = ieee80211_init_rate_ctrl_alg(local,
 					      hw->rate_control_algorithm);
-	rtnl_unlock();
 	if (result < 0) {
 		wiphy_debug(local->hw.wiphy,
 			    "Failed to initialize rate control algorithm\n");
@@ -1689,9 +1687,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
  fail_wiphy_register:
  fail_band:
 	rtnl_lock();
-	rate_control_deinitialize(local);
 	ieee80211_remove_interfaces(local);
 	rtnl_unlock();
+	rate_control_deinitialize(local);
  fail_rate:
 	ieee80211_txq_teardown_flows(local);
  fail_flows:
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index f75257a19064..10e6ad537261 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -1001,11 +1001,6 @@ int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
 {
 	struct rate_control_ref *ref;
 
-	ASSERT_RTNL();
-
-	if (local->open_count)
-		return -EBUSY;
-
 	if (ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL)) {
 		if (WARN_ON(!local->ops->set_rts_threshold))
 			return -EINVAL;
-- 
2.56.0

