Received: from smtp9.infineon.com (smtp9.infineon.com [217.10.52.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5272338C406
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 03:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786506220; cv=none; b=b4nZwpvgf0sRI0CkVaXHTHbuVvaQ+j/eq/9iNkTKMfbQiINXuonjyL9U6Av7VYBdWdioLO55T1rLWrQdqOe5L6+hI+PcpvO/BvuWJNqGpe3bReOXD8zCl0qbJKZ+xRJgU0TIbc3HA0yKslaSg9YeSjP8bIWM+6xytEdDjDs73eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786506220; c=relaxed/simple;
	bh=wFe+eB14rTK2QJzxsEj/wPvdcJLQRyYKCfBCFcawdP0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tMEgcNQEqluTbFKl5XWXYgvvFeq3/S8NYM1wsjal96EstYY5nFzbol88KdmooaTCe0rtabhorzmNtyOQfLhyeXWuemwwxmNnECkxf/W8REN8ocIdB+sub+oXLZJgMLvsCyY+gUG8LUiXB8IqTVC3lVeE5lqE0+mLwT+hCPDk/t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=iemd+bki; arc=none smtp.client-ip=217.10.52.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="iemd+bki"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1786506219; x=1818042219;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=wFe+eB14rTK2QJzxsEj/wPvdcJLQRyYKCfBCFcawdP0=;
  b=iemd+bkiHD1YCzUW2BXzAJtUEXLXwnT7cz9gJhQzcepSuafIgb2zbmF3
   /eFnmplC8+b45UPYwOTs7TuXtmDlYZVtZol4gdYJd57X8Jbbn897BiBJr
   dC/x1q4cEyNMUDCiicEEaNOi8tel00+slMQe5fQn1YigOKJ8W+rRHXaSb
   M=;
X-CSE-ConnectionGUID: 3DW+/pvFTEeskRlreBH7YA==
X-CSE-MsgGUID: T1n6jKNBSo6AM0K6hLN/vg==
X-IronPort-AV: E=McAfee;i="6800,10657,11872"; a="104367922"
X-IronPort-AV: E=Sophos;i="6.25,218,1779141600"; 
   d="scan'208";a="104367922"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE805.infineon.com) ([172.23.29.31])
  by smtp9.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 05:43:30 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE805.infineon.com
 (172.23.29.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 12 Aug
 2026 05:43:30 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 12 Aug 2026 05:43:28 +0200
From: Jason Huang <Jason.Huang2@infineon.com>
To: Jason Huang <Jason.Huang2@infineon.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v4 2/5] wifi: brcmfmac: detect firmware FBT and OKC support
Date: Wed, 12 Aug 2026 11:41:18 +0800
Message-ID: <20260812-upstream-wireless-next-main-jason-11r-support-v1-v4-2-b1843e1f6de4@infineon.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786505858; l=1717; i=jason.huang2@infineon.com; s=20260810; h=from:subject:message-id; bh=w0tKDr1ycE8vtFVe3phEtveDPLGcakEwmu8MVGPoFgU=; b=bKG5bpKGLDXZwfJu99lCGI3C5bn/2KR2YegCiS8o3FQqfTE4UQTmoifMsGd/ieBuJ4vrWUbHj udd9toS3EvICnDbL0nmerenc+D2Wrsyof8zgdje57YpG9u9HT6uNfDN
X-Developer-Key: i=jason.huang2@infineon.com; a=ed25519; pk=BmqGCssp9w9TsTSVHuzcc6+C1o5uJ0uZK4ZSmrma28M=
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MUCSE817.infineon.com (172.23.29.43) To
 MUCSE809.infineon.com (172.23.29.35)

From: Carella Chen <carella.chen@infineon.com>

Some firmware advertises Fast BSS Transition and Opportunistic Key
Caching support through the firmware capability string. Track those
capabilities so later roaming offload handling can be enabled only
when firmware reports support.

Assisted-by: GitHub Copilot CLI:gpt-5.5
Signed-off-by: Carella Chen <carella.chen@infineon.com>
Signed-off-by: Jason Huang <jason.huang2@infineon.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c | 2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 488364ef8ff2..cc19e5e7ebf5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -45,6 +45,8 @@ static const struct brcmf_feat_fwcap brcmf_fwcap_map[] = {
 	{ BRCMF_FEAT_SAE, "sae " },
 	{ BRCMF_FEAT_FWAUTH, "idauth" },
 	{ BRCMF_FEAT_SAE_EXT, "sae_ext" },
+	{ BRCMF_FEAT_FBT, "fbt " },
+	{ BRCMF_FEAT_OKC, "okc" },
 };
 
 #ifdef DEBUG
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
index 31f8695ca417..8165a286b630 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.h
@@ -59,7 +59,9 @@
 	BRCMF_FEAT_DEF(SCAN_V2) \
 	BRCMF_FEAT_DEF(PMKID_V2) \
 	BRCMF_FEAT_DEF(PMKID_V3) \
-	BRCMF_FEAT_DEF(SAE_EXT)
+	BRCMF_FEAT_DEF(SAE_EXT) \
+	BRCMF_FEAT_DEF(FBT) \
+	BRCMF_FEAT_DEF(OKC)
 
 /*
  * Quirks:

-- 
2.25.1

