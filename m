Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2985849B1E2;
	Mon, 21 Sep 2026 12:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994482; cv=none; b=UDHwkHLbFQYR2pgrOmqpUkFoQcGNYLUdPilDKqr/EsHlydhAUDdCxDqXrU57ESBzgQOTiJbtWh61HsA2LboYJedUXO3bjhswEfPdUOPj2G1T7i6dzL3Jmu95z8c9xMP2u+cGKc40TXSmIHZM2jqIpmfBs3+nf3qTa4M0onS6LKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994482; c=relaxed/simple;
	bh=DuCOWjuCaAwRhkbu4JnPl2u4juQMC1iPwAWe/RfhnTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ab1E1SCVZUghAmJH9uBlc0EBnUk27DAyiRkvYl8KQd9BIAacQaS/nzqqhOO4Ad4YJ9IJIBwgEYTCAKqZIORM821N4qE5ImLb2Quz4bGJJsbNvgddPIcefpoBXPZIKLzs8DccFWf5Rni+t69pJzh2jzvTaIAp2E58vI3ndKm88Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=XTX2zhV7; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="XTX2zhV7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=X9p/RgomSQC3rSq+io8BATTO/qfwK+bRCXlDwOYE6Ws=;
	t=1789994481; x=1791204081; b=XTX2zhV7uLgkqdXGurRZn/rqy+oe1eQ/bIviA36+EnmHNBk
	nPNkPDatDFdUejUftf99wZvJS5hQ+nYugf4FBLBE8lR2z1mXCFJSua48CGkbDKo2mzdmIO7CXYkTE
	mR5GyK6GtDsz7QNUNIfZxeh5zMb8h7vPuuPq1Z8UFLewQZdeLLf21HU9KkWHtzlunyoUXnRwMOFDh
	nYOXWiGPBjk8zlP/N2xNuIQc3hxGPjsppaG18VerWtLczSOiXsKorDggEDiQr4BBdzoV7wrs2zNno
	IMPxJkPHxuM1oBHLPhPt9OfDB2JnqCedcVRWV9VaSpzMozRMB5fGFaTxpr6zQiJw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1x8dKg-00000005oVO-0oO9;
	Mon, 21 Sep 2026 14:41:18 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Ajay Singh <ajay.kathat@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Igor Mitsyanko <imitsyanko@quantenna.com>,
	Sergey Matyukevich <geomatsi@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	brcm80211@lists.linux.dev,
	libertas-dev@lists.infradead.org,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next v3 7/7] wifi: mac80211_hwsim: claim support for Control Integrity Protocol
Date: Mon, 21 Sep 2026 14:40:56 +0200
Message-ID: <20260921144048.6a4047ca21a1.If483ea588361a90b58a52493936cc0bbbc74c075@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921124048.4146576-9-benjamin@sipsolutions.net>
References: <20260921124048.4146576-9-benjamin@sipsolutions.net>
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

v3:
- Enable CIP for more interface types (requires extended capabilities)
---
 .../wireless/virtual/mac80211_hwsim_main.c    | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index 1a12261f3e8e..0cf9ef8959e1 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -5645,6 +5645,14 @@ static void mac80211_hwsim_sband_capab(struct ieee80211_supported_band *sband)
 	 BIT(NL80211_IFTYPE_MESH_POINT) | \
 	 BIT(NL80211_IFTYPE_OCB))
 
+static const u8 iftypes_ext_capa[] = {
+	 [0] = WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING,
+	 [2] = WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT,
+	 [7] = WLAN_EXT_CAPA8_OPMODE_NOTIF |
+	       WLAN_EXT_CAPA8_MAX_MSDU_IN_AMSDU_LSB,
+	 [8] = WLAN_EXT_CAPA9_MAX_MSDU_IN_AMSDU_MSB,
+};
+
 static const u8 iftypes_ext_capa_ap[] = {
 	 [0] = WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING,
 	 [2] = WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT,
@@ -5669,6 +5677,33 @@ static const struct wiphy_iftype_ext_capab mac80211_hwsim_iftypes_ext_capa[] = {
 		.eml_capabilities = IEEE80211_EML_CAP_EMLSR_SUPP |
 				    IEEE80211_EML_CAP_EMLMR_SUPPORT,
 		.mld_capa_and_ops = MAC80211_HWSIM_MLD_CAPA_OPS,
+		/* CIP works as hwsim does not have control frames */
+		.cip_supported = true,
+		.cip_capabilities = 0,
+	},
+	{
+		.iftype = NL80211_IFTYPE_STATION,
+		.extended_capabilities = iftypes_ext_capa,
+		.extended_capabilities_mask = iftypes_ext_capa,
+		.extended_capabilities_len = sizeof(iftypes_ext_capa),
+		.cip_supported = true,
+		.cip_capabilities = 0,
+	},
+	{
+		.iftype = NL80211_IFTYPE_P2P_CLIENT,
+		.extended_capabilities = iftypes_ext_capa,
+		.extended_capabilities_mask = iftypes_ext_capa,
+		.extended_capabilities_len = sizeof(iftypes_ext_capa),
+		.cip_supported = true,
+		.cip_capabilities = 0,
+	},
+	{
+		.iftype = NL80211_IFTYPE_P2P_GO,
+		.extended_capabilities = iftypes_ext_capa,
+		.extended_capabilities_mask = iftypes_ext_capa,
+		.extended_capabilities_len = sizeof(iftypes_ext_capa),
+		.cip_supported = true,
+		.cip_capabilities = 0,
 	},
 };
 
-- 
2.55.0

