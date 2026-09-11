Received: from smtp9.infineon.com (smtp9.infineon.com [217.10.52.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5B3448CEC
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 06:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789109933; cv=none; b=b2n95h8oTAH9FFsLKgoY/Tji+O1XrpblyTFD/x809m8VXJ32my7WXb7WUNSzr2/ON0ZzGrHjTxPSTzVvpBojjr/mWMeLI3CmJe4Nt2fMC35RqnnTAzvcKDyCPEHW7eui1nTo/ANQnGf3jiPqruHA9ee34KcQZEBPPJBfUmrsL9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789109933; c=relaxed/simple;
	bh=qvJ0u9Qz3iu2bXVEQW354V2q/YwVxkZqBCl6oCaKlSg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q5AGWSHnudiGBlKZI0BjNtyf+r3wowhduVOcRrZQhj31TLu+2q5tLG2DC2/IwjRwfuN3k/l6Bx+cEXrOKYbMcUL3kFU0t4rs//CSLbF+m7Y4UYQfxIaymYQ6rOrm4hMuSxHdNhsi5MYkSs5+JZ++gnD1NmypfxYBKbBCNdGxUR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=lJG+TFoI; arc=none smtp.client-ip=217.10.52.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="lJG+TFoI"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1789109928; x=1820645928;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qvJ0u9Qz3iu2bXVEQW354V2q/YwVxkZqBCl6oCaKlSg=;
  b=lJG+TFoITZBic8rWv8OoGt39MQb3asG+eo+nSiqfQNLgejDBn2XZp07n
   jBXReSy8VQgydeCXxCdcHha6ccINNh+5T6QZZAnwuUbe1AqeSJfZb59lr
   Fcvi8Yx+a7W7HkILsHAOMHtPo4rCIw7JdOn4rMYeR1ooq+AvhF2Q0WZD+
   g=;
X-CSE-ConnectionGUID: Ppzy/LIIRhaL2Na9jqj69g==
X-CSE-MsgGUID: 7fNyPGTUSH+bPHVKo0RpEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="109046933"
X-IronPort-AV: E=Sophos;i="6.27,96,1787004000"; 
   d="scan'208";a="109046933"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE822.infineon.com) ([172.23.29.53])
  by smtp9.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 08:57:32 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE822.infineon.com
 (172.23.29.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Fri, 11 Sep
 2026 08:57:31 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 11 Sep 2026 08:57:29 +0200
From: Jason Huang <Jason.Huang2@infineon.com>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>, Arend van Spriel
	<arend.vanspriel@broadcom.com>, <brcm80211@lists.linux.dev>,
	<wlan-kernel-dev-list@infineon.com>
Subject: [PATCH v6 2/5] wifi: brcmfmac: detect firmware FBT and OKC support
Date: Fri, 11 Sep 2026 14:56:53 +0800
Message-ID: <20260911065656.1269623-3-Jason.Huang2@infineon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260911065656.1269623-1-Jason.Huang2@infineon.com>
References: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-0-eeab4fda0f31@infineon.com>
 <20260911065656.1269623-1-Jason.Huang2@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MUCSE824.infineon.com (172.23.29.55) To
 MUCSE809.infineon.com (172.23.29.35)

From: Carella Chen <carella.chen@infineon.com>

Some firmware advertises Fast BSS Transition and Opportunistic Key
Caching support through the firmware capability string. Track those
capabilities so later roaming offload handling can be enabled only
when firmware reports support.

Assisted-by: GitHub-Copilot-CLI:gpt-5.5
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

