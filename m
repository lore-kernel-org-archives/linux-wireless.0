Received: from smtp2.infineon.com (smtp2.infineon.com [217.10.52.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6CB43FD18
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 06:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789109900; cv=none; b=lzmUo3zFOB66phMjleIwp8rvPwj956lQ0XbsepZ03gbvEDYfMpAEnt8VK6y01QH19r5lbtpg5tC557TsUlET4dLnAzMpRy1KH3aXhD68hmaPeslNV+ImT+QSTDX3mCMZgU1SS74cTr+fgpy1+Oe1Iheq+p5qwvhJRBeVlWAA3BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789109900; c=relaxed/simple;
	bh=zu9Pm1Sqpd0lje78r3gAWJfNtHxmaIhDDSHm3uGYqCQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J1f6qcAiB5ObJ8kZefSjGANUbe2CX5aGsfdt/DxNeLXON3hlxWae6ALbdWVHjJoBlwKwZaOcbTL0EahHsRdYENZaC5LX4OYmPbphGdBsQW+ip4RDp3zZN1FLnhs2KZNaFuub8+BHnCJmhw76obwk7D5a/tmCS//l9WGmL8pmtRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=nTmGKFzh; arc=none smtp.client-ip=217.10.52.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="nTmGKFzh"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1789109888; x=1820645888;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zu9Pm1Sqpd0lje78r3gAWJfNtHxmaIhDDSHm3uGYqCQ=;
  b=nTmGKFzhqGDcDy3DJlXa8Wgx5J7Z9R2XBeKLmtRgsD1ieRQVx52W3aOe
   mxHEBYxXY3Eh0yCM9rPvJk3vfOk+gJBPIPgzTEeA8Mc25foyv+5Q5VfNs
   zCxvrfs/KBfOpcRYZ/edi8y0BB1p3YK6StSf6X0iqWRvS6WySTns0p4h3
   Y=;
X-CSE-ConnectionGUID: wI9HMISTRSevYyyJGaIARw==
X-CSE-MsgGUID: GoIBa0ksQJKZiuX45s4fBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="178082404"
X-IronPort-AV: E=Sophos;i="6.27,96,1787004000"; 
   d="scan'208";a="178082404"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE812.infineon.com) ([172.23.29.38])
  by smtp2.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 08:58:02 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE812.infineon.com
 (172.23.29.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Fri, 11 Sep
 2026 08:58:01 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 11 Sep 2026 08:57:59 +0200
From: Jason Huang <Jason.Huang2@infineon.com>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>, Arend van Spriel
	<arend.vanspriel@broadcom.com>, <brcm80211@lists.linux.dev>,
	<wlan-kernel-dev-list@infineon.com>
Subject: [PATCH v6 5/5] wifi: brcmfmac: advertise firmware fast roam offload support
Date: Fri, 11 Sep 2026 14:56:56 +0800
Message-ID: <20260911065656.1269623-6-Jason.Huang2@infineon.com>
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
X-ClientProxiedBy: MUCSE815.infineon.com (172.23.29.41) To
 MUCSE809.infineon.com (172.23.29.35)

From: Carella Chen <carella.chen@infineon.com>

Advertise NL80211_EXT_FEATURE_FAST_ROAM_OFFLOAD only when firmware
reports FBT or OKC support. That lets userspace provide PMK material for
firmware fast roaming without enabling the path on devices that cannot
complete the offloaded roam.

Assisted-by: GitHub-Copilot-CLI:gpt-5.5
Signed-off-by: Carella Chen <carella.chen@infineon.com>
Signed-off-by: Jason Huang <jason.huang2@infineon.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index c11b3eac9d47..519de96b042e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -7830,6 +7830,10 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 	}
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_SAE_EXT))
 		wiphy->features |= NL80211_FEATURE_SAE;
+	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_FBT) ||
+	    brcmf_feat_is_enabled(ifp, BRCMF_FEAT_OKC))
+		wiphy_ext_feature_set(wiphy,
+				      NL80211_EXT_FEATURE_FAST_ROAM_OFFLOAD);
 	wiphy->mgmt_stypes = brcmf_txrx_stypes;
 	wiphy->max_remain_on_channel_duration = 5000;
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_PNO)) {
-- 
2.25.1

