Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81183E5A38
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 11:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785757458; cv=none; b=PtVmZoNCZ8hfxKORQ4mXi+4ulExyoZlsJECh30wFi2T0QNvqtOUwTmNo1LgI9w89bDw/jGeEq2D6XPk32CPcxZeedAIEH2nJE0Mtx24l83wv77xjMdLrrsVkPYbLlPl/+VdPuQEekITX1w2dCHQOqATjtXuQpQxnu/INVwzxN5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785757458; c=relaxed/simple;
	bh=VY/nltdE3RTc5sqr2BGpcUBXVonedPW40i9VhZuk+3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOxHHTJjnHi6LsgGxUiYWFZoHAOIJRsWrI8TAyzfwjZZsdY/3Lq0S6OZTyGhOfbSEWpZOp8mB1VCHQqVmJDsPOhu/aUH8EQGnYtj8pj1vi3F1WQ/Kr29f4yGEJdPdPZb7HqJBzxyC8OXM8BTAuciojkfP6I3xEaf14BoST2x4NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=rWzp30N0; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="rWzp30N0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=ZA1EzPzaWiKzqxAlfJwvRpikDMbpdUW3sDznarZoBOY=;
	t=1785757456; x=1786967056; b=rWzp30N0sQitost/T6zUb5ufX3jq3JmFjfgUBgAOWdFwhfW
	Njy4CEhn7m7SxSGQFjllqJvNU0kBwXuAGArcIb0OT+SOy1jinnKRVZFq8vo8Unl2ofsB/Qey8yVMS
	ddLQ6axUf01WxRGBaNhjqHNMXZfJvBqRA4ux7aLOfk69g5hHqFQ+QhwCnSYAbR3d2rhXqg5IH2uXO
	8AwYS/gKo6WdZ3MrixGd9hm5Q06Wauxavqffm44sMZzS64JvIXF9t/RDBovi2BbTfLrte7Nl7/Xin
	KMhyX8AI1aH7sibVk2JszOz4pc91Q0M1oO5ZkFdtQOb2a1BQhjSCn8d2RviitUsA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1wqr5a-0000000B74U-0hhK;
	Mon, 03 Aug 2026 13:44:14 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next v2 5/5] wifi: mac80211_hwsim: claim support for Control Integrity Protocol
Date: Mon,  3 Aug 2026 13:44:06 +0200
Message-ID: <20260803134401.3801fe48e0a6.If483ea588361a90b58a52493936cc0bbbc74c075@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260803134401.e4851391bdda.I49c0be0a1b05d625cc307e9bdd13c32a6c18667f@changeid>
References: <20260803134401.e4851391bdda.I49c0be0a1b05d625cc307e9bdd13c32a6c18667f@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

The mac80211_hwsim driver never actually generates control frames. As
such, it can simply claim the Control Integrity protocol (CIP).

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
---
 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index 02b6d81cccd1..1cc322aa898d 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -5668,6 +5668,9 @@ static const struct wiphy_iftype_ext_capab mac80211_hwsim_iftypes_ext_capa[] = {
 		.eml_capabilities = IEEE80211_EML_CAP_EMLSR_SUPP |
 				    IEEE80211_EML_CAP_EMLMR_SUPPORT,
 		.mld_capa_and_ops = MAC80211_HWSIM_MLD_CAPA_OPS,
+		/* CIP works as hwsim does not have control frames */
+		.cip_supported = true,
+		.cip_capabilities = 0,
 	},
 };
 
-- 
2.55.0

