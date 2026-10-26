Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793015514;
	b=cqGrltItelElm1VOf1U1n0rTkhC51mR51Oo3BeawLx+Ko7PQG0u4enIgYcvR4leQORoc
	 CGKxxpOtS3yn/rhD3w5O+RwaXF5BTZV5Lk4pBK8YR9aj3C7aSLyrj+10pfKdZBKQrSHKJ
	 RAQbE2OZpp94lJkb5PNNas0YEva/h91If7+KG+sWQL+e8osXIjnyJoA52C9pZJQQ+2mtJ
	 C/KZPEPH1XG+VdY1gx+hvJiJxKDI/nGn0bFaUiKG+KzYqFcnrnhuPFamgeQYVPmBIku3H
	 bDdpnIShx6qJh35FL9nE3gphy6FPqHTkN60A2NutqaAsD28gd5uT2Oqr0Ga4HqGn2yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793015514;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=2Cg7PgdIatJeTboN61oyN/BcS/cr5bsl0eSweBR6Yg0=;
	b=UJ7NAaYfyVL/+SO0Um+43ODtJ3a/FLo5fJ+QzVzUuoFTNxQs/Ier8X3CSJBp0Iph4oc2
	 /qLNPDFTEXoI6Xqa8WL+xwzn9PaIHM0jUMcHBvuNp0WNxNQQ8ecmhF183LyhFxG7I8ktL
	 5K44OY+HzCxPrVsNS5ptxevac8dPs7P8f6JuOlTdje/RF60CBQe3AhboLV7R1PYSKXH9A
	 8bkUs3dFgyeR32FdEirKLwSQUscPrwDQUqKx24DsXmJPEJ6RQ0uP6oW5D1IHC32Xo2Vv0
	 pFpnuCbMJSZwghQyAIQF4AjrWv6bnBIUR7krc8jRGxgZj8jKYgnsOALDJdA68qUwnNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b="E2bb5c/r";
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E5F60A2628
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 11:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=E2bb5c/r
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=2Cg7PgdIatJeTboN61oyN/BcS/cr5bsl0eSweBR6Yg0=;
	t=1793015513; x=1794225113; b=E2bb5c/ruCpEcCk1DsOkna4b1vz48gL618/eovDTuZjGDlX
	mDzGdgJZkYZkdXLz+tTPo/+rqKdAbUTOxZVuNy1vj2DWSOn8LcIjN8Zxh9KyRLO3obm03OAPGJcoT
	PPUJtk9adf+16wVsaY50TYDuyH2yeuzDyAfNRtccXIECvOqmQnUzbDczzQX5puzuWBuqlz2hkOG+y
	PvuIM5il2/X557UMCQnKiQ/Fq+E5huwYSK4R/zT3bS+VWAULgi1BybqMCUpo3HWZW1rTv1MWAGUht
	vvfhO/nanIqjd7qWJVPLEIywRvxT/OGEiVCHGOUFp6vbpRc9HCeuPWvbGj891yhg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xLJF1-0000000BDPs-1xTv;
	Mon, 26 Oct 2026 12:51:51 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 4/6] wifi: mac80211: don't reserve tailroom for all keys
Date: Mon, 26 Oct 2026 12:48:38 +0100
Message-ID: <20261026125145.c777e12ab68a.Idba6d39943629f516e7d9ce8e6b0b42d20279e0a@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261026115144.189706-8-johannes@sipsolutions.net>
References: <20261026115144.189706-8-johannes@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Keys that are only used for RX as well as management-only keys
don't need to have tailroom added to data frames (we already
add tailroom to all management frames), so don't count them.
This avoids allocating tailroom for every frame just because
a management key would need it.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
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

