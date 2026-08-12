Received: from smtp14.infineon.com (smtp14.infineon.com [217.10.52.160])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C388C2236FA
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 03:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.160
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786506319; cv=none; b=FZb7jOXlx+RQuD9+prRl6Rs4XUMMfZ4R7O+NVN/GHEcFR2BtgIIfgyyHGcDJ710NqZVurvKmL3DSb/YIRDlXZsQf30XKTjTnc6F0sQdLANZHZOF2B5PFP9AjqynGKU9tl0FbuS2V6rFBsEtsW0iN28jhqsKMlSyXbEFNkeI3UL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786506319; c=relaxed/simple;
	bh=isRc64ciVJWFljmODHAkGemAZ3TfGRjXOjsL2IeWfJA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jy1W1AhMNuH4kGwtXq1JE4rFZrXTxFIHbKOZLZhsS0MSPUzwZ66JfB2JPRw3zKuIch2qCbiGrqS7MxEg8DhuJT5Xx833p4mQAfmKvGl2SnoHBChwEpvtDu8FX779SICzKBVCWuogBgRFcifzqMcerB2PFDVi870fwYBmGRHgxiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=d98gsW4Z; arc=none smtp.client-ip=217.10.52.160
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="d98gsW4Z"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1786506318; x=1818042318;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=isRc64ciVJWFljmODHAkGemAZ3TfGRjXOjsL2IeWfJA=;
  b=d98gsW4Z8nwm/BL5geyAeLdpTPfqZmnG8KxrQ51RubM6oK64k/Rhpcpd
   mqH0REdF2+x2PBd/ddNQyzc1Gp47puQAxW8K3RJInNS17/Se6F/HNZcep
   ypUJzqwi1sPrct3jErMUppISsiDFcR1NNXf61ue/gZTK1d/qkL/EwRrOq
   Y=;
X-CSE-ConnectionGUID: BRve7Y3SR1Wm5CddBP2wqg==
X-CSE-MsgGUID: vZsskwmLRoWTANrE5QFvmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11872"; a="141616098"
X-IronPort-AV: E=Sophos;i="6.25,218,1779141600"; 
   d="scan'208";a="141616098"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE803.infineon.com) ([172.23.29.29])
  by smtp14.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 05:45:09 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE803.infineon.com
 (172.23.29.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 12 Aug
 2026 05:45:09 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 12 Aug 2026 05:45:08 +0200
From: Jason Huang <Jason.Huang2@infineon.com>
To: Jason Huang <Jason.Huang2@infineon.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v4 0/5] brcmfmac: add FT/OKC roaming offload support
Date: Wed, 12 Aug 2026 11:44:51 +0800
Message-ID: <20260812-upstream-wireless-next-main-jason-11r-support-v1-v4-0-b1843e1f6de4@infineon.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260810-upstream-wireless-next-main-jason-11r-support-v1-bdc2c27501ad
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786505858; l=1156; i=jason.huang2@infineon.com; s=20260810; h=from:subject:message-id; bh=isRc64ciVJWFljmODHAkGemAZ3TfGRjXOjsL2IeWfJA=; b=6mVqRuyCHx7hYNTVwZtWQ9BlDlfBALK5YbHnKtuorzo/iZTVo0aAI2oXuw9ZZI8730HVYPvl2 gr9od6Cnzz+BGlkTbNi6fY52z9R4R3rQmAVNPLhu1fgMxWk5HfBLL1Q
X-Developer-Key: i=jason.huang2@infineon.com; a=ed25519; pk=BmqGCssp9w9TsTSVHuzcc6+C1o5uJ0uZK4ZSmrma28M=
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MUCSE816.infineon.com (172.23.29.42) To
 MUCSE809.infineon.com (172.23.29.35)
Message-ID: <20260812034451.FgDAHkc6aJeZYS93eJPlQWA5DdkF2wlb7UdFUeAgBjc@z>

Changes in v4:
- Resend the complete 5-patch series because v3 reached linux-wireless
  without patch 5/5.
- No code changes from v3.

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

