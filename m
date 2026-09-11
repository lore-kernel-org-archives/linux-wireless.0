Received: from smtp11.infineon.com (smtp11.infineon.com [217.10.52.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C5743BDBD
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 06:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789109919; cv=none; b=gOTbjIaM48EUUAhwys1g9mc6OqZLpo2H+mEqEVIdhxHjUlo5ToDY/Rl2qsNJzaGikFTJQMyR+QGvo5EHSc+BQU7Xgk+JEIKhDjgf/s3QPENmldsOyhuxBCE//WQGY28gapFa6gDewYCEDOaSC0wKDI1icRRS5ho2kvOATtKwVv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789109919; c=relaxed/simple;
	bh=61RYUGjdkaoQYz04DW2oxAwj6n4bjj9HEFLrGxw4heQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jJ6yhUz8Rpge93diVrKx52Dz2rdCzkC+kFaF2lvX5som7fDbZr4wEymN6kC2ijXqMDBs+NQPuPWyI57lNxfj4SH/JNTEfc7iELfx7GnQLcdMdEWhsdx0YhxbOUiUzsClc+eeEjeGQ1BWXbCHlIz0/sEO07bDFMJ/S6qztG4hfyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=bF03WvvO; arc=none smtp.client-ip=217.10.52.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="bF03WvvO"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1789109915; x=1820645915;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=61RYUGjdkaoQYz04DW2oxAwj6n4bjj9HEFLrGxw4heQ=;
  b=bF03WvvOnuvM+ua3HkJoou6kDM+YbgAStb/TwMuhSujcN3bH/14oBKH7
   pq7JqzXMGJ6pbGKC7tp4Lt6dngHAPjIk2hQX6bWnb36DRqmAN/4F/qTlf
   rHZy1Bn2rlD6PguxAB+jLqGUDD++U3k0HcjKpI9h1L+aAFtLCPujy0E09
   o=;
X-CSE-ConnectionGUID: zrffpcJQSau+xtnFhr9FXQ==
X-CSE-MsgGUID: N+lOoyI+RTGur5TpUMcLug==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="160622688"
X-IronPort-AV: E=Sophos;i="6.27,96,1787004000"; 
   d="scan'208";a="160622688"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE805.infineon.com) ([172.23.29.31])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 08:57:12 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE805.infineon.com
 (172.23.29.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Fri, 11 Sep
 2026 08:57:11 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 11 Sep 2026 08:57:09 +0200
From: Jason Huang <Jason.Huang2@infineon.com>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>, Arend van Spriel
	<arend.vanspriel@broadcom.com>, <brcm80211@lists.linux.dev>,
	<wlan-kernel-dev-list@infineon.com>
Subject: [PATCH v6 0/5] wifi: brcmfmac: add FT/OKC fast roaming offload support
Date: Fri, 11 Sep 2026 14:56:51 +0800
Message-ID: <20260911065656.1269623-1-Jason.Huang2@infineon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-0-eeab4fda0f31@infineon.com>
References: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-0-eeab4fda0f31@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MUCSE806.infineon.com (172.23.29.32) To
 MUCSE809.infineon.com (172.23.29.35)

From: Jason Huang <jason.huang2@infineon.com>

Hi,

This series adds nl80211 and brcmfmac support for firmware fast roaming
offload covering FT and OKC.

Some Broadcom/Infineon firmware can offload FT or OKC roaming without
advertising full 802.1X 4-way handshake offload. The series adds a new
nl80211 extended feature bit for this capability, lets userspace install
and delete PMK material when the driver advertises it, and wires the
capability through brcmfmac based on firmware FBT/OKC support.

For brcmfmac, the series tracks FBT and OKC firmware capabilities, keeps
the firmware supplicant profile state distinct for roaming offload, passes
PMK material to firmware for FT/OKC, and reports port authorization after
successful offloaded roaming.

Changes in v6:
- Rename the nl80211 extended feature to
  NL80211_EXT_FEATURE_FAST_ROAM_OFFLOAD to better describe that userspace
  offloads fast-roaming handling to the driver/firmware. The feature covers
  both FT and OKC.
- Reorder the nl80211 PMK capability checks to avoid the line-length
  warning.
- Allow nl80211_del_pmk() for FAST_ROAM_OFFLOAD-only drivers, matching
  nl80211_set_pmk(), so userspace can delete PMK material it was allowed to
  install.

Carella Chen (3):
  wifi: nl80211: add fast roam offload extended feature
  wifi: brcmfmac: detect firmware FBT and OKC support
  wifi: brcmfmac: advertise firmware fast roam offload support

Darren Li (2):
  wifi: brcmfmac: add PMK programming for firmware roaming offload
  wifi: brcmfmac: report port authorization after offloaded roaming

 .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 125 ++++++++++++++++--
 .../broadcom/brcm80211/brcmfmac/cfg80211.h    |   5 +-
 .../broadcom/brcm80211/brcmfmac/feature.c     |   2 +
 .../broadcom/brcm80211/brcmfmac/feature.h     |   4 +-
 include/uapi/linux/nl80211.h                  |   5 +
 net/wireless/nl80211.c                        |  10 +-
 6 files changed, 136 insertions(+), 15 deletions(-)

-- 
2.25.1
