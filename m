Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7763F2101
	for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2026 11:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777462871; cv=none; b=J9BjphGGexzc0PA+kStH7jXkbLmo8Ct8tAfafQ5lJpuig3Myon5Wr2M9REBtb6WExgpgl7FFD/STQec7hggCTH767KijT+L54P4CR2IwHRdJ4X5ZZQI/VqqCoequrM/d4FJe23MocXvk+kdPkRoa/gvFiZVssD3YHmh+yb8S/9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777462871; c=relaxed/simple;
	bh=RS3EKfpot6D7dTUjQ3XjZqVY1xcnz4AL+HQugEAKGqA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q5kqvqo9s6rOHrEzvkgNxRPevltFeyhoeCuMF74Js0e/4XqJf5tr3HzPqVBoz0m3BQ4vjFXH/IJ1txdtgJeEBeOmsLgGg39GLBtjPFlPswXKOkqsCbi/33GVmraXK/62T0hZg/rN0c0lp6U+Jct7SPqxMudnmA/loRqCoOKfHk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dxVTnxXu; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dxVTnxXu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777462870; x=1808998870;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RS3EKfpot6D7dTUjQ3XjZqVY1xcnz4AL+HQugEAKGqA=;
  b=dxVTnxXuGTGTHaCTW+NXL2sZEVgQNoo2DL7jFPMiNjuLh1iqT7Uyt7Ct
   4DgH2gD9GleQc8JSd2+0T42hS3SNSaIISOlbz/DgXHCSERz/BD5ftcQxn
   dXzyuyt1/y5Np+Ujuxxh2q6jZEllJJLfJIvj+Gd5n0ENZCoxfUESIgJM0
   ycqhGssqq9iSDL538UWap90RN3w3M/wjP/gz7EqPhPxB2L5vUSZwwBKce
   KYNknIi4ZlVunwX8uK4U+7g+jlYwx7yovky3eidrRC2aATBNJirhQQVw6
   KygLiDd86EigdgratQJBbRH/ZjmrZF/CxVv8NvDYgWsNv1mdvVBY6t94L
   A==;
X-CSE-ConnectionGUID: p9/n/1vFTVGBAIpfyDwk/A==
X-CSE-MsgGUID: SLfxhtUcRjGBFi4kIO0vgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11770"; a="88986118"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="88986118"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 04:41:09 -0700
X-CSE-ConnectionGUID: QJhi3bnRSK+jEzYnMmuXdQ==
X-CSE-MsgGUID: igwur1ScSJ+5ltoOXOfEfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="234505125"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 04:41:08 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Subject: [PATCH v2 wireless-next 05/15] wifi: mac80211: Fix a kernel panic in ieee80211_encrypt_tx_skb()
Date: Wed, 29 Apr 2026 14:40:39 +0300
Message-Id: <20260429114049.4167111-2-miriam.rachel.korenblit@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260429114049.4167111-1-miriam.rachel.korenblit@intel.com>
References: <20260429114049.4167111-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

skb->dev may be NULL for frames on non-netdev devices. For example, NAN
device frames after pairing. Fix it.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/mac80211/tx.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c18de2cb3769..933c86ca21c3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -5355,7 +5355,7 @@ static int ieee80211_beacon_protect(struct sk_buff *skb,
 int ieee80211_encrypt_tx_skb(struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = NULL;
 	struct sk_buff *check_skb;
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result res;
@@ -5370,7 +5370,14 @@ int ieee80211_encrypt_tx_skb(struct sk_buff *skb)
 	__skb_queue_head_init(&tx.skbs);
 	__skb_queue_tail(&tx.skbs, skb);
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(skb->dev);
+	if (skb->dev)
+		sdata = IEEE80211_DEV_TO_SUB_IF(skb->dev);
+	else if (info->control.vif)
+		sdata = vif_to_sdata(info->control.vif);
+
+	if (WARN_ON(!sdata))
+		return -EINVAL;
+
 	tx.sdata = sdata;
 	tx.local = sdata->local;
 	res = ieee80211_tx_h_encrypt(&tx);
-- 
2.34.1

