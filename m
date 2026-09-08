Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE143538D90
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 12:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788870528; cv=none; b=d2R6GklwTJ4Brq0T34esr27KKIuXKtqUhPs5q55Aavy4FSLT5cDzHie8KpQcz79N6rjvURlU4qZtId1jyxkRd7A1N18FDtugvgmbMcIAID0nHI6XLK9oYLmi8bsILHh3fvwiA5iah7KLqY9EnbcauA0BX1kzndBqPcOE26RrM7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788870528; c=relaxed/simple;
	bh=znRY4K9UzUAnDWg3WbqQAuN777W1KV/eUVQV9DvOuos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cS+JkBWc/1aNqhniw+HPufTgX08RpBPRvJwD3UHgcWvTL3wx3/enjv59stQTiJfN3a1DN0E+GuK/q3Mmt8g6/K2lscOCYJfF+5cQnHRM7zz3xynGkg/zieE4ABPhMBRwH0oSW77uw03gSuTr1DP3OCI+1Hm2revmR5VG6VUCIfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=iTTF20HK; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="iTTF20HK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=q7HJf76iNegry2KkPA1WYvazmUYACYNcGCBwUVAztL8=;
	t=1788870526; x=1790080126; b=iTTF20HKvurEaP3PCkQ1+tUPBYnJJG+wmi/hYXx2aM/EcHi
	0UysLQjaRWHkC17oYe7s+c0ZoSgdDhyXbNUBL6RMWG9V3kO5goVvgFO+ouMxf3OuLlMZ/+1QTu9AS
	uxpE1t8WRwVA10GggLlY36C3ebh20tHEnXohb2ppsKvURap/wJ2wLxQblJ1w4sLKMlUsBhtryTvF4
	ss+V+nm6BpAQt9/FAx7xXyT2z9CgT8fphabj9Q5INIMVzITjQ4YZHthtv68tWNawSwg0r+iY2YaL3
	W/I9/H6DZiBt64YeyRaBoZsDDVRCLb7dyntkxmzzyjd7c4uvDUuX/DrHASgJ9j8g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3uwN-0000000670J-3JYe;
	Tue, 08 Sep 2026 14:28:43 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+e55106f8389651870be0@syzkaller.appspotmail.com
Subject: [PATCH RESEND wireless 03/10] wifi: mac80211: require a peer station for TDLS setup confirm
Date: Tue,  8 Sep 2026 14:28:14 +0200
Message-ID: <20260908122838.201719-15-johannes@sipsolutions.net>
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

It's nonsense for the setup confirm to go to station that
doesn't even exist, and it hits a warning when building
the frame:

  WARN_ON_ONCE(!sta || !ap_sta)

Only accept WLAN_TDLS_SETUP_CONFIRM when the station is
already there as a TDLS station. Need to copy the call
to ieee80211_tdls_prep_mgmt_packet() since the existing
WLAN_TDLS_DISCOVERY_REQUEST already falls through to it.

Assisted-by: LLM
Fixes: 6f7eaa47e1de ("mac80211: add TDLS QoS param IE on setup-confirm")
Reported-by: syzbot+e55106f8389651870be0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e55106f8389651870be0
Link: https://patch.msgid.link/20260904170057.2ff31ae3e799.Ie409325ed6f2e55d2ef3ff2439e0c054dc8233b8@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tdls.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 7f40b1d62938..f663d28d9209 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1281,6 +1281,24 @@ int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 						   peer_capability, initiator,
 						   extra_ies, extra_ies_len);
 		break;
+	case WLAN_TDLS_SETUP_CONFIRM: {
+		struct sta_info *sta;
+
+		sta = sta_info_get(sdata, peer);
+		if (!sta || !sta->sta.tdls) {
+			ret = -ENOLINK;
+			break;
+		}
+
+		ret = ieee80211_tdls_prep_mgmt_packet(wiphy, dev, peer,
+						      link_id, action_code,
+						      dialog_token,
+						      status_code,
+						      peer_capability,
+						      initiator, extra_ies,
+						      extra_ies_len, 0, NULL);
+		break;
+	}
 	case WLAN_TDLS_DISCOVERY_REQUEST:
 		/*
 		 * Protect the discovery so we can hear the TDLS discovery
@@ -1289,7 +1307,6 @@ int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 		 */
 		drv_mgd_protect_tdls_discover(sdata->local, sdata, link_id);
 		fallthrough;
-	case WLAN_TDLS_SETUP_CONFIRM:
 	case WLAN_PUB_ACTION_TDLS_DISCOVER_RES:
 		/* no special handling */
 		ret = ieee80211_tdls_prep_mgmt_packet(wiphy, dev, peer,
-- 
2.55.0

