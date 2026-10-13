Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F4F5013BB
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896775; cv=none; b=DHEmgaa7WV7u0SktdkX3hebidB6O/uCZgnyrqg8dsu+DHjnaR3BSeKQ3eN5Uono6bMikn5eM10WRbx9ObNlCuFX2mBQqvhQWqI1JqJF8CfOe7OQ2gVVT9I8IgAqZr+iKlB4hJMKfNU89bmwzzMfDJnEAArmbfda1gC6xa+c+Otg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896775; c=relaxed/simple;
	bh=/4K6YVA1EI6Gc2uhTC3vHJcw9gg4MD9zcw+tzkj6dnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGmKwQ8VRinmdgsV3HRR/nf5efccFwhPj9q0uzdVsNuRa5jkKoL4z5hE9+fVzbb8D/7H3ZTVA6H92XU/v+LxKVvgW3ybU+CtF+kOZBEYamzN+7xq/mPavdOg71/q+AOECohX/U3IOhvOh5+IAn0C8wAj/zu4P1EXTMTxgP592dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ieJkd4iN; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ieJkd4iN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=agC+J2xPKJP6GCsANeoOKynA/6oH4SfoeX48qxzWNWg=;
	t=1791896773; x=1793106373; b=ieJkd4iNyT9TCS9GCv50JaWOPvClTNaiLqf0iU4NHPpXKVt
	+DDgWUTVfPY948P5kLAFeLY/3y2Va/WSP4wDyBMqAMETzkIHPt0idH4cUuCZeqfeiJk7AuFIROsNh
	le+uOicpEo1/odj7ttXJ2f/R50yjceYp5ptSeIxaKs9Ve1Mokgdd5O2901n1PYqmEXUHlDnm7mWrp
	uEVN0JfqXAI4S36n8poTcqwt0Ip4lR3ryCgyo27yEcjH3xtaeVmifmVzr4EuJKXFY/MkGWlYOZ0yn
	BeU7YShgr7PDeJBySsy5mgGtqUcdHHGgX/4Ez+TxWdQJqqJIkIT66C3pd8bQZ++g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcCp-0000000HPRi-10Tu;
	Tue, 13 Oct 2026 15:06:11 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 04/11] wifi: mac80211: clarify per-STA GTK handling code/docs
Date: Tue, 13 Oct 2026 14:59:06 +0200
Message-ID: <20261013150604.1c281934305e.Ib3a58f33a932b57be8a3e01b913b06f137f5c793@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013130604.254393-13-johannes@sipsolutions.net>
References: <20261013130604.254393-13-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The FT case in the documentation cannot happen, because
the way mac80211 handles FT (now) doesn't add a station
entry before the actual BSS transition. In addition, the
documentation doesn't mention mesh, which also uses this
flag. NAN was always allowing it, out of necessity.

Also clarify that other interface types aren't supported
(for now) at all, which is already rejected by cfg80211
but checking here is easy and makes the code clearer.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 12 +++++++-----
 net/mac80211/key.c     | 18 ++++++++++++++----
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2272d7c85dd4..a25f499f3e9f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2918,11 +2918,13 @@ struct ieee80211_txq {
  *	dtim_period).
  *
  * @IEEE80211_HW_SUPPORTS_PER_STA_GTK: The device's crypto engine supports
- *	per-station GTKs as used by IBSS RSN or during fast transition. If
- *	the device doesn't support per-station GTKs, but can be asked not
- *	to decrypt group addressed frames, then IBSS RSN support is still
- *	possible but software crypto will be used. Advertise the wiphy flag
- *	only in that case.
+ *	per-station GTKs as used by IBSS RSN and mesh. If the device doesn't
+ *	support per-station GTKs, but can be asked not to decrypt group
+ *	addressed frames, then IBSS RSN support is still possible but
+ *	software crypto must be used. Drivers advertise the wiphy flag
+ *	(%WIPHY_FLAG_IBSS_RSN) instead in that case.
+ *	For mesh, it's assumed that either this flag is set or SW crypto
+ *	can be used, regardless of additional wiphy flags.
  *
  * @IEEE80211_HW_AP_LINK_PS: When operating in AP mode the device
  *	autonomously manages the PS status of connected stations. When
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index b55de973a929..112060c5e2cf 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -155,10 +155,20 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	 * per-station GTKs are required to be supported if secure NAN is
 	 * supported).
 	 */
-	if (sta && !(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE) &&
-	    !(ieee80211_hw_check(&key->local->hw, SUPPORTS_PER_STA_GTK) ||
-	      sdata->vif.type == NL80211_IFTYPE_NAN_DATA))
-		goto out_unsupported;
+	if (sta && !(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
+		switch (sdata->vif.type) {
+		case NL80211_IFTYPE_NAN_DATA:
+			break;
+		case NL80211_IFTYPE_ADHOC:
+		case NL80211_IFTYPE_MESH_POINT:
+			if (!(ieee80211_hw_check(&key->local->hw,
+						 SUPPORTS_PER_STA_GTK)))
+				goto out_unsupported;
+			break;
+		default:
+			goto out_unsupported;
+		}
+	}
 
 	if (sta && !sta->uploaded)
 		goto out_unsupported;
-- 
2.56.0

