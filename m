Received: from smtp11.infineon.com (smtp11.infineon.com [217.10.52.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BD81E8332;
	Mon, 24 Aug 2026 02:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787538005; cv=none; b=T0Lj0pp5CWn8/+sXzGwmsmkuiaAE+A0ZOJehJ8uZRN9Q+VDjuvBxz7828mHb3/2+1sx32h8BRQ5dGKuQMyhS+x14yw6wNeitOmMsMiWSDePTIbTYQKFdqb7LfykEe3S3PfXFBkDQysS6oykVjkyhMLv36TjLqdpG1VmQ5QdFEiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787538005; c=relaxed/simple;
	bh=2orO2X3kae5MZd+KLTJhLBcyE1WmQ7MbZo7jM8M6XHQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ufcaH3DzDAsXRSbcBzgrb+iCkx2jaqSA0TFID/jwIAmMV+ZW6f0fbc2E/tYUsyBmzWVxpTuilbYhXhTIyPBCTvu9xXE41f1FsXeAHr/fEmVZFMK5mtk7/P8hC3fiYQhrgygmTLAi84GLHWvfdCyGljLzlE3ToQu4osrcJku7lrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=nY2coq4k; arc=none smtp.client-ip=217.10.52.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="nY2coq4k"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1787538004; x=1819074004;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2orO2X3kae5MZd+KLTJhLBcyE1WmQ7MbZo7jM8M6XHQ=;
  b=nY2coq4kemAFPmiabdc8Uy5pIpxW/Wg8Ln9rpab1ZmJhz4JT6DwtUnTW
   hacTZAxVisEfyFDzNsYd4qVEamInlW82bMhUFXy2JJmPYTKS3ZL0sWKcA
   Nx5bZVnWGMqs3T5o+k5WwmKIfi15wzkleKKo8juXoIwGBWdC+a8GUqm5j
   U=;
X-CSE-ConnectionGUID: jExLCVijTaKeBA4VgYlGOw==
X-CSE-MsgGUID: IgYz4a3ZTC68cJZE6vjHBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11884"; a="157225929"
X-IronPort-AV: E=Sophos;i="6.25,239,1779141600"; 
   d="scan'208";a="157225929"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE812.infineon.com) ([172.23.29.38])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 04:19:56 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE812.infineon.com
 (172.23.29.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 24 Aug
 2026 04:19:56 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 24 Aug 2026 04:19:51 +0200
From: Jason Huang <Jason.Huang2@infineon.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes.berg@intel.com>, <johannes@sipsolutions.net>,
	<arend.vanspriel@broadcom.com>, <hsin-hung.li@cypress.com>,
	<linux-kernel@vger.kernel.org>, <brcm80211@lists.linux.dev>,
	<brcm80211-dev-list.pdl@broadcom.com>, <wlan-kernel-dev-list@infineon.com>,
	<jeff.johnson@oss.qualcomm.com>, Carella Chen <carella.chen@infineon.com>,
	Jason Huang <jason.huang2@infineon.com>
Subject: [PATCH v5 5/5] wifi: brcmfmac: advertise firmware roam offload support
Date: Mon, 24 Aug 2026 10:19:42 +0800
Message-ID: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-5-eeab4fda0f31@infineon.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MUCSE814.infineon.com (172.23.29.40) To
 MUCSE809.infineon.com (172.23.29.35)

From: Carella Chen <carella.chen@infineon.com>

Advertise NL80211_EXT_FEATURE_ROAM_OFFLOAD only when firmware reports
FBT or OKC support. That lets userspace provide PMK material for
firmware roaming without enabling the path on devices that cannot
complete the offloaded roam.

Assisted-by: GitHub-Copilot-CLI:gpt-5.5
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
