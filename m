Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9699A3563E8
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 07:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785571118; cv=none; b=GAp1SsI/mK/pNp5t3S48ejPGiw6Nxz24VFK5ATIfO/vVbISj+deAzZxn18k/nFX9aA8WQylwev4WJGwT7IrkVzZFK/305X8r9OuGArI3rPdycEc/BHiG5a71JDGJUcb2lKTvPBZVr0GSO2sHyHlu9SXr1Oqb8BsdlZG7OFq38GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785571118; c=relaxed/simple;
	bh=BAwc9h/1zOFE8cILSUrQFIfRXNZD5TqLOhe5ZGqJR/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lyi/Swkkeh+I8Row+4dtRhSZ54nowgWVGSa0jJ0RjFVf75Uz0DAzNVPU7Eo1hqikI5EZJgy55Odx++KkNKjSlv5Me66XfH+GqJ5le911pBPDejH2OePTt+8N8qKY7NnayI6QcSP53eXUL6vppnow61F354LGcUx7jZod9oySKfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Q6kyf+zw; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Q6kyf+zw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=jfSo0c3h+n9M0Gw4Jm2bKnJJaCStELD4LlgJUMSSugU=;
	t=1785571116; x=1786780716; b=Q6kyf+zwtT9KOAGG4yuiK7Y0IWxHsIMSIBzVsGBncijik58
	Ohj8JQt9St6QiZDhPOiw47rTVH12XUE36caVvjGkW4vd5eTCFULruGHFV6ok1RbLcXVxVmLwyqf/D
	+J+lApzfgiV/rRWHYz6/YfwgRCOOUNvosDX51h/p50pOpB2EUUWGae6BOcH0qJZJHrPT16SMt3RNh
	WMyDDVHYW/zc6uVq13YSgnL2zJss36Kv99wZjWRj6oDfW1C+EBLWZo/eYs1T5znAEgI+D7FxftKsv
	S5Sk+AC/SPpnwg/wA3iBQaRWXm4X29vegDYgwuWsHDGMoNS0CnC5gdbzAZGne2Lg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wq4bz-0000000ErOv-1S5x;
	Sat, 01 Aug 2026 09:58:27 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 02/12] wifi: mac80211: clarify per-STA GTK handling code/docs
Date: Sat,  1 Aug 2026 09:58:18 +0200
Message-ID: <20260801095822.17bcbe0f7df8.Ib3a58f33a932b57be8a3e01b913b06f137f5c793@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260801075822.645974-14-johannes@sipsolutions.net>
References: <20260801075822.645974-14-johannes@sipsolutions.net>
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
index aae140fdc2bb..e9006e3a0c32 100644
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
index 4c9788ec0b74..ed08e011c1f2 100644
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
2.55.0

