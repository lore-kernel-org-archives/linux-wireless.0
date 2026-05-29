Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2997033F5B0
	for <linux-wireless@vger.kernel.org>; Fri, 29 May 2026 08:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780043225; cv=none; b=uIlx4VHDZJfwREEO7+sSxjSwDdjDJIA8BaZh8yhS4uKdbYYpYPGR36SZKEXe8BArsvCqQmpyNhTpKpUD9tzVehLW5KW14NYeEr/N6iq3Mc0WcgRCWopPLqTORJAjkVgCwNWpo+nOu+mGBbYvTPY2tBEaFL+gH3W1WPIT5UL8MuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780043225; c=relaxed/simple;
	bh=NKsBrkNy452yzUOaeBeXceSe4koTTqQINQuFogbajOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2V9pPImAeyiYhHE9CM9yXJhTbYH8mmmbQrLqnormrqQn7M0S743skA48kv32yEQvWsaV0o+UFZy1LbfghM6fYiaVfCAKU6iRt5omYWRsxdF7G9T/fB3rof/cejwQGnjXoSNf+QN3HKYTMJBzW/37cOuIeJVw+NOTgcLZI3EDvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=P2ZLaWWl; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="P2ZLaWWl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=I2vMZkyrzol1DZUL+YLQNzCTluAFXTEHwABJR7pnvMQ=;
	t=1780043224; x=1781252824; b=P2ZLaWWlGIo6q37KsKgOV5Gtb4bWzNCJ5Y+IjcABidpuqQs
	W65/T+OY+Qcj0gm/L0/0jcMIgwQnIR5fK7pRNzh6K3U4ANlCNCGRlKRLkSZnlL5d3KehR1hBt7UJO
	8xBCVS9oSEA0qzFSttvCnslugbSSAee2uZ2jIJ767iE5N4lJUGTGDVpn1DtznVJk5XsVByearsujI
	K9DGog4/SfKtpzUDNwB8RIrt4LQNuQ57fDujiMqk8dFZOdHuUKSzD6mHpfPIaK7Xjw639cLNnBuCf
	GgvoJhiqk4SYP0t9kslyV3nHZ4M79H0feww+AA1wouXvpZ58/2nhe5OuPc9PWabg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wSsYX-00000009bVp-36qi;
	Fri, 29 May 2026 10:27:02 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 16/16] wifi: mac80211_hwsim: claim DBE capability
Date: Fri, 29 May 2026 10:25:09 +0200
Message-ID: <20260529102644.4db84674e8c2.I8731be8ea589c94ece5623e7e716cbbc03f50466@changeid>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260529082644.106145-18-johannes@sipsolutions.net>
References: <20260529082644.106145-18-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Claim DBE capability in UHR MAC capabilities, hostapd will
have to sort out the actual DBE capabilities based on the
EHT capabilities.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index 543793a39ad0..b7b85b2d9220 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -4708,6 +4708,7 @@ static const struct ieee80211_sband_iftype_data sband_capa_2ghz[] = {
 			.has_uhr = true,
 			.mac.mac_cap = {
 				[0] = IEEE80211_UHR_MAC_CAP0_NPCA_SUPP,
+				[1] = IEEE80211_UHR_MAC_CAP1_DBE_SUPP,
 			},
 			.phy.cap = cpu_to_le32(IEEE80211_UHR_PHY_CAP_ELR_RX |
 					       IEEE80211_UHR_PHY_CAP_ELR_TX),
@@ -4885,6 +4886,7 @@ static const struct ieee80211_sband_iftype_data sband_capa_5ghz[] = {
 			.has_uhr = true,
 			.mac.mac_cap = {
 				[0] = IEEE80211_UHR_MAC_CAP0_NPCA_SUPP,
+				[1] = IEEE80211_UHR_MAC_CAP1_DBE_SUPP,
 			},
 			.phy.cap = cpu_to_le32(IEEE80211_UHR_PHY_CAP_ELR_TX),
 		},
@@ -5017,6 +5019,7 @@ static const struct ieee80211_sband_iftype_data sband_capa_5ghz[] = {
 			.has_uhr = true,
 			.mac.mac_cap = {
 				[0] = IEEE80211_UHR_MAC_CAP0_NPCA_SUPP,
+				[1] = IEEE80211_UHR_MAC_CAP1_DBE_SUPP,
 			},
 			.phy.cap = cpu_to_le32(IEEE80211_UHR_PHY_CAP_ELR_RX),
 		},
@@ -5217,6 +5220,7 @@ static const struct ieee80211_sband_iftype_data sband_capa_6ghz[] = {
 			.has_uhr = true,
 			.mac.mac_cap = {
 				[0] = IEEE80211_UHR_MAC_CAP0_NPCA_SUPP,
+				[1] = IEEE80211_UHR_MAC_CAP1_DBE_SUPP,
 			},
 			.phy.cap = cpu_to_le32(IEEE80211_UHR_PHY_CAP_ELR_TX),
 		},
@@ -5370,6 +5374,7 @@ static const struct ieee80211_sband_iftype_data sband_capa_6ghz[] = {
 			.has_uhr = true,
 			.mac.mac_cap = {
 				[0] = IEEE80211_UHR_MAC_CAP0_NPCA_SUPP,
+				[1] = IEEE80211_UHR_MAC_CAP1_DBE_SUPP,
 			},
 			.phy.cap = cpu_to_le32(IEEE80211_UHR_PHY_CAP_ELR_RX),
 		},
-- 
2.53.0

