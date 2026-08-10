Received: from smtp9.infineon.com (smtp9.infineon.com [217.10.52.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75A93C0A1F;
	Mon, 10 Aug 2026 11:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786362078; cv=none; b=UfHRDdONRb7YbP/8lVFx7bIllRt7yF6n2Dewds6ePTQC17UPV3cnOQTDaxJM6ATBQ0B51Yf4FA7KJ2PYudNegdL553B93T9DzWc99JaNIHVAHAmDRTAzGyMCAZCQrlNU5YTKXsbSiXWxEpjFuvwszqqawjORAozVo8oFzfxi8Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786362078; c=relaxed/simple;
	bh=iC++ZRTCcOc1mRqxcM130EJQxxgP7M+hKLNBVoBysvU=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type:To:CC; b=F9VJm6rOp5zo3sCHOMDyRU/QLVQUeDrsL/WC+oDDqM8lbZIpJMh8n9qWIDFHThsyErsusXtnwqdNqGRDwzUloIPnTVyhmjhN1qbOmSBh7HiRLMbNSzMTfRujtNQfKGWL/M+lfuH3wtntkef+8lyNKmiGkJlY6Q31YeP/HN7L2KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=e0t5HJ/Z; arc=none smtp.client-ip=217.10.52.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="e0t5HJ/Z"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1786362076; x=1817898076;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=iC++ZRTCcOc1mRqxcM130EJQxxgP7M+hKLNBVoBysvU=;
  b=e0t5HJ/ZoCpsQadE4w/s96Z9WyiQkkChilUe00un2acUYbo+AEVxWoTQ
   6RVScDIhQEF9nxuRqc0Rnm4CkaCfOS1maxhZRu795PdDTpUuN/vl1AVEC
   SH+kMqhdigzaQWoSG0IBQS3HwDgZIYp8JwlF2XJspkWaldrTjVqGrywzZ
   k=;
X-CSE-ConnectionGUID: nbMbrpNSTuOWuDi9b28hbg==
X-CSE-MsgGUID: xxqR7PFJQbuUP3r0LIJQeQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11870"; a="104127851"
X-IronPort-AV: E=Sophos;i="6.25,215,1779141600"; 
   d="scan'208";a="104127851"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE805.infineon.com) ([172.23.29.31])
  by smtp9.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2026 13:41:08 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE805.infineon.com
 (172.23.29.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 10 Aug
 2026 13:41:07 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 10 Aug 2026 13:41:04 +0200
From: Jason Huang <Jason.Huang2@infineon.com>
Subject: [PATCH v3 0/5] brcmfmac: add FT/OKC roaming offload support
Date: Mon, 10 Aug 2026 19:40:52 +0800
Message-ID: <20260810-upstream-wireless-next-main-jason-11r-support-v1-v3-0-bce4f460ae0b@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMS4eWoC/x3NTQoCMQxA4asMWRtoKv7gVcRFbaNGnLYknXFgm
 LtbXH6b91YwVmGDy7CC8iwmJXfsdwPEV8hPRknd4J0/ujM5nKo15TDiV5Q/bIaZl4ZjkIzvYCU
 jkaJNtRZtOBPeU/TRnw6OQoKercoPWf7L623bfhVnJ3aCAAAA
X-Change-ID: 20260810-upstream-wireless-next-main-jason-11r-support-v1-bdc2c27501ad
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>, Arend van Spriel
	<arend.vanspriel@broadcom.com>, <linux-kernel@vger.kernel.org>,
	<brcm80211@lists.linux.dev>, <brcm80211-dev-list.pdl@broadcom.com>,
	<wlan-kernel-dev-list@infineon.com>, <jeff.johnson@oss.qualcomm.com>,
	"Carella Chen" <carella.chen@infineon.com>, Jason Huang
	<jason.huang2@infineon.com>, Darren Li <hsin-hung.li@cypress.com>,
	Chung-Hsien Hsu <Chung-Hsien.Hsu@infineon.com>, Chi-hsien Lin
	<chi-hsien.lin@cypress.com>, Shelley Yang <shelley.yang@infineon.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786362064; l=1458;
 i=jason.huang2@infineon.com; s=20260810; h=from:subject:message-id;
 bh=iC++ZRTCcOc1mRqxcM130EJQxxgP7M+hKLNBVoBysvU=;
 b=3RZU0ItgVqtv2txN5X13fY9rjBupVokoHrTQS+CcXvFPio8OkCfkkEh9T/fhrN+748NTZG/RQ
 b6zGFItkLriCP6qTvPW2plj5zOPQVUZ5r/yMQCD+2Bj9ZWkwgriohPr
X-Developer-Key: i=jason.huang2@infineon.com; a=ed25519;
 pk=BmqGCssp9w9TsTSVHuzcc6+C1o5uJ0uZK4ZSmrma28M=
X-ClientProxiedBy: MUCSE815.infineon.com (172.23.29.41) To
 MUCSE809.infineon.com (172.23.29.35)

Changes in v3:
- Send as a new standalone thread; v2 was accidentally posted once without
  patches and once as a reply to v1.
- Stop using deprecated NL80211_ATTR_PORT_AUTHORIZED and report authorization
  through cfg80211_port_authorized(), which emits NL80211_CMD_PORT_AUTHORIZED.
- Squash OKC PMK programming and firmware roaming supplicant mode into one
  brcmfmac patch.
- Clean up authorship/trailers for the squashed patch.

---
Carella Chen (3):
      wifi: nl80211: add roam offload extended feature
      wifi: brcmfmac: detect firmware FBT and OKC support
      wifi: brcmfmac: advertise firmware roam offload support

Darren Li (2):
      wifi: brcmfmac: add PMK programming for firmware roaming offload
      wifi: brcmfmac: report port authorization after offloaded roaming

 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 125 +++++++++++++++++++--
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |   4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |   2 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |   4 +-
 include/uapi/linux/nl80211.h                       |   4 +
 net/wireless/nl80211.c                             |   4 +-
 6 files changed, 129 insertions(+), 14 deletions(-)
---
base-commit: 6c5fc504d0d6934132637aa3db4b9b58148eaa78
change-id: 20260810-upstream-wireless-next-main-jason-11r-support-v1-bdc2c27501ad

Best regards,
-- 
Jason Huang <jason.huang2@infineon.com>

