Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0240283FCF
	for <linux-wireless@vger.kernel.org>; Mon,  4 May 2026 07:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777879282; cv=none; b=D9sE32F+sAQ6HPxMm5gFEhn2I5GrloaoYeMNMKdcCa+TiveX3j805MMfasJIbXXdYMbudAqE1CItKzUYPKI66gUiC6KEA2UvqNGaeSa6+02MjPx+If8CtRLwDadwEl4QA+gohGbaD5jU5o04Dr/1HJNzDW4zmgVo3PvveASUWbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777879282; c=relaxed/simple;
	bh=XMUBzYW4ZmvubPpHYMYpnNs13e+TeVRvFuTp6UT2SaM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ix5brhOwSmHLXQK/e7b2xEQIQMXRJeLR0owYZIeVE6SkQhjncRLuoq3x+9wbwBRFOWt5VGwpzsG3igHEcnlBKQd8wdDhI1NMWulg1nRjxG41WTHpG5AXbE7LSH2MlSrP57F9fk0RQbynINHE/eZMNIhL+OOrxINuN52RXwYKgqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VI9bkpOz; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VI9bkpOz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777879281; x=1809415281;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XMUBzYW4ZmvubPpHYMYpnNs13e+TeVRvFuTp6UT2SaM=;
  b=VI9bkpOzKa5VdbfOSp4VP1YcKdi2oUye6XNi4KkV0htnTXt8YFPYH6jj
   gMOGJPhPQfPr+qU8auW+eYH75U8Y24J/Z12FPAa0wNlbmE0mXWsm82Df9
   F/LCmt9nd2bo4ZAob9/LFX6x1/OybVHyq6VfuXM75j1+x9JVmT8iwK2j0
   fSFUSFQaIbynah4yzUtnaOUfKU/CrwKMhJZL4W/UdTzj+rYCGAy3/iMuc
   3GBnDIOsW0hDf+aP1ADF60AF983Ib+MNkyrluUxBjMxCf6/VVj4wgNKJg
   H5NhKUn2LrW9ZrXy9a6RZXz9QNhtnU+EKTEb91kBreKd0C5FNZIMrCALI
   Q==;
X-CSE-ConnectionGUID: 4GLoL3tVS7uo2in8DowK1w==
X-CSE-MsgGUID: 5XzkTcwPTXKHjVPhIjmLyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11775"; a="101398319"
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="101398319"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 00:21:18 -0700
X-CSE-ConnectionGUID: ZS8/Gn5CRdqjRtSCyBWEXw==
X-CSE-MsgGUID: tp6t9vjGQdeCvvIBdA4pLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="273555229"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 00:21:12 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>
Subject: [PATCH v4 wireless-next 03/15] wifi: mac80211: accept protected frames for NAN device
Date: Mon,  4 May 2026 10:20:43 +0300
Message-Id: <20260504101829.1900c926c2e8.Ia25b2e82b250058fefa179c39327d9c8b3c3cd62@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260504072055.1292999-1-miriam.rachel.korenblit@intel.com>
References: <20260504072055.1292999-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Avraham Stern <avraham.stern@intel.com>

Some frames sent to the NAN device may be protected, such as
protected action frames (in particular protected dual of
public action).

Accept robust management frames except disassoc on the NAN
device, and clean up the code a little bit.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/mac80211/rx.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 82ea7404f3da..e1f376e0620c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4624,16 +4624,24 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 		    ieee80211_has_fromds(hdr->frame_control))
 			return false;
 
-		/* Accept only frames that are addressed to the NAN cluster
+		/*
+		 * Accept only frames that are addressed to the NAN cluster
 		 * (based on the Cluster ID). From these frames, accept only
-		 * action frames or authentication frames that are addressed to
-		 * the local NAN interface.
+		 *  - public action frames,
+		 *  - authentication frames to the local address, and
+		 *  - robust management frames except disassoc.
 		 */
-		return memcmp(sdata->u.nan.conf.cluster_id,
-			      hdr->addr3, ETH_ALEN) == 0 &&
-			(ieee80211_is_public_action(hdr, skb->len) ||
-			 (ieee80211_is_auth(hdr->frame_control) &&
-			  ether_addr_equal(sdata->vif.addr, hdr->addr1)));
+		if (!ether_addr_equal(sdata->u.nan.conf.cluster_id, hdr->addr3))
+			return false;
+		if (ieee80211_is_public_action(hdr, skb->len))
+			return true;
+		if (ieee80211_is_auth(hdr->frame_control) &&
+		    ether_addr_equal(sdata->vif.addr, hdr->addr1))
+			return true;
+		if (!ieee80211_is_disassoc(hdr->frame_control) &&
+		    ieee80211_is_robust_mgmt_frame(skb))
+			return true;
+		return false;
 	case NL80211_IFTYPE_NAN_DATA:
 		if (ieee80211_has_tods(hdr->frame_control) ||
 		    ieee80211_has_fromds(hdr->frame_control))
-- 
2.34.1

