Received: from smtp9.infineon.com (smtp9.infineon.com [217.10.52.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56064248D8
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 10:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785927465; cv=none; b=g+XNSzzC7Zt0Bg+VRj4zQb5zCvb7KD3bfEwIvHmzL//hiMJ7kmJxCYY9IhKbBubNiX3W5nqV29+jfNj52GxgJSjMXxgm1Kj90VJqSFlhzzspmUtJbF9CvaOMwA0KdP+76HWtWUb/IW3jKg+1VR5riibkh8v34ENdXjiwBdjSq3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785927465; c=relaxed/simple;
	bh=CMxSSDwG7TBBLfeGHlBpjUtyP+9Poexv42iPnpPxGjA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Mj5T3kH1DMt2dX9esUHZdjnISmiLBRZciDfDML9A6QQOD91Y+Fj+vot0hq72lvetbp43ag/zOnOS4r7W1T00E6bm/EJLfikbrIX2K3BkesO3oxJ3GVxqwPJFCn6jXKf2/ZFkTVYg9qt9DcJ7z1KlPfpinP3TRjCpLE3pmI6DCJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=nvs6fPno; arc=none smtp.client-ip=217.10.52.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="nvs6fPno"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1785927462; x=1817463462;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CMxSSDwG7TBBLfeGHlBpjUtyP+9Poexv42iPnpPxGjA=;
  b=nvs6fPnoITHZM7m5jHkctCieL9eeBkS4R70rfBL80ZAyiUuYs2mYmLhZ
   pvs8a4/tnRH1/MIDzMzDkpdV7XuOgFNVyHeCNQpuu4gl8PAFZdngrch+l
   Cnbqc/AKjwAnzm0ghXSND03VI9h7X3d0roF2VwZl/0yF2dHeLKUuuLnXO
   U=;
X-CSE-ConnectionGUID: vX/GDB2BQcSyeepxjpoaeg==
X-CSE-MsgGUID: 17FJhnRsT4WYS6zMO04JsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11865"; a="103562939"
X-IronPort-AV: E=Sophos;i="6.25,206,1779141600"; 
   d="scan'208";a="103562939"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE814.infineon.com) ([172.23.29.40])
  by smtp9.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 12:57:33 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE814.infineon.com
 (172.23.29.40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 5 Aug
 2026 12:57:32 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 5 Aug 2026 12:57:31 +0200
From: Jason Huang <Jason.Huang2@infineon.com>
To: <linux-wireless@vger.kernel.org>
CC: <wlan-kernel-dev-list@infineon.com>, Jason Huang
	<jason.huang2@infineon.com>
Subject: [PATCH v2 0/2] wifi: support authorized roaming offload reporting
Date: Wed, 5 Aug 2026 18:57:13 +0800
Message-ID: <20260805105716.35643-1-Jason.Huang2@infineon.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MUCSE808.infineon.com (172.23.29.34) To
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

