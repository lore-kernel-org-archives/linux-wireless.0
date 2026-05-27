Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86873B19BF
	for <linux-wireless@vger.kernel.org>; Wed, 27 May 2026 19:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779911522; cv=none; b=AnZ5rbaOs/vl/lbOUGtLCcQzjbfqY96Bihea4wqXBcllyO7ownGManWrVH6F+Y7ZKR8D2Cg+L3wGkbfD0gekI+3wb6LHPiFsL7ylU3oc1OqX8BMmwGGznaLSP+ZpBWb2qla16Ds6T4tpHQ3ZtOMsI5JDRBjCN2kGpAGaaWhK7FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779911522; c=relaxed/simple;
	bh=n7mi43OgolxAqsOY5ySqGjdBOPMLwbK8j6+DC0CDifI=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=MUvtNMvP+0OMdwTATq0x5LnAsqg5K+E4CA6dqWm/xYwNxHXAbc9lrveSGFPouRePmAb1iI+H4g5O+nQMb0QF72K0rlUO5q13BMl0TD/qibOPpRzZUYf3s2O3Wa4hmvHf9j78aTiiKThWsaSSmnakIVCE2wrQt0BExwKr2/T+xbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JrRIoO4+; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JrRIoO4+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779911521; x=1811447521;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=n7mi43OgolxAqsOY5ySqGjdBOPMLwbK8j6+DC0CDifI=;
  b=JrRIoO4+svBxByQf34Dh3B8u3k0wJfLqhIkCP6lAyneUjVDkvdSzM4C9
   9zgUuQgraOMyp4r1deNlwlEMxeNyHKZXMzgSvlc87AnpSzAUHylpJ8S7v
   HHefySKM80KJ3cA2/jX0ZCOe7N3f9nqMSFgJbjmk+A5a3Q428zyJ7hpPA
   9ElpXRaGqMInCOa+BzMO4tKGiRYwohG6SGST3FtPSafRkp5ew4PXtOSvz
   5xUw8stax+EZOqxKKl+Tcbo6ANlOxqQCzHxRDhdvP/mjt+sz391XsTyJ0
   ZZNFP9uj/CZHQXMsY+A/J/JMClpKGFITyGe1zM5CEt1Dl2W4hEz1XLJUi
   w==;
X-CSE-ConnectionGUID: y/rZGv+rRhSAAClN01zGYg==
X-CSE-MsgGUID: Kbgd/HocQX+DytDH/gSw+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="80784718"
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="80784718"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 12:52:00 -0700
X-CSE-ConnectionGUID: plvEYltlTjCJVyuB4doNCg==
X-CSE-MsgGUID: vUm1a+FYQAWKRsGq3qnsfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,172,1774335600"; 
   d="scan'208";a="280465108"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2026 12:51:59 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 0/3] wifi: mac80211: fix channel evacuation logic
Date: Wed, 27 May 2026 22:51:42 +0300
Message-Id: <20260527195145.468037-1-miriam.rachel.korenblit@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

This series is fixing the channel evacuation logic: in case we are
missing a chanctx for example for a BSS, we will fail the combination
check.
OTOH, we don't want to evacuate a NAN channel and then find out that
there are other things that prevent this BSS channel.
This series adds an option to ingore one of the exitsing channel
contexts in the combination check (the one we want to evacuate) to make
sure that all other conditions meet for adding the new BSS channel.
In that case, we will evacuate the NAN channel.

Miri Korenblit (3):
  wifi: mac80211: add an option to filter out a channel in combinations
    check
  wifi: mac80211: refactor ieee80211_nan_try_evacuate
  wifi: mac80211: fix channel evacuation logic

 net/mac80211/chan.c        | 78 ++++++++++++++++++++++++++++++++------
 net/mac80211/ieee80211_i.h | 67 +++++++++++++++++++++++++++-----
 net/mac80211/nan.c         | 55 ++++++++++++++++-----------
 net/mac80211/util.c        | 34 ++++++++++-------
 4 files changed, 179 insertions(+), 55 deletions(-)

-- 
2.34.1

