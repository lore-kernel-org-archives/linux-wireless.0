Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84084391E4E
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 13:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791120379; cv=none; b=HBdcwdTEZrD4p4R9Fin7F8ZrVEY04lS43HgFi9HVueouhutxTLAJZB13r6d1vnTi1XZdLLIe19V/QACXOjqSInGHqbHCewUG3jw4ng2wrneKUK//gZgtSWWnZKjY20/RtOUyjCfTvNYAcmWmF8qOV9KdnGMAHls0gP8CazO1mnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791120379; c=relaxed/simple;
	bh=MPs94zrn0NonwLqgoHkP0aXhb4o0jd7pgBE6+FrLS+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAFO0VNUHHQUrBrogNfijk8HGB3APZQstLKxKGLUBjzIhtBAgNC/eUt03+3fT/JXTcfwMFRZHtqxSoARWikzfSbjTXDOYk9sZx+7hCdo8EQVcdf9shqGbV8rOigtX5Zsft8ulnF/RyXOttvkN5PXshlTH6PN7iaYkf7HK+IMuV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y4GGpEo4; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y4GGpEo4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791120377; x=1822656377;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MPs94zrn0NonwLqgoHkP0aXhb4o0jd7pgBE6+FrLS+8=;
  b=Y4GGpEo4jlDrW8KD2pDlHN5SiVMkShXTHdW5yOjC2t5/UNPHOL4cmIx7
   v2b1ZSQ85MRQxFmqrl/EUroK843EIJ58pZTDm9uOjHy8VUAd38tKaF7QR
   K6m6uG8IL5B7vjgDAplO347KptKihvbHG93t3/uLRUnog8E9k6BvFzfBK
   7+R6vpfcjI/dpfJnrW/fpe53QRjemAIZPeWm0YAQNqYJ7bKMrYre7K335
   bVkCET6g+RAxRy9LduhN1O0pwE6k/XoDJmCNdo+YEZu+ypwWc+x/QlEnF
   uJlCbNHOXXA1ZISvjl71CMaoFbegrC7T/GFTXhzkb8NsKpq972XarRAjc
   A==;
X-CSE-ConnectionGUID: XwadjQK3RdydbeESlqEaqQ==
X-CSE-MsgGUID: DHTjfO+2SeyH0pi9zdQAoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11925"; a="102328699"
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="102328699"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2026 06:26:16 -0700
X-CSE-ConnectionGUID: 1Duztf1ZS56MrivLauUhjA==
X-CSE-MsgGUID: E18wNdKdT6ygGFixACRX7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,139,1787036400"; 
   d="scan'208";a="304569129"
Received: from weis0041.iil.intel.com ([10.12.217.187])
  by fmviesa001.fm.intel.com with ESMTP; 04 Oct 2026 06:26:14 -0700
From: Ilan Peer <ilan.peer@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH v2 06/11] wifi: mac80211: accept NAN beacons only when IC is enabled
Date: Mon,  5 Oct 2026 10:40:31 +0300
Message-ID: <20261005074037.3506633-7-ilan.peer@intel.com>
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

Accept NAN beacons in the Rx path only when Instant Communication
(IC) is enabled in the NAN configuration.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 net/mac80211/rx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5e26be8e27d8..eb1578b2d6d7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4660,7 +4660,8 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 		 * Accept only frames that are addressed to the NAN cluster
 		 * (based on the Cluster ID). From these frames, accept only
 		 *  - public action frames,
-		 *  - authentication frames to the local address, and
+		 *  - authentication frames to the local address,
+		 *  - NAN beacons, when Instant Communication is enabled, and
 		 *  - robust management frames except disassoc.
 		 */
 		if (!ether_addr_equal(sdata->u.nan.conf.cluster_id, hdr->addr3))
@@ -4670,6 +4671,9 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 		if (ieee80211_is_auth(hdr->frame_control) &&
 		    ether_addr_equal(sdata->vif.addr, hdr->addr1))
 			return true;
+		if (ieee80211_is_nan_beacon((struct ieee80211_mgmt *)hdr,
+					    skb->len))
+			return sdata->u.nan.conf.instant_comm;
 		if (!ieee80211_is_disassoc(hdr->frame_control) &&
 		    ieee80211_is_robust_mgmt_frame(skb))
 			return true;
-- 
2.55.0

