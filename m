Received: from smtp2.infineon.com (smtp2.infineon.com [217.10.52.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AA1231832
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 11:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785927764; cv=none; b=bUdN1UyXSe2X6Jo7RwxhBu1T5vNgjJy+1iMLU+aW75z9pgRoAB3JUuBItFIpi7dzRgRpVMBwSJJjWB4Q1gGHm4IYeODt5OikGFc8tb+nWh8qWKs7nUkeEHqOj8KIIfbo1l1z+Y66QiMwl3pbk1ehY+RKGYkMVACAfFpMZpMLk4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785927764; c=relaxed/simple;
	bh=CMxSSDwG7TBBLfeGHlBpjUtyP+9Poexv42iPnpPxGjA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qurCAuOI/k8qCuNrhY1cyWes3J90HzFCYSK6O7+aBWrnXo3HUVSgB1hUHQOp1pbM/8hci/h6de93zR66d3FZI57nd/muiPZNXADUj4LPVEnits/FAaRhhjANIhqP5mgWPAt2J4xdAyrRb+xD0CA56LCwuI1QQDdIxPjVZbmjCtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=fOC+oH4V; arc=none smtp.client-ip=217.10.52.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="fOC+oH4V"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1785927763; x=1817463763;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CMxSSDwG7TBBLfeGHlBpjUtyP+9Poexv42iPnpPxGjA=;
  b=fOC+oH4VbhEhYFCJWQbt5mYk/SV33wBGBYEtnbhlBX6QdQBAcDFEWUf1
   BcIrtnhYuJ+G+ni08kJ378C+ylDcIUAg/FZtd/H+fk30JF+7Hp9JS2obp
   v32Lfa7XFYariRRxNEVoYCwlU4YCp+jGTTLUB5TGPudyhUQ+/T+NN/2wr
   o=;
X-CSE-ConnectionGUID: tJoxWXDESfiuxPDmR3FAqg==
X-CSE-MsgGUID: XQbUGsS4RD+0pmozgAJBFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11865"; a="171047930"
X-IronPort-AV: E=Sophos;i="6.25,206,1779141600"; 
   d="scan'208";a="171047930"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE819.infineon.com) ([172.23.29.45])
  by smtp2.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 13:01:31 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE819.infineon.com
 (172.23.29.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 5 Aug
 2026 13:01:30 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 5 Aug 2026 13:01:29 +0200
From: Jason Huang <Jason.Huang2@infineon.com>
To: <linux-wireless@vger.kernel.org>
CC: <wlan-kernel-dev-list@infineon.com>, Jason Huang
	<jason.huang2@infineon.com>
Subject: [PATCH v2 0/2] wifi: support authorized roaming offload reporting
Date: Wed, 5 Aug 2026 19:01:14 +0800
Message-ID: <20260805110116.35884-1-Jason.Huang2@infineon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260804030450.232028-1-Jason.Huang2@infineon.com>
References: <20260804030450.232028-1-Jason.Huang2@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MUCSE821.infineon.com (172.23.29.47) To
 MUCSE809.infineon.com (172.23.29.35)

From: Jason Huang <jason.huang2@infineon.com>

This is a shorter resend of the cfg80211/nl80211 API patches from the
previous 7-patch series. The earlier submission appears to have been
partially processed, so resend only these two prerequisite patches as a
standalone series.

The series lets drivers report connect and roam events that are already
authorized by firmware offload, and adds a roam offload extended feature
so userspace can provide PMK material for FT/OKC roaming offload without
requiring full 802.1X 4-way handshake offload support.

Changes in v2:
- Resend as a shorter 2-patch series for nipa processing.
- No code changes

Jason Huang (2):
  wifi: cfg80211: report authorized connect and roam events
  wifi: nl80211: add roam offload extended feature

 include/net/cfg80211.h       |  6 ++++++
 include/uapi/linux/nl80211.h |  8 +++++++-
 net/wireless/nl80211.c       | 10 ++++++++--
 net/wireless/sme.c           |  2 ++
 4 files changed, 23 insertions(+), 3 deletions(-)


base-commit: 6c5fc504d0d6934132637aa3db4b9b58148eaa78
-- 
2.25.1

