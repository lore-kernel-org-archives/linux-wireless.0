Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527462D2385
	for <linux-wireless@vger.kernel.org>; Wed,  6 May 2026 03:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778039092; cv=none; b=hoZEDOKDouLWLHwHti5OHPAXsMQt7uwMFKXRWL6W5RJ/8A2ROy9heGne/IjWaPk7W+gObKdo3oFIFq1PGLRQHpTkiir5zcdkYE9Pt9Egb9m9eg7IFFUhA+HaLGO91+8zHIvURrDrBGfVo/g+T+BTxNPhRpuyJfGPaljB4szflLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778039092; c=relaxed/simple;
	bh=mWCjFnEtTRIJ7E6VkXi8bdx5HddtP1ejCNTrJqH02W8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hf4I45FCPsTnjwMEQ4dMiiTgKN6lFLgw7sAY4OJdheBqiOoMyguxHa70x50vZdUwJIe8guFGQ2H+ne0b5qb7wqWGjWFJhZJjta3IRSjtuwN+GivQFeQ97iafZP8cwe+Pr/VCUIFU9f0VYLXIHDcf7dn9+HotmKaE73fAI0ijkL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kVLbO98L; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kVLbO98L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778039092; x=1809575092;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mWCjFnEtTRIJ7E6VkXi8bdx5HddtP1ejCNTrJqH02W8=;
  b=kVLbO98LARhYLq6kvbTR6rYduOJOt6UGsKO99+qWtmPVrLUIIrkVImf4
   q/dwGAvy5x/f7B6GoOTlJCwIvoLN6oLj600aTcDfHGqf5Cj+3spJApGHw
   H5N+cSvd43O3psbgKf65e6vo3bAZcp4mulEIUwZDUf9CoCF4yMLvdfju0
   J5xprUhtEHZX89BBolNZA9mrdcS4iggt7q/QMCYjUe6Ef+4t99uCatoS1
   lCvzKtRfYMbWjhPEo3RCL11lZuR/9dOcHAAJUzbBbMjTVziA9h38lLQWY
   fZAUlg9xG9zZa/r6rgagsPEL8M+1H79499uWGPo/RWH6G+6W7O82MyXVv
   g==;
X-CSE-ConnectionGUID: sZ4Nr1PySJ+QcIEKbZwdcA==
X-CSE-MsgGUID: 6rZK4p6FS6qMLPuV9vr/7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11777"; a="82791276"
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="82791276"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 20:44:49 -0700
X-CSE-ConnectionGUID: RkddIMR/T8CBlQD26UTSXw==
X-CSE-MsgGUID: bOWR2TugSuiQQhDtxIaJRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="237777747"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 20:44:48 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH v2 wireless-next 02/14] wifi: mac80211_hwsim: select NAN TX channel based on current TSF
Date: Wed,  6 May 2026 06:44:21 +0300
Message-Id: <20260506064301.c235b5a78b98.I5ec4076a8a9445233dc414c6ecaa39f32f1e9595@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260506034433.3328362-1-miriam.rachel.korenblit@intel.com>
References: <20260506034433.3328362-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

Move the TX channel selection into the NAN specific file and select the
channel based on the current slot.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../net/wireless/virtual/mac80211_hwsim_main.c |  6 +-----
 .../net/wireless/virtual/mac80211_hwsim_nan.c  | 18 ++++++++++++++++++
 .../net/wireless/virtual/mac80211_hwsim_nan.h  |  3 +++
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index 6740504b30e6..f0f6cb7fa894 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -2084,11 +2084,7 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 	hdr = (void *)skb->data;
 
 	if (vif && vif->type == NL80211_IFTYPE_NAN && !data->tmp_chan) {
-		/* For NAN Device simulation purposes, assume that NAN is always
-		 * on channel 6 or channel 149, unless a ROC is in progress (for
-		 * USD use cases).
-		 */
-		channel = data->nan.channel;
+		channel = mac80211_hwsim_nan_get_tx_channel(hw);
 
 		if (WARN_ON(!channel)) {
 			ieee80211_free_txskb(hw, skb);
diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_nan.c b/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
index 22805c3723e6..10bbac9a4b55 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_nan.c
@@ -310,3 +310,21 @@ bool mac80211_hwsim_nan_txq_transmitting(struct ieee80211_hw *hw,
 
 	return true;
 }
+
+struct ieee80211_channel *
+mac80211_hwsim_nan_get_tx_channel(struct ieee80211_hw *hw)
+{
+	struct mac80211_hwsim_data *data = hw->priv;
+	u64 tsf = mac80211_hwsim_get_tsf(data->hw, data->nan.device_vif);
+	u8 slot = hwsim_nan_slot_from_tsf(tsf);
+
+	if (slot == SLOT_24GHZ_DW)
+		return ieee80211_get_channel(hw->wiphy, 2437);
+
+	if (slot == SLOT_5GHZ_DW &&
+	    data->nan.bands & BIT(NL80211_BAND_5GHZ))
+		return ieee80211_get_channel(hw->wiphy, 5745);
+
+	/* drop frame and warn, NAN_CHAN_SWITCH_TIME_US should avoid races */
+	return NULL;
+}
diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_nan.h b/drivers/net/wireless/virtual/mac80211_hwsim_nan.h
index 6a0780797273..796cc17d194e 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_nan.h
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_nan.h
@@ -39,4 +39,7 @@ int mac80211_hwsim_nan_change_config(struct ieee80211_hw *hw,
 bool mac80211_hwsim_nan_txq_transmitting(struct ieee80211_hw *hw,
 					 struct ieee80211_txq *txq);
 
+struct ieee80211_channel *
+mac80211_hwsim_nan_get_tx_channel(struct ieee80211_hw *hw);
+
 #endif /* __MAC80211_HWSIM_NAN_H */
-- 
2.34.1

