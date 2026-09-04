Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4ED4E8DEA
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 15:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788534081; cv=none; b=KDCAQ8BeZP1acnwcCT9WU5MGQ4GhfZlO6pe/6MsMDrO/3T0Fajbi1m154Rm3ihaWGx+Soh9+tno+fo9jPAIsnofkywguvAZKMWChjiiwg0HFo7NErxAHjMebz+i1pJpV2IWZzGWlqbaOFDtgqAQX/FiQKkRO+Ns8p8t301xVsNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788534081; c=relaxed/simple;
	bh=qe2ZL61dvbN6vV/uQfOajf6s2y8m+cvWpxiUBYLKFU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkKRiSHnTVbNzlLLoWf6U6aSs9Q66gB3Ebg2Ex9zT1+pJ8UGlHB+KD4uwV14PFFkMjEjStTEfzm+MjK5gwxFberAdnvbCw6y+Xxl6t22gXZy111GW4dDSWPocea2ZPLlqrpa9EVlky7Ubg0uv7GBHyeASEW3/xUIUoThWHX/tZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=OYtLMWIe; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="OYtLMWIe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=/pwPfUB8E+z3F/n+wJqz0CzrQK+zlJklxEDBQ99262A=;
	t=1788534077; x=1789743677; b=OYtLMWIeINwwYDERDale9zSf8ipU32ZKjnTcJTWc8x2LnKE
	dXPOn64tCfzXqLNXvddgEZU9xRwZ6m6srdD6nLc9CErCjGaUXVZ18Nlv0maGsMZ3gB3fPcmnzSVUS
	WJRm3LxWoq9OE7xMgTXvtZk9BmrZK3QhMv6WSgapeZ/iov2f5uE6LreSGfMZ2DhaFrVdpWAkzlabD
	qK6y66fDD/sscGkM3NQsf03Q0mk232svCWQ/z03V5vZwTjiIBVoH0s/93WmdnnfCgNuIPoEDCYoju
	AkLa6Q0PmzfZQRKAqtEWafeo7D3HBs/tMQmUOmliAtrkDHN3nGNir01TzWbko60w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VPl-00000001SeL-0ucq;
	Fri, 04 Sep 2026 17:01:13 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+e55106f8389651870be0@syzkaller.appspotmail.com
Subject: [PATCH wireless 03/10] wifi: mac80211: require a peer station for TDLS setup confirm
Date: Fri,  4 Sep 2026 16:58:02 +0200
Message-ID: <20260904170057.2ff31ae3e799.Ie409325ed6f2e55d2ef3ff2439e0c054dc8233b8@changeid>
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

