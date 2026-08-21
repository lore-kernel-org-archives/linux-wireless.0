Received: from smtp2.infineon.com (smtp2.infineon.com [217.10.52.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900193932DB;
	Fri, 21 Aug 2026 07:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787299010; cv=none; b=pdw0IF/GiPnQ9yA8zpgxIZM4UKlRDWLInmjdNFzNPHBftbbGDVVdOAcF2vQ+tTHCjkwBaBBRztJNkTluZ8DpBJTbU1kYDPEpfGdViiba5fISlPjXUNoLve1eW8C3j3TbEVNrIGEJPNzNbHv0W/OiCZjOqcpeWDA4N3xunTMSy5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787299010; c=relaxed/simple;
	bh=pqV5zIsVJwu6oCyIejvTylXpCDETkfNZe8pi0nJksVc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=T53w9OhlWY0ViTFT2UZuv14bEvescdo/BbdfGiaRAAkjS13c2W3tgFAW7/WCCit/we3wwMtVQ47x/aIgO9vpCGKYPna7n4NuV29zDuemfZ8KRrQCoU31MD3jWnqpW3YAVxlpCB8tjOuEueYoVFRcYKF60AE+9oL6x/GtgsU85ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=V4wvHf0D; arc=none smtp.client-ip=217.10.52.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="V4wvHf0D"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1787299009; x=1818835009;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pqV5zIsVJwu6oCyIejvTylXpCDETkfNZe8pi0nJksVc=;
  b=V4wvHf0Dhb+cgxtpcwVecVlDYFxdeSHGaQAsG8etHlLJy8kY3aTx6S7I
   UCICHGJsltf4KE324SNi/0/beJ4DPT0GSJ+4LwkjNsd0EjWFPVFFleULg
   5Y8ifwGBYN891TfiDU+IUNpuAHfPqtu7BNZlpCERcYv/HIlPlJ8tEdcyV
   M=;
X-CSE-ConnectionGUID: XyiW7hTOTeG363vfDvBgxQ==
X-CSE-MsgGUID: iv5YheliTDSQtxHsT2WUzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11881"; a="173751557"
X-IronPort-AV: E=Sophos;i="6.25,234,1779141600"; 
   d="scan'208";a="173751557"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE803.infineon.com) ([172.23.29.29])
  by smtp2.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 09:56:39 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE803.infineon.com
 (172.23.29.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 21 Aug
 2026 09:56:39 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 21 Aug 2026 09:56:35 +0200
From: Jason Huang <Jason.Huang2@infineon.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes.berg@intel.com>, <johannes@sipsolutions.net>,
	<arend.vanspriel@broadcom.com>, <hsin-hung.li@cypress.com>,
	<linux-kernel@vger.kernel.org>, <brcm80211@lists.linux.dev>,
	<brcm80211-dev-list.pdl@broadcom.com>, <wlan-kernel-dev-list@infineon.com>,
	<jeff.johnson@oss.qualcomm.com>, Carella Chen <carella.chen@infineon.com>
Subject: [PATCH v5 0/5] brcmfmac: add FT/OKC roaming offload support
Date: Fri, 21 Aug 2026 15:56:12 +0800
Message-ID: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-0-eeab4fda0f31@infineon.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260821-upstream-wireless-next-main-jason-11r-support-v1-0201e1f9c0e0
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MUCSE812.infineon.com (172.23.29.38) To
 MUCSE809.infineon.com (172.23.29.35)

From: Carella Chen <carella.chen@infineon.com>

This series adds the cfg80211/nl80211 and brcmfmac pieces needed to
support firmware-assisted FT/OKC roaming offload.

Patch 1 adds an nl80211 extended feature bit so drivers can advertise
roaming PMK programming support without claiming full 802.1X 4-way
handshake offload. The brcmfmac patches then detect firmware FBT/OKC
capabilities, keep roaming-offload connections in a firmware-supplicant
profile state, program PMK material for FT/OKC roaming, report port
authorization after offloaded roaming, and advertise the new capability
when firmware support is present.

Changes in v5:
- Reworked nl80211_set_pmk() to avoid the 80-column checkpatch warning
  on the 4-way handshake extended-feature check.
- Added kernel-doc for the brcmfmac OKC profile state added by the PMK
  programming patch.
- Normalized Assisted-by trailers to the checkpatch-accepted
  AGENT_NAME:MODEL_VERSION format.
- Added Johannes and the wireless/brcm80211 lists to the cover letter
  Cc list for the nl80211 and brcmfmac changes.

Changes in v4:
- Resend the complete 5-patch series because v3 reached linux-wireless
  without patch 5/5.
- No code changes from v3.

Changes in v3:
- Send as a new standalone thread; v2 was accidentally posted once without
  patches and once as a reply to v1.
- Stop using deprecated NL80211_ATTR_PORT_AUTHORIZED and report
  authorization through cfg80211_port_authorized(), which emits
  NL80211_CMD_PORT_AUTHORIZED.
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
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |   5 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |   2 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |   4 +-
 include/uapi/linux/nl80211.h                       |   4 +
 net/wireless/nl80211.c                             |   7 +-
 6 files changed, 132 insertions(+), 15 deletions(-)
---
base-commit: 6c5fc504d0d6934132637aa3db4b9b58148eaa78
change-id: 20260821-upstream-wireless-next-main-jason-11r-support-v1-0201e1f9c0e0

Best regards,
-- 
Jason Huang <jason.huang2@infineon.com>
