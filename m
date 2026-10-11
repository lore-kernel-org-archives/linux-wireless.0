Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281DC42C4FA
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 11:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791716732; cv=none; b=WKtZMVcU70eJN/z5NG2n8yeQD1SJxK2fY+WZkrXNinJ9WOGTb7fDU5mavtXwtjyAykUl4jeGp35vvxlRbe5DU3X0Q+fA2yv/a4rGaCjgYDhro2PzJjx4s0q01b8CubpQMOLIWWUB7qJYpbkTwuwbLPku2Nq7EQMxg4QnkFfUZDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791716732; c=relaxed/simple;
	bh=B/P7Zz5qy89vnavqDGzW4Zyqk8e52XSgezXrgwOCLuA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z8JEdPe/saRpnhd902Ol9pJlx2RqMy3eUAgzkN2dgF9XmlBAaEv9aqRDXpknmE2tfrT9y2mgZ0J8I3u068pPLpgWhlww8DtCqUJVsa9uvUdbYMuGL+Ho/K01IFKaUdcXhxYvNEvJJgVo3KXXFME1SUU/T0xUwdg+8JI4L/peSzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KRYPd3sN; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KRYPd3sN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791716732; x=1823252732;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B/P7Zz5qy89vnavqDGzW4Zyqk8e52XSgezXrgwOCLuA=;
  b=KRYPd3sNirOXKSfOjtLY74b3dZlIUnAjrw9k53CWBm/g3jDHegaJgP3B
   n2VpplN5I6xbZyEtFO/Uzz+oexId/v2iWO8KaS69qs99rNIYFGTrMNGlf
   ePCkxB1O2s9TS2RYRBrmkKY1tKf6PF1Yxbd4up/uyyYjs5aw+NVCP4Isn
   Egr07fRZ6pmw39z5geDkqN5MfH1EC6SU52BZ5WeV/exCxKAKHVGPc3eEa
   yKBHOjWogYS4bNTLpjKNy9Q8uOF7mbBWTndLCrEt367zNHVCyG2Pmjwr6
   lempngk1uVAJ4MgYHZ6nWAiqtdGDF4Gj1fR4NUm/AeDyUVP+0c0Rhvivo
   w==;
X-CSE-ConnectionGUID: on+pyQxgQd6F9wSJiH94QA==
X-CSE-MsgGUID: K4D0KftIQwa8Vy3u0zYwlw==
X-IronPort-AV: E=McAfee;i="6800,10657,11931"; a="454181"
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="454181"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:31 -0700
X-CSE-ConnectionGUID: 4bft7+tXQZm8YHu8KlR4Mg==
X-CSE-MsgGUID: 13bzatAVSu6JxxcNeDUnKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,151,1787036400"; 
   d="scan'208";a="651008"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2026 04:05:29 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next 08/13] wifi: iwlwifi: mld: avoid const in iwl_mld_chan_load_update_iter()
Date: Sun, 11 Oct 2026 14:07:09 +0300
Message-Id: <20261011140453.ccd4dbfffb5f.Id15631e4372d9495282634f89bd73e7f526ce2ce@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261011110714.716840-1-miriam.rachel.korenblit@intel.com>
References: <20261011110714.716840-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The phy pointer here isn't really const, and if it were we'd
need container_of_const() (which can do both), but as it's
just non-const anyway drop the const.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/mlo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mlo.c b/drivers/net/wireless/intel/iwlwifi/mld/mlo.c
index a2f8a6957535..34273d4731ec 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mlo.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mlo.c
@@ -1076,9 +1076,9 @@ static void iwl_mld_chan_load_update_iter(void *_data, u8 *mac,
 					  struct ieee80211_vif *vif)
 {
 	struct iwl_mld_chan_load_data *data = _data;
-	const struct iwl_mld_phy *phy = data->phy;
+	struct iwl_mld_phy *phy = data->phy;
 	struct ieee80211_chanctx_conf *chanctx =
-		container_of((const void *)phy, struct ieee80211_chanctx_conf,
+		container_of((void *)phy, struct ieee80211_chanctx_conf,
 			     drv_priv);
 	struct iwl_mld *mld = iwl_mld_vif_from_mac80211(vif)->mld;
 	u32 new_chan_load = phy->avg_channel_load_not_by_us;
-- 
2.34.1

