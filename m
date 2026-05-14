Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F2239E9A0
	for <linux-wireless@vger.kernel.org>; Thu, 14 May 2026 19:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778787892; cv=none; b=mZPFrOfoqbeQ+Mpqv9rJuY8TbOwFGrknXJZPrTw//ZufM0rgF0qnUb0bHomtnotXWwQV6ioenHF0TSbqRhsKNLr5dp+sbjpbz2Snstyuq3tfTKdLfO6vN7c9kxGkPwxJa6S9GmEVDmxipSFNRY5XOEVZILU/3dL/tLU8RWsCapU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778787892; c=relaxed/simple;
	bh=CET4Qgc/De/+tevN55TNyZDMwhLlRkFzRBCdKp0x5GA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O+Dmmpxl/fjut93AvNd4qfhvUUWV2WEYfompvMZiX4uMo/HVKIC/mggQgHr3g0nddkiRZtd6XYNfnr15F5xjq+KGohLSVlDEz2xXqztMhdJB8dqIYC1TMlR/ujIptDJf8rUGpoGD3uH5IlvZVco1Qp5FLOc5YI8XYRAlMZqvDXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JU7UTKQn; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JU7UTKQn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778787892; x=1810323892;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CET4Qgc/De/+tevN55TNyZDMwhLlRkFzRBCdKp0x5GA=;
  b=JU7UTKQn/ck5ydjgI5unVo0HJxHTAl0721de9t0A7c0L1BwLmd2XiRZG
   tC+Xn6NTsTgIieU9DBffWeHrwnwPia2GinS7iuj/TJyPFb+UjdcEOeq+T
   +oVLUpEdJ55GoQVxcw2KVg/gXdQ4gLXYBjO6SkRr2J2mYtA54yHRWmsxK
   YUja1op+3p1S4c66x4JlDFsbXgQNzAQQDvWdzJQ56cjXzN4KRKQINe8oV
   gLTVTVuSpiFnYod3Wmpo7k0pzC9iz+AMq944uWrg4r8em+LvTIHxVwLZ3
   LhdYKdxxSZXkcuwq3Jnh0HGKkJi7+NTsY2Jf58dqDS78hb7oBd5Dy6RDC
   Q==;
X-CSE-ConnectionGUID: oP3hn9QfRsuIhRzlBhZbSQ==
X-CSE-MsgGUID: tL8I4h/VQv6/jaOmAldSmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11786"; a="83352573"
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="83352573"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 12:44:51 -0700
X-CSE-ConnectionGUID: sl+AAl+YTE+X98fetFpp1Q==
X-CSE-MsgGUID: 41YvFrZpTIC9bugWZgdSFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="237616240"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 12:44:50 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>
Subject: [PATCH iwlwifi-next 01/15] wifi: iwlwifi: mld: nan: add availability attribute to schedule config
Date: Thu, 14 May 2026 22:44:20 +0300
Message-Id: <20260514224230.97809376508e.Ie7f00f97992016c6bb2f4a5c9fc201ac58eed8ce@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260514194434.401241-1-miriam.rachel.korenblit@intel.com>
References: <20260514194434.401241-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Avraham Stern <avraham.stern@intel.com>

Add the availability attribute to the schedule config command. The
firmware needs to add this attribute to schedule update frames
(e.g. when ULW changed or the local schedule changed).

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/nan.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/nan.c b/drivers/net/wireless/intel/iwlwifi/mld/nan.c
index 530ba263c5f0..d13b2374b642 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/nan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/nan.c
@@ -693,6 +693,14 @@ void iwl_mld_nan_vif_cfg_changed(struct iwl_mld *mld,
 		break;
 	case 2:
 		cmd_size = sizeof(struct iwl_nan_schedule_cmd);
+
+		if (sched_cfg->avail_blob_len &&
+		    !WARN_ON(sched_cfg->avail_blob_len >
+			     sizeof(cmd.avail_attr.attr))) {
+			cmd.avail_attr.attr_len = sched_cfg->avail_blob_len;
+			memcpy(cmd.avail_attr.attr, sched_cfg->avail_blob,
+			       sched_cfg->avail_blob_len);
+		}
 		break;
 	default:
 		IWL_ERR(mld, "NAN: unsupported NAN schedule cmd version %d\n",
@@ -727,6 +735,15 @@ void iwl_mld_nan_vif_cfg_changed(struct iwl_mld *mld,
 	BUILD_BUG_ON(ARRAY_SIZE(sched_cfg->channels) !=
 		     ARRAY_SIZE(cmd.channels));
 
+	/*
+	 * mac80211 removes unused channels before adding new ones, so it may
+	 * update an empty schedule with an availability attribute because it
+	 * is going to add channels later. Since the firmware does not expect
+	 * an availability attribute without channels, ignore it in that case.
+	 */
+	if (empty_schedule)
+		cmd.avail_attr.attr_len = 0;
+
 	/* find links we can keep (same chanctx/PHY) */
 	for (i = 0; i < ARRAY_SIZE(sched_cfg->channels); i++) {
 		struct ieee80211_chanctx_conf *chanctx;
-- 
2.34.1

