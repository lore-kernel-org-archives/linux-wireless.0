Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE78142A79F
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 13:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785505381; cv=none; b=K/uuCw3EVkTSxSWs+1oTMbcQrz4Ma8lZSLon5EhgkEdX74DH5E+PZxMWJcEDshb9jYAT0EiAy017KeLkykavLt8DGPKzSNEHpRx0PVMzNRYeX8H8awg6dGoeKHu9EcjbyqUl8l1cJCW4XjkXhKTEukGNLDgq/9A3FkQPaQoSw54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785505381; c=relaxed/simple;
	bh=VY/nltdE3RTc5sqr2BGpcUBXVonedPW40i9VhZuk+3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q3tKuJ5Jdxi3FMtJQWX+S+8CxWGC4y0BOcmWo1rSyl95sYwvsvnZWUeVpx6ipAXvzJP8q0JtGsyBsw4ZUdwhuEJ2MMiIHy15IltEaIacjD/9rvYEZfzOHaWp6r9QCSh4SiYkAZy7ZQF275qLUVHpKJB0HYOVt16N70SqqrZLKHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=pNS5PTQh; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="pNS5PTQh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=ZA1EzPzaWiKzqxAlfJwvRpikDMbpdUW3sDznarZoBOY=;
	t=1785505379; x=1786714979; b=pNS5PTQhQTUfKaKyzm5AwM1vYxX0+bZoO69NLulwls8QtSo
	5pQ/TzyWeHhLdFbGO3ccOsG7Cra21PLSTtWpsgxZ50OAT31ukQOKstHi0F5jzw/rCQQ3uZezwkzWh
	1Dh0t/QyMoJBycPw66cnLO36QUF43eUUBZf2X7jt2DDS9lzQqBYSSqlqb7rx32CVDRIRfWa94Nfzv
	JnX5JmomoeL23+VctvsPqDJtpsdb7CU9WgTfO2mREqba7fU6kAC3o3D0R5PZ8CdLU2SOuLLSVNY1t
	6zRgVKHZKTpBpAKgwf6eQHfVipjPJBoCiJcdN/ZAz3fJo+mIpjJ2PJZpDEkF6M1g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1wpnVp-000000048ua-1IqI;
	Fri, 31 Jul 2026 15:42:57 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next 5/5] wifi: mac80211_hwsim: claim support for Control Integrity Protocol
Date: Fri, 31 Jul 2026 15:40:11 +0200
Message-ID: <20260731154006.c33e1162c040.If483ea588361a90b58a52493936cc0bbbc74c075@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260731154006.7bddd2d85ff1.I49c0be0a1b05d625cc307e9bdd13c32a6c18667f@changeid>
References: <20260731154006.7bddd2d85ff1.I49c0be0a1b05d625cc307e9bdd13c32a6c18667f@changeid>
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

