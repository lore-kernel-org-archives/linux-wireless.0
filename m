Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001AC4CDA25
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 10:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789553257; cv=none; b=Kxu/dNlAC+m0wj4rDz9SMh6+Y7T7G4aqykLabE9VB8+fW0COmsIbqAuOVH9fUw1OvrP6VXG08IWHitc3eVeUjxqjyCpymDdlfKNKjFQ0c966phIN/VRoy9GoL5Og6ICCHFgcwLUBn1k0XLhH7l3/29iey34cV9/fE5Vxwibj5kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789553257; c=relaxed/simple;
	bh=Q4Rc006pEwGA1hrayKQ67kq8qMffdL/WxITX1/YKJYc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SAeehvWKsJMfmUImLeAfX5trlkLnNJIrNSL3GLD1EYuYzDh6WAAt1Bzo2UK8keuGrQ575RMlmMBlOJg6Kk1Mee7y0dlFgRcARPDIA0W32UBoKi+4OQaLWvRKnmzWQQxiDrfqaeJL42vddZYqvDcI1Zh2upkApz/nLaya1M+nVgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=lXBaFLyZ; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="lXBaFLyZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=0H89oB9AtiBAgtO5GRFeeAWL5thPiXvwpEeQ2yOVV2Q=; t=1789553237; x=1790762837; 
	b=lXBaFLyZkz0oPf0VPq8+9cRGm7ljE5deaCi6x7DBLLURDVvxdU07F9hWaNr1iWeRLvGXdVPBx3Y
	tso9rni92YKq7L7g0pxy8HF+nD9dEF5p/4UQwrat36e7v8DGr+ugz8a/QsT1yQM3H82ASndq046n4
	FMbhq+pu+d+E51VFovUYYjGv1IY1rE27PkgT+vgk0y/0N9UN+xk3EscCl3DVHfJ9m2cSNptriS6tC
	MFQRs7zsovEiFS6AY0dUS7kdHsB9XE0Eyc7dRpA60ajAzTLrcRRFIxGStdJhFw/RZupcuLduCw6oQ
	6M0GdwLmn2S266xBjk7cRDE85s2w/JYJgjSw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x6mXm-00000000bg0-1sMV;
	Wed, 16 Sep 2026 12:07:10 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: mac80211: fix multi-link UHR association
Date: Wed, 16 Sep 2026 12:07:08 +0200
Message-ID: <20260916120708.8ddea0cea883.I72e7fc58d65aca620a05a07b759755e5896f068f@changeid>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The maximum connection mode is still set to EHT, and in
particular in multi-link this matters, the second link
and further links are otherwise limited to EHT. Fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index a96078a6bfa2..e2b5b2b21c34 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -47,7 +47,7 @@ struct ieee80211_hw *wiphy_to_ieee80211_hw(struct wiphy *wiphy)
 EXPORT_SYMBOL(wiphy_to_ieee80211_hw);
 
 const struct ieee80211_conn_settings ieee80211_conn_settings_unlimited = {
-	.mode = IEEE80211_CONN_MODE_EHT,
+	.mode = IEEE80211_CONN_MODE_HIGHEST,
 	.bw_limit = IEEE80211_CONN_BW_LIMIT_320,
 };
 
-- 
2.55.0

