Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0083E44E7
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 19:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792006363; cv=none; b=olG1Vrpf95CPYZo0OxME82ZVSX+ws18vjpn18Dti02UsHpBpBXu0lIvMLD3h5iMCGrf/CUk2JZ7KmPKUECyz0ZSU08tcqCpDfsfzOUJalaOsEUqxtxFzmSrIAoQ8qPm15YdEHdQX9KsdXCl0ZRMRIJ/I5pbZKjvpfXnBKu+MrdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792006363; c=relaxed/simple;
	bh=9QepGyVwQmQ3k93TEKdJeofNihbHfBDyg1e9S6dZCx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzY8BNatlV3fR0i72hkuR0l3NAxINKMPZ987mXvNFZmNXGYPaFYE9zlCdJQ7wACqHNG6jwL5iPFArxshRTqsMWvLCEMR3Wlu6yJDszvSCctnfg6qD55GeM80j+x5nltq+7QXjdWyL0syzKQy8t2YwLfK+Ouqm3v9NjTuCAk48YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=dET78pqy; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="dET78pqy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=KITtxZN1IvTAQ6gD7FWkLAtAHZZ1OdZOyO3Ht/IQRjA=;
	t=1792006362; x=1793215962; b=dET78pqyKwLcws/BivnAjatdjGw+DCMryaA5ZGF24gCnRqo
	2/68fnjjeCjyRVYsHoLtUhfeI96qR42yYWaY+rMMnifZ5zIUgXSOAlH51+IfoSAEHjyRfFSPUwv46
	ShpWNR+mhMo6E9V28Zylm3BMVdVYVjjKlOoYdsXdOAQs+4q/CA07LbGQQZj/1YrfREN/wNdQkIvKd
	UtWr6MS6MZacw6xn4Ekc95AvCztRVlR24TdHKbNxgdaJVokLdYo7s9eGdB9eDJY2984/CsWQHsVbj
	o04IlAUpq5gj4RB4+6jqLeqwNgDdqTJ0Gk6dxvEggOP5vGNIgoTlh+uA1Elunc9A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xH4iN-000000020zZ-2Anw;
	Wed, 14 Oct 2026 21:32:39 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 4/4] wifi: mac80211: don't reserve tailroom for all keys
Date: Wed, 14 Oct 2026 21:30:34 +0200
Message-ID: <20261014213231.6284c67c464f.Idba6d39943629f516e7d9ce8e6b0b42d20279e0a@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014193231.886495-6-johannes@sipsolutions.net>
References: <20261014193231.886495-6-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Keys that are only used for RX as well as management-only keys
don't need to have tailroom added to data frames (we already
add tailroom to all management frames), so don't count them.
This avoids allocating tailroom for every frame just because
a management key would need it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 8d04fba60e17..436a165d0b91 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -93,6 +93,19 @@ static void decrease_tailroom_need_count(struct ieee80211_sub_if_data *sdata)
 
 static bool ieee80211_key_needs_tailroom(struct ieee80211_key *key)
 {
+	/* non-pairwise keys from a station are only for RX */
+	if (key->sta && !(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE))
+		return false;
+
+	/* management frames always have tailroom reserved */
+	switch (key->conf.cipher) {
+	case WLAN_CIPHER_SUITE_AES_CMAC:
+	case WLAN_CIPHER_SUITE_BIP_CMAC_256:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+	case WLAN_CIPHER_SUITE_BIP_GMAC_256:
+		return false;
+	}
+
 	if (key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
 			       IEEE80211_KEY_FLAG_PUT_MIC_SPACE |
 			       IEEE80211_KEY_FLAG_RESERVE_TAILROOM))
-- 
2.56.0

