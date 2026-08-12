Received: from smtp2.infineon.com (smtp2.infineon.com [217.10.52.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB09A1922F5
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 03:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786506512; cv=none; b=LOIcK50iWh7qvtrAGZJYRWJSIPtvLXSgxfCdYfK4DRM0CKxlWvs1lW3frS3cxrnGvpLFRdBeslQeSLx/2nCNtcy5tIkZYB6CbZH1xOMAUzfR16FO8dAQvmAerOPd5ETX9TXqYQx1SPEbMy3Sb5BmUNI0nEmYc7qsQmJCy6kE96k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786506512; c=relaxed/simple;
	bh=l75GtSVKzEgV/uxY1WdpEfgHQokepV67texWUq/Ernk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tcsXlQkx6BAbInV3VL6QLY9WrQevzqFcffovUAZxeIiZwBvwUEWvIrHvnX3RBFqSyI6dvRxdxfXAGYmvbHLsaA2teUJgmV64I7yMra8W/1f5dyY+VeFwpvI9D/97tIxUzpeUS2QXB2ax7Fr3U93FYO/sEl6vgEjq/+GZjc7y6cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=qBRpp02p; arc=none smtp.client-ip=217.10.52.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="qBRpp02p"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1786506511; x=1818042511;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=l75GtSVKzEgV/uxY1WdpEfgHQokepV67texWUq/Ernk=;
  b=qBRpp02pArs4LciBY7nwR403J3U30sJxg+bsQTk6zgeOSBb4/sU3d9ll
   oAzH/DAga9k5Wesmx6vuRjwt/SrKavtJiJwxqinUv5zonxNuNKMJSS6ja
   LuWfnVRD2Evs0bWL7U7O1dXulYs5Hx0lTDkwlAnyG7F6WCCHnoSK/lKAU
   8=;
X-CSE-ConnectionGUID: snDicH8xRwm1uccYdK1L+A==
X-CSE-MsgGUID: w7GPQmegTtSL3HwUB26sPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11872"; a="172174011"
X-IronPort-AV: E=Sophos;i="6.25,218,1779141600"; 
   d="scan'208";a="172174011"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE814.infineon.com) ([172.23.29.40])
  by smtp2.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 05:48:29 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE814.infineon.com
 (172.23.29.40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 12 Aug
 2026 05:48:28 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 12 Aug 2026 05:48:27 +0200
From: Jason Huang <Jason.Huang2@infineon.com>
To: Jason Huang <Jason.Huang2@infineon.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v4 5/5] wifi: brcmfmac: advertise firmware roam offload support
Date: Wed, 12 Aug 2026 11:44:56 +0800
Message-ID: <20260812-upstream-wireless-next-main-jason-11r-support-v1-v4-5-b1843e1f6de4@infineon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260812-upstream-wireless-next-main-jason-11r-support-v1-v4-0-b1843e1f6de4@infineon.com>
References: <20260812-upstream-wireless-next-main-jason-11r-support-v1-v4-0-b1843e1f6de4@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786505858; l=1357; i=jason.huang2@infineon.com; s=20260810; h=from:subject:message-id; bh=RElrWP7lIjhr4hPrviZjogWQyDiIv659rnIEfoOZR6Q=; b=t0m4ZLXzUYBKihSF1DVD4xENCOF4ns5krNzUHq++nUJlnuTslZPbnpijVGl+F1D7BgcLcD+2O oZ9ldFchRjNCFe9wI423xx5W8YlxdOyUtEDvmP7GHbeI/O/IuifUrbG
X-Developer-Key: i=jason.huang2@infineon.com; a=ed25519; pk=BmqGCssp9w9TsTSVHuzcc6+C1o5uJ0uZK4ZSmrma28M=
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MUCSE823.infineon.com (172.23.29.54) To
 MUCSE809.infineon.com (172.23.29.35)

From: Carella Chen <carella.chen@infineon.com>

Advertise NL80211_EXT_FEATURE_ROAM_OFFLOAD only when firmware reports
FBT or OKC support. That lets userspace provide PMK material for
firmware roaming without enabling the path on devices that cannot
complete the offloaded roam.

Assisted-by: GitHub Copilot CLI:gpt-5.5
Signed-off-by: Carella Chen <carella.chen@infineon.com>
Signed-off-by: Jason Huang <jason.huang2@infineon.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index c11b3eac9d47..6a97be3149fc 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -7830,6 +7830,10 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 	}
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_SAE_EXT))
 		wiphy->features |= NL80211_FEATURE_SAE;
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_FBT) ||
+	    brcmf_feat_is_enabled(ifp, BRCMF_FEAT_OKC))
+		wiphy_ext_feature_set(wiphy,
+				      NL80211_EXT_FEATURE_ROAM_OFFLOAD);
 	wiphy->mgmt_stypes = brcmf_txrx_stypes;
 	wiphy->max_remain_on_channel_duration = 5000;
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PNO)) {

-- 
2.25.1

