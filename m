Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F39351DDEF
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790077181; cv=none; b=HkdY7OjXRtt4ChN17rojK6dZaImA6vm4ysoTDhePHkjZ1Kfe5luDiZ5QsGLBnIr3Gw8GUCxQCJkVF2dHACruxvB3As0MhoX7PR5R6adjjTqCFDgx2sv8QEEXbowXyoPh+XW39B+Xta1vCYIeZybis5SkEBNBFk5xyTInHWZ6hFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790077181; c=relaxed/simple;
	bh=ZoYAsd3PyUwzaf6wlrXAinvcZfiMHEFQXY7FGkhbpRE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=I/KyyjmMqkTQC17ZZuUrA7Sn4Ibo88MHRQR0eJTLPQsnnuP5R6GteVM4CT9t63ZpXMeAWoLO8nn/vuJWSBOwKWQy5Zn8xtnvD5nsYjacO61wb/ed8bts1cPWaccegKVe9vQdInTp4ZN9WGDfNo9ThZR8q2akOSDOH2NABnWCPiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BRwBuD+0; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BRwBuD+0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790077175; x=1821613175;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZoYAsd3PyUwzaf6wlrXAinvcZfiMHEFQXY7FGkhbpRE=;
  b=BRwBuD+0P2K2i2f/imBJLNhy3hXEgzAy3cNxKND5r6q6mTQ/tTQjTyKR
   F8nUWPahEtyrBPxpV724w06AJb33kD2CNlbcTgmTqTFarW4jgXnYQWgGk
   emjUL4RU4GxvD/i8VflKnpCmg++oShT8fS3YsvI4RGDr1494BfNbJ4yNt
   /u2n6giZXgdNIsQJXjOL9oklSSsTDovnSjJcq7nXBhwU4OzXpyChyjxXV
   VwJR19h1yJCrU1UhliLsb51qXuVLCJv/42TyfBb0dwa/KqEj9mWgyI+jH
   eyAFq4cgWTSeMAUfoIT7OTiKC6Yb7uOlgR7+NlpSyG1aDr8jes6KO2s3+
   w==;
X-CSE-ConnectionGUID: PMhGHihQQPaOecTPP+TJCA==
X-CSE-MsgGUID: 2bDDptqhSM2C/xjUIIq4KA==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="90693380"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="90693380"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:39:31 -0700
X-CSE-ConnectionGUID: s6OMr7r7SeiEPlHhQWt5WA==
X-CSE-MsgGUID: p3wzL50sSyad+lEhriRspg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="271653914"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:39:30 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: mac80211: Restrict probe request rates for minimal content
Date: Tue, 22 Sep 2026 14:41:29 +0300
Message-Id: <20260922143146.13a6fab60516.I3ebb1fa5d41622b1a0ddf9d008328fc19ad980a1@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Ilan Peer <ilan.peer@intel.com>

When IEEE80211_PROBE_FLAG_MIN_CONTENT is set, restrict the probe
request supported rates per Draft P802.11bi D5.0 specification:

- 2 GHz: only include 1, 2, 5.5, 6, 11, 12, 24 Mb/s
- 5/6 GHz: only include 6, 12, 24 Mb/s

Also skip the Extended Supported Rates element for minimal
content probes.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Assisted-by: GitHub-Copilot:claude-opus-4-6
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/mac80211/util.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index a96078a6bfa2..1b930fada529 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1283,6 +1283,29 @@ static int ieee80211_put_preq_ies_band(struct sk_buff *skb,
 	if (band == NL80211_BAND_S1GHZ)
 		return ieee80211_put_s1g_cap(skb, &sband->s1g_cap);
 
+	/*
+	 * For EPP minimal content probes, restrict supported rates:
+	 * - 2 GHz: only 1, 2, 5.5, 6, 11, 12, 24 Mb/s
+	 * - 5/6 GHz: only 6, 12, 24 Mb/s
+	 * Do not include Extended Supported Rates element.
+	 */
+	if (flags & IEEE80211_PROBE_FLAG_MIN_CONTENT) {
+		for (i = 0; i < sband->n_bitrates; i++) {
+			u16 rate = sband->bitrates[i].bitrate;
+
+			if (band == NL80211_BAND_2GHZ) {
+				if (rate != 10 && rate != 20 &&
+				    rate != 55 && rate != 60 &&
+				    rate != 110 && rate != 120 &&
+				    rate != 240)
+					rate_mask &= ~BIT(i);
+			} else {
+				if (rate != 60 && rate != 120 && rate != 240)
+					rate_mask &= ~BIT(i);
+			}
+		}
+	}
+
 	err = ieee80211_put_srates_elem(skb, sband, 0,
 					~rate_mask, WLAN_EID_SUPP_RATES);
 	if (err)
-- 
2.34.1

