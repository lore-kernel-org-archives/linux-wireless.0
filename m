Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792664328;
	b=1ryHRGXos7DlF3HWE2euMjVHAqafQ9A6zLJorDnQcTKle6QvbwmsSiMaVtWoQBfroPzm
	 qH8FyQoDeb8rLBNr8nBRuh2fmO8WvyKnYBJoRD7ROtZ2wc6N8iIvvezunXbNO+ViAF18q
	 KRmIBKi8DVtFQ5yXFiS/5RySQV+bR6s9a6U2wn1UX6Td5LOTGyn1RMdpB8gsTuTpyW8Wm
	 wZSdHrZnuY/RRMrMGZHJgvO+ACbi2PCG2CFO449ipZA2HJWhaexNtl5R4eTuZJ4NjUQSX
	 yfdQM0tsUOS4HjlAJwlez7LzrCi4YmX+Je+RMumDDNJYGpSdVDjq/SzT6nnAGBHDvGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792664328;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=SzZ+9sL9Z87GJ5231u3VEd6ZbBPqnC3V670Ckyp+vZs=;
	b=B978QIgd3VerldIvg846d7TPnbqNPpOwWJvYZKJt7qfYjwjdxdFIR0qLlRuRFICiT0MA
	 vJ+YFPAkqeWX8HiDAITOuh5Y/CF38oXD8lljMJgG5tfU9KNgdqvgOF2jJLtAEt0MZTq8l
	 aNxONqjI1zStxHokPgvFYbsIK1kwxmduqMukyQXqjYfAGw/uWZqm1ZaIwo85Q9yOnzIuI
	 7tRkbMPfE9iRx9lhLQgTx18BZwmyKGSsQPs1pCvzWn0Li/0exT0NByrXYTm/bULj2RMtz
	 WMdmh+Xlw/Cbp/Lk0z8N+qmMNBVxAhsjtInPQqxKAEwivABupmIS0fE+T+8eJnrF3lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=iNKyvTAb;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16AD606A32D
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 10:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=iNKyvTAb
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=SzZ+9sL9Z87GJ5231u3VEd6ZbBPqnC3V670Ckyp+vZs=;
	t=1792664326; x=1793873926; b=iNKyvTAboozdm/02XV+kyZt5LmkrmTVX7EMHOEs+1Bf6iJZ
	TPr7IECdgl9aCOLNyxe5gC0hMgxNZjaymMBlmU4X3Ldqdc9qwblBVWRU4iAINRmjQL2/+SIPR/Zra
	VzdS9wTRfkdt6JxsdfntWCnS/QQYIqGChG+rJClsrUDw0G+WiQ6mCG4VL38uu7a/ETCNkJevN8I+U
	R37ANYcB/Gb0kZcOeWnERK+lLTGk3XPq8Fs2LzgTsqn+V/J0Rr7eLDTdUgCFBpgHou0MRt7KtcN3x
	NmqEmH5kxOwChIBax7e0nwS/6Hw0RxGxv624YQgumaybNfs3bUYG7EDE+E/YnRoQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xJpsi-00000004Ifb-0Pfv;
	Thu, 22 Oct 2026 12:18:44 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 2/6] wifi: qtnfmac: register regulatory before wiphy
Date: Thu, 22 Oct 2026 12:15:33 +0200
Message-ID: <20261022101836.148512-9-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261022101836.148512-8-johannes@sipsolutions.net>
References: <20261022101836.148512-8-johannes@sipsolutions.net>
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

This order is going to become required, since userspace
can query the regulatory in the window between the two
registrations.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index d9c84d5ce254..139f67adead7 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -1231,13 +1231,18 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 		sizeof(wiphy->fw_version));
 	wiphy->hw_version = hw_info->hw_version;
 
+	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) {
+		ret = regulatory_set_wiphy_regd(wiphy, mac->rd);
+		if (ret < 0)
+			goto out;
+	}
+
 	ret = wiphy_register(wiphy);
 	if (ret < 0)
 		goto out;
 
-	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
-		ret = regulatory_set_wiphy_regd(wiphy, mac->rd);
-	else if (regdomain_is_known)
+	if (regdomain_is_known &&
+	    !(wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED))
 		ret = regulatory_hint(wiphy, mac->rd->alpha2);
 
 out:
-- 
2.56.0

