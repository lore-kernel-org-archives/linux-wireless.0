Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1335838D3E5
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 13:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791120378; cv=none; b=ka0DzcEkmn+C3Mb5hrjnPd3iNbVwCSMvji5Q4n1/rtkiAVw3sYEFPEE3KQoqKd9P15NeVTV6vlMi7JVNpteM0mYotFhHf8gjohujlDwenykPDpfCPx1Oip3Q1wuT5YJAuCtpbafyP10jxCDfuZmTaWrPr5HSUQVcMa4VuMyoGb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791120378; c=relaxed/simple;
	bh=coiTEVXeDxBMzNF8PAapFcUQB2y2KgzPXWQ1QzaHLKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHsJGp3Ce5Bjc3qxO9SQf/vWgruuNbgJRgmyezXf0qbb1f8tN8kHnBXYdxdf9C8R/it3hNsNKmA7XoZzOmakyFKPvHIVVBPL6icAeK5uHn0CeGhlwflDG7W1kjyEBHkY4rjGTiXLqxhPtkOmVxXdf7KqPuU04AtHGFsWr83tTeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SpVly8XL; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SpVly8XL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791120378; x=1822656378;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=coiTEVXeDxBMzNF8PAapFcUQB2y2KgzPXWQ1QzaHLKU=;
  b=SpVly8XLBeh3/+uxPLJ1G/D19ruPJW79oULMHxX4JP5nMfrB09+s/94X
   a28snU7yPEqXdddJ0C5vL3hZS3qIKUFXvqn11Blkkgv0Gs/G1AVAxYzn3
   4gPjkfsPttsz8XRduXJD8ciTGIVDFYOCZt7OhCZ2wZ5uv29BY6jQPLUFv
   rqJX0fq4SZJEmz5jDz5tSusXd1yDjNhVA7vLCa7LRnujZ65g8WlxEOpZy
   +D3enly1OR6CVnnrJJAtu1aI2d9XbP5aE0WPVht+fLim+eLApSUmzrFt/
   mkp7jhiu+ATQYu2eDqXegZKFvhbJuEz1Y3k67/xBjCTfctHbf335Wx3U7
   Q==;
X-CSE-ConnectionGUID: lXE2MM2HRly68OfMWWwsAQ==
X-CSE-MsgGUID: tVzzLrFIQ9CLZJkfPplo0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="102328701"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="102328701"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 06:26:17 -0700
X-CSE-ConnectionGUID: 9kT3sc9bS+yMqz0zqDiOhw==
X-CSE-MsgGUID: HJJK91JaSoaYX8xcIs1Ovg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="304569134"
Received: from weis0041.iil.intel.com ([10.12.217.187])
  by fmviesa001.fm.intel.com with ESMTP; 04 Oct 2026 06:26:15 -0700
From: Ilan Peer <ilan.peer@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH v2 07/11] wifi: ieee80211: add NAN service ID list attribute definitions
Date: Mon,  5 Oct 2026 10:40:32 +0300
Message-ID: <20261005074037.3506633-8-ilan.peer@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005074037.3506633-1-ilan.peer@intel.com>
References: <20261005074037.3506633-1-ilan.peer@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the Service ID List and Subscribe Service ID List NAN attribute
IDs. These are needed to filter in NAN beacons during Instant
Communication.

Assisted-by: GitHubCopilot:claude-opus-5
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 include/linux/ieee80211-nan.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/ieee80211-nan.h b/include/linux/ieee80211-nan.h
index b332a94671ba..7815a6cf8160 100644
--- a/include/linux/ieee80211-nan.h
+++ b/include/linux/ieee80211-nan.h
@@ -40,6 +40,8 @@
 /* NAN attributes, as defined in Wi-Fi Aware (TM) specification 4.0 Table 42 */
 #define NAN_ATTR_MASTER_INDICATION		0x00
 #define NAN_ATTR_CLUSTER_INFO			0x01
+#define NAN_ATTR_SERVICE_ID_LIST		0x02
+#define NAN_ATTR_SUBSCRIBE_SERVICE_ID_LIST	0x28
 
 struct ieee80211_nan_attr {
 	u8 attr;
-- 
2.55.0

