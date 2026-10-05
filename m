Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9CE37F315
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 20:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791233410; cv=none; b=semFWWPVf6/CIDPgE0FRR1/AK/7aVkhQua8c6cGFjACgPvhP6eQI+Ik1NRUWyetDl3VeHGP3aGD1kEOMBZ7Q3KO+dIIjeIgFpR+TuOtInq8hJI6DKkwBW8Lg6/HAnNb2Inp7XTHUXaWjWc0E9sv5vlpkOXPuMSBW4ZLoCMCkVxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791233410; c=relaxed/simple;
	bh=WqhDoRfX6tYtilgWsC46p/H3J0xQTd3gEX8IQp+5Lgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxwOWZe/2P2yvkL9iTUDWz1FzNuB53tcJoF9pGid0QovXPbCVddQX0UDYG28SsYWPyo1yem0rOQrlJJDRTgeoahVU0Q7bgdGvQYb5Vy7rbJgCBhZeNKeq3vX5aiMASpnep14VMbmGQmbW0ZSgmdsjbLKE43rhlSDSZQFp6ANu0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=VMDAHiN3; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="VMDAHiN3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=7oe0YsONuc+KBHnIFysj5bEPBkJaLDRBaQDdMyc487k=;
	t=1791233404; x=1792443004; b=VMDAHiN3IHhMzzgxLywzX8IJbaP74e0mcMjJAEms8zxvFMQ
	IyNyncNDcEyVrtUYTqh7WG5eoo3gihvauNSAFYVZBugHOsGQI4YP46DlJQV1vP44oAtyi/NgGbr8L
	6zb4UZYEVntiKJBI8JkHb8dnbDpqDXQksP35WfPL+lJWbufwVbglLJgYrnBFAOwV1G0+cSj6AB8ea
	z0Ve8N3WPTn/XI5NBxkmtmiboK/f4/u0Nnf9z5Y4yHkfH6RvQOjUPt6PO1tVbMoKugEIKDz3sawZT
	z+hkqEjmFVHOjZ+fW84+ySlGziaEbadrnLLGF0qPkfdbxvN6SQdID++PRot7gNjA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDpdE-00000005cw8-1tOG;
	Mon, 05 Oct 2026 22:49:56 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 04/10] wifi: nl80211: reject zero RNR/MBSSID elements
Date: Mon,  5 Oct 2026 22:47:55 +0200
Message-ID: <20261005224950.97db49d9d104.I5765a3310528b3d1cb1673dc90ad5ab5fc3ea571@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005204950.2303430-12-johannes@sipsolutions.net>
References: <20261005204950.2303430-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

That's a nonsensical configuration, and we get errors
reported further down in mac80211 for it; hostapd has
code that only adds the nested element if it'll not be
an empty list.

Remove an unnecessary NULL check while at it.

Fixes: dbbb27e183b1 ("cfg80211: support RNR for EMA AP")
Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7ee69ec10b0f..9c2d5c89598b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6582,6 +6582,9 @@ nl80211_parse_mbssid_elems(struct wiphy *wiphy, struct nlattr *attrs,
 		num_elems++;
 	}
 
+	if (!num_elems)
+		return ERR_PTR(-EINVAL);
+
 	elems = kzalloc_flex(*elems, elem, num_elems);
 	if (!elems)
 		return ERR_PTR(-ENOMEM);
@@ -6617,6 +6620,9 @@ nl80211_parse_rnr_elems(struct wiphy *wiphy, struct nlattr *attrs,
 		num_elems++;
 	}
 
+	if (!num_elems)
+		return ERR_PTR(-EINVAL);
+
 	elems = kzalloc_flex(*elems, elem, num_elems);
 	if (!elems)
 		return ERR_PTR(-ENOMEM);
@@ -6860,7 +6866,8 @@ static int nl80211_parse_beacon(struct cfg80211_registered_device *rdev,
 			if (IS_ERR(rnr))
 				return PTR_ERR(rnr);
 
-			if (rnr && rnr->cnt < bcn->mbssid_ies->cnt) {
+			/* RNR elements are only used with MBSSID elements */
+			if (rnr->cnt < bcn->mbssid_ies->cnt) {
 				kfree(rnr);
 				return -EINVAL;
 			}
-- 
2.55.0

