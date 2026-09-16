Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBD64BB7E4
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 10:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789552910; cv=none; b=sKs9vqN9UOatb3gOhA5jtNjNF+HfG2ysUDbf4p2to5YAaLNPrdKRQ102twDNcyUt+VpUxQa6UWAxze5RXWd4R0GQDvK9p0C8qyDJT8Hq6RSA6e68JRutXaAKcvXbvTzAVZgSe4pD6FJV1DLE8NnzdWup21d83BxusjSYORUSH8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789552910; c=relaxed/simple;
	bh=1Koj2ZmNJ7SXo8+Y9bfTq2KmjAIHnChZYnUVS2GEJ20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6HnoYo/o5QtwnshYbyi64B4+PxT+jl2f2rvjVieUfmfMSL3tG9b6GUpXhSJmXn98WIkq6fpeChL5VJNqXVLRY0auQS6MuJNgesqhzr585u66qfnsMth8BER/HQ2qFzJml/zzNsf3VMqGM/ACR0ehKI6CRMvkhYG//4i0FVHA2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Np+193TE; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Np+193TE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Yx7OcxfoNzBgWk84w+WmPfoh8UK9ylq2w2wjFQjBqlc=;
	t=1789552896; x=1790762496; b=Np+193TEORu4o8VIvoYArbUNhzw+dErEO749Tv78MWaeBX0
	FTV6Ny7PBFpd9NPJK+KDMszV8iVkIJDr4pJxJFwMcunco8eI2SI6o/q/olSTVl0b6vIc/PMEQwT0M
	ccl15uVNOI149CZL+p5KVI8SozDZgA52+wFhsC4xv316IjkBj0QVBtqqfck3NHHTMeqQ3RR8F9ijK
	tNO6NkXtawSO5cd6e2g5/4XiNaxwM7LUj62Z0aru8JpIutyHb4YHQOFxlHz/8vJLufb7gSL9R4rLB
	AtcJ9MkmyjZe+XwPJ99ZomNeuEAuoOjjGnDrtYOceCtHZHjCa5O8M3npgal/zMgw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x6mSJ-00000000bUb-48fn;
	Wed, 16 Sep 2026 12:01:32 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 2/2] wifi: mac80211: allow advertising 20 MHz-only non-AP STA
Date: Wed, 16 Sep 2026 12:01:27 +0200
Message-ID: <20260916120127.6e74579d46db.I628aed79ec7f9bf2f8e770b4866ed98cf1ddbe60@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916120127.efa58d51d11f.Ie29dc83578893945231db3badfcb7b4a2e2775ba@changeid>
References: <20260916120127.efa58d51d11f.Ie29dc83578893945231db3badfcb7b4a2e2775ba@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

802.11 Clause 27 (HE) already defined a 20 MHz-only non-AP
HE STA in the 5 GHz band, where VHT is required, although
VHT in Clause 21 requires 20, 40 and 80 MHz support. The
VHT requirement is implemented in mac80211, but the later
allowance for 20 MHz-only since HE wasn't.

Allow a device to be a 20 MHz-only non-AP STA and require
that it support VHT, but not that it has 80 MHz support,
if it's HE as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 189dd3467f76..cf3873d8855b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6513,7 +6513,7 @@ ieee80211_determine_our_sta_mode(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_sta_ht_cap sta_ht_cap = sband->ht_cap;
 	bool is_5ghz = sband->band == NL80211_BAND_5GHZ;
 	bool is_6ghz = sband->band == NL80211_BAND_6GHZ;
-	const struct ieee80211_sta_he_cap *he_cap;
+	const struct ieee80211_sta_he_cap *he_cap = NULL;
 	const struct ieee80211_sta_eht_cap *eht_cap;
 	const struct ieee80211_sta_uhr_cap *uhr_cap;
 	struct ieee80211_sta_vht_cap vht_cap;
@@ -6577,7 +6577,15 @@ ieee80211_determine_our_sta_mode(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
-	if (vht_cap.vht_supported && is_5ghz) {
+	if (req && req->flags & ASSOC_REQ_DISABLE_HE && !is_6ghz)
+		mlme_link_id_dbg(sdata, link_id,
+				 "HE disabled by flag, limiting to HT/VHT\n");
+	else
+		he_cap = ieee80211_get_he_iftype_cap_vif(sband, &sdata->vif);
+
+	if (vht_cap.vht_supported && is_5ghz && he_cap) {
+		/* nothing - since HE we can be 20 MHz-only non-AP STA */
+	} else if (vht_cap.vht_supported && is_5ghz) {
 		bool have_80mhz = false;
 		unsigned int i;
 
@@ -6623,17 +6631,11 @@ ieee80211_determine_our_sta_mode(struct ieee80211_sub_if_data *sdata,
 				 "no VHT 160 MHz capability on 5 GHz, limiting to 80 MHz");
 	}
 
-	if (req && req->flags & ASSOC_REQ_DISABLE_HE) {
-		mlme_link_id_dbg(sdata, link_id,
-				 "HE disabled by flag, limiting to HT/VHT\n");
-		goto out;
-	}
-
-	he_cap = ieee80211_get_he_iftype_cap_vif(sband, &sdata->vif);
 	if (!he_cap) {
 		WARN_ON(is_6ghz);
-		mlme_link_id_dbg(sdata, link_id,
-				 "no HE support, limiting to HT/VHT\n");
+		if (!req || !(req->flags & ASSOC_REQ_DISABLE_HE))
+			mlme_link_id_dbg(sdata, link_id,
+					 "no HE support, limiting to HT/VHT\n");
 		goto out;
 	}
 
-- 
2.55.0

