Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137674908C4
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 19:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791140500; cv=none; b=IxvwbmSd8TQz51K/T4HL0iHBLSYRuCHzAgffvpXwvxeu7diCoOKm/OJqEWquVtgPc0Dbzq8P42ScHzkQ9PPdhDT88huk2ZPWpx2ufp7V34WX/XSu02jDwBjgusdXqvML6xfwr0n2H+wKDfumo4NvV2gXXY1iLsk+eja6tXIK8Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791140500; c=relaxed/simple;
	bh=SYsIbVpj8zMak4oQ0BLVAJUXZ5qTkCXGwnYmN1oShlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXwuVNF/5A1/3AAtF0l1ZhjzIoZWUNOb11NmR/BExOdlcSfSz3xUDz0pydvJM0XYNHsxU+Q+nQ4kglYjBzi2LApydsGV842/rIXOsrdgOpadgqwDz/tF8oO9uKWYPwh08N7nOnnmOJ93TPqvYfsd+P+4uvvfpNtBpWTaM2PC8Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=bvJIDbNI; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="bvJIDbNI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=WSUbxP1NCRS8WP+r+2gIAQ7iEaPjCtuTSpAiSGKwSrc=;
	t=1791140498; x=1792350098; b=bvJIDbNIM+inh+9BCp3+jwx+sxgU/dp7XRqnAXg1+qZ6nVX
	koHcqPg1vF1aLieykxsBwv2Yjg8DH6Bf0y/3FNvE7fHTxc4ejpU52MPwCbTC5Bga+WAMeVWSAG49f
	y9+Fnibl2Dk2CWj0gKtMCmvrh/S8NYu2h8XFg/M7schc4PRi8iIxC5lOgxva/f4MlLwaSzu13/Y3P
	RXIGu7JhziNXLNmZhwS0hXQZ83R1HV2gMABMuvpa8x58RLRElQLP2kn07haBB1F/okzO7SOVND598
	Ug4zBgg/XZeDAgT5OZ4PDsyb+qlIxT9I30xysO5YjdZ4Terp//QCGC/n5HjRzOQA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDRSo-00000004Jlo-1G3Q;
	Sun, 04 Oct 2026 21:01:34 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 13/18] wifi: brcmsmac: use freq_reg_info() under RCU
Date: Sun,  4 Oct 2026 21:01:27 +0200
Message-ID: <20261004210122.ab540e709251.If1ffc9864b3557ec046c705286e974218a32d9cc@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261004190122.1559001-20-johannes@sipsolutions.net>
References: <20261004190122.1559001-20-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This will soon be required, because there won't be the
RTNL to protect everything. Use RCU for freq_reg_info().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c
index cdfe8635c012..5ca8a0735398 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/channel.c
@@ -676,6 +676,8 @@ brcms_reg_apply_beaconing_flags(struct wiphy *wiphy,
 				continue;
 
 			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
+				guard(rcu)();
+
 				rule = freq_reg_info(wiphy,
 						     MHZ_TO_KHZ(ch->center_freq));
 				if (IS_ERR(rule))
-- 
2.55.0

