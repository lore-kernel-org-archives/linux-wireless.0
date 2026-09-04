Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2043DB62B
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 14:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788533861; cv=none; b=oNwzdvXe3pyY8jsHSuYKAJKe21st9kXsRIpscSpc/Q0B9lXTWkHm80u5RMGaufFNQsWC40OXdR2hlrssLfqjcr9Ffk7SE5tLNVvd1QxTl92lBnEVUkHAp6hiu5ew/+S2Rz+B557Q//9ITx8CBOLf2PFnrHv9urpStYI60eSeAHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788533861; c=relaxed/simple;
	bh=wlv9ZK40THUBfVcEtT+adee6lN5r4grWPt+bofaFLJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KormQPYXFqUcU/G9x620b1wmkHWXV1evhQPy/IDZ6V5mylNuALjt7Cjwgscdkm9zGE2jk0aAz797iDaJEgRQdBW5wpku1We9hWwJ58djxWgSGzH3bRaL00vZFPyGHRjS7xoMH1hTFmXU0GjP1oPe50w14VsmrosacJr6JCWDXTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=hOIqayhq; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="hOIqayhq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=IFvHpUXAyF9cYOuvJw31RNR3B2t1c6+wQDlColCA5lY=;
	t=1788533859; x=1789743459; b=hOIqayhqbU+0hb7xU6go0VXoCbk18cWb4cGbhUVzj9OMZPc
	q76toS2dkbdx4f+EvTYkwtJnnNjiwWQX6uZHPDfxNXU+10/dYFXAhMw7v8F0/c/+m0E2wK3gZglNu
	u4+fp6LAPWARMVY0uqKfPxy6OwUSDQ390EWN4hSRn+nNftBDpIS8ks8aMBA4KzFe267DOxgMMmuGg
	xN3JJqlL2j40FLex5jrthH3xhd9KLmrrLBm6R2D+GfLbzAr0u7QXwC8KkEheTmeYKM1IAIi7Td/GU
	FDW+a4EAc2n+Ww97C4M92p2yiq4c7gzTDb0RJlFbReMA26SQ1mN34h13qwjaldVw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VMG-00000001SWk-2tdQ;
	Fri, 04 Sep 2026 16:57:36 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+a59b5291776979816910@syzkaller.appspotmail.com
Subject: [PATCH wireless 10/10] wifi: mac80211: only operate on TDLS peers in the TDLS code
Date: Fri,  4 Sep 2026 16:57:14 +0200
Message-ID: <20260904165722.3bad8b79679b.I99618745e83cbe9b9804179387be15fcd3505ae3@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904145722.424159-12-johannes@sipsolutions.net>
References: <20260904145722.424159-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

ieee80211_tdls_oper() can operate on the AP station, which then
yields various warnings when the AP station is removed then or
at a later point in time after being confused for a TDLS peer.

Always check that the station is a TDLS peer.

Assisted-by: LLM
Fixes: dfe018bf9953 ("mac80211: handle TDLS high-level commands and frames")
Fixes: 17e6a59a365a ("mac80211: cleanup TDLS state during failed setup")
Reported-by: syzbot+a59b5291776979816910@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a59b5291776979816910
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tdls.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index dc2f662fe4c4..7f40b1d62938 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1142,6 +1142,7 @@ ieee80211_tdls_mgmt_setup(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_local *local = sdata->local;
 	enum ieee80211_smps_mode smps_mode =
 		sdata->deflink.u.mgd.driver_smps_mode;
+	struct sta_info *sta;
 	int ret;
 
 	/* don't support setup with forced SMPS mode that's not off */
@@ -1168,14 +1169,10 @@ ieee80211_tdls_mgmt_setup(struct wiphy *wiphy, struct net_device *dev,
 	 * Allow error packets to be sent - sometimes we don't even add a STA
 	 * before failing the setup.
 	 */
-	if (status_code == 0) {
-		rcu_read_lock();
-		if (!sta_info_get(sdata, peer)) {
-			rcu_read_unlock();
-			ret = -ENOLINK;
-			goto out_unlock;
-		}
-		rcu_read_unlock();
+	sta = sta_info_get(sdata, peer);
+	if ((status_code == 0 && !sta) || (sta && !sta->sta.tdls)) {
+		ret = -ENOLINK;
+		goto out_unlock;
 	}
 
 	ieee80211_flush_queues(local, sdata, false);
@@ -1442,6 +1439,10 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 	 */
 	tdls_dbg(sdata, "TDLS oper %d peer %pM\n", oper, peer);
 
+	sta = sta_info_get(sdata, peer);
+	if (!sta || !sta->sta.tdls)
+		return -ENOLINK;
+
 	switch (oper) {
 	case NL80211_TDLS_ENABLE_LINK:
 		if (sdata->vif.bss_conf.csa_active) {
@@ -1449,10 +1450,6 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 			return -EBUSY;
 		}
 
-		sta = sta_info_get(sdata, peer);
-		if (!sta || !sta->sta.tdls)
-			return -ENOLINK;
-
 		iee80211_tdls_recalc_chanctx(sdata, sta);
 		iee80211_tdls_recalc_ht_protection(sdata, sta);
 
-- 
2.55.0

