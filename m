Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266E6400966
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784141898; cv=none; b=utKUv+auC0IglSEsisLQ9RTupWqmiLEmoXvtH6fkUpApoUyrJPcT82sZTk/IDl7s++e/I3Eqa9TUKBo1v8dNifyTGu6SdSOm9WvXBE/9GsR6s46oaAgvtkVFVbAakexVxEKcZyiJZzq6mHdeIwFps7LUh/DQZtC6GkUA+bnuzwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784141898; c=relaxed/simple;
	bh=OT7mQIyTyV7jDGnFqf4O2NX2Ezi6jJgmuiBEoHrm4i4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e0wK2I5IpzvE3JFQARoexZVkxsEISLbTifqD6Agl3XLiF8zsDczHHsQ/7SHMoJPy9TdRyNASQHyppg/ZBv29GWUnlmu/XuaYTxKFG5twbW2i2hO9mZl3HeM1sWrtKj6scCPIZm0H38z1PIB+0eAnFoUZFzFgsEhMhnR2llloev8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RsK4P25q; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RsK4P25q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784141892; x=1815677892;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OT7mQIyTyV7jDGnFqf4O2NX2Ezi6jJgmuiBEoHrm4i4=;
  b=RsK4P25qKQTR2RB8g6ITZn9Wx549mwA8bZOlqswxTlLgQYj22NpuAeoS
   aasqxLR7R8eETfWXH3uCJraQM4ohCUHZOBqe0u+6YmluxE14+f8zuKWyC
   8FcYJ/x6CmddbuiM1UzWA/RuWm+JCsAt2vtkW6uARdfEYpiJabMwC09fZ
   E6dZ82ELtoBCqQr3ixODbOdCrOU8DIdHO4bqY6vrtbQO7LYQVAorMqi2d
   De7g3zYu5LvSsv5MlPIzeI+cEeX6R/MRnRcVF/yvW/cjc2VsJ5emnb+xM
   bK8riFnGr2pls0bATgvs+7atJIRcvrF+0N0lmiBUpgyc6QRApbwQs3w55
   Q==;
X-CSE-ConnectionGUID: 3E5bUSr8T925/4XDktjaCw==
X-CSE-MsgGUID: GCZDn8rARBGyW1akAtQfGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="96160924"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="96160924"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:57 -0700
X-CSE-ConnectionGUID: Oo+rJeXtSsyTVJQZ2UbVOg==
X-CSE-MsgGUID: PGO7wsRWQEmhUqGTainSAQ==
X-ExtLoop1: 1
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:57:56 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>
Subject: [PATCH iwlwifi-fixes 13/15] wifi: iwlwifi: mvm: copy the correct TK length for ranging
Date: Wed, 15 Jul 2026 21:57:13 +0300
Message-Id: <20260715215523.e339570086bd.Iafff5aaf0e25f7d29e06f0ef456107c4062bbc7d@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715185715.321797-1-miriam.rachel.korenblit@intel.com>
References: <20260715185715.321797-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Avraham Stern <avraham.stern@intel.com>

When setting the TK for ranging with an associated peer, 32 bytes of
TK are copied from the vif key without verifying the actual key length
which may be only 16 bytes if CCMP-128 is used. Fix it by setting the
copy length according to the key cipher.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../intel/iwlwifi/mvm/ftm-initiator.c         | 55 +++++++++++++------
 1 file changed, 38 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
index 3a14ca5e512a..8d7f60dcd027 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -646,7 +646,8 @@ static void iter(struct ieee80211_hw *hw,
 	WARN_ON(*target->cipher == IWL_LOCATION_CIPHER_INVALID);
 }
 
-static void
+/* The tk buffer is assumed to be exactly TK_11AZ_LEN bytes */
+static int
 iwl_mvm_ftm_set_secured_ranging(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				u8 *bssid, u8 *cipher, u8 *hltk, u8 *tk,
 				u8 *rx_pn, u8 *tx_pn, __le32 *flags)
@@ -656,12 +657,12 @@ iwl_mvm_ftm_set_secured_ranging(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
 	if (mvmvif->ftm_unprotected)
-		return;
+		return 0;
 #endif
 
 	if (!(le32_to_cpu(*flags) & (IWL_INITIATOR_AP_FLAGS_NON_TB |
 		       IWL_INITIATOR_AP_FLAGS_TB)))
-		return;
+		return 0;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -679,14 +680,31 @@ iwl_mvm_ftm_set_secured_ranging(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		if (vif->cfg.assoc &&
 		    !memcmp(vif->bss_conf.bssid, bssid, ETH_ALEN)) {
 			struct iwl_mvm_ftm_iter_data target;
+			u32 key_len;
 
 			target.bssid = bssid;
 			target.cipher = cipher;
 			target.tk = NULL;
 			ieee80211_iter_keys(mvm->hw, vif, iter, &target);
 
-			if (!WARN_ON(!target.tk))
-				memcpy(tk, target.tk, TK_11AZ_LEN);
+			if (WARN_ON(!target.tk))
+				return -EINVAL;
+
+			switch (*target.cipher) {
+			case IWL_LOCATION_CIPHER_CCMP_128:
+			case IWL_LOCATION_CIPHER_GCMP_128:
+				key_len = WLAN_KEY_LEN_CCMP;
+				break;
+			case IWL_LOCATION_CIPHER_GCMP_256:
+				key_len = WLAN_KEY_LEN_GCMP_256;
+				break;
+			default:
+				WARN_ON(1);
+				return -EINVAL;
+			}
+
+			memset(tk, 0, TK_11AZ_LEN);
+			memcpy(tk, target.tk, key_len);
 		} else {
 			memcpy(tk, entry->tk, sizeof(entry->tk));
 		}
@@ -695,8 +713,10 @@ iwl_mvm_ftm_set_secured_ranging(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		memcpy(tx_pn, entry->tx_pn, sizeof(entry->tx_pn));
 
 		FTM_SET_FLAG(SECURED);
-		return;
+		return 0;
 	}
+
+	return 0;
 }
 
 static int
@@ -708,12 +728,11 @@ iwl_mvm_ftm_put_target_v7(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (err)
 		return err;
 
-	iwl_mvm_ftm_set_secured_ranging(mvm, vif, target->bssid,
-					&target->cipher, target->hltk,
-					target->tk, target->rx_pn,
-					target->tx_pn,
-					&target->initiator_ap_flags);
-	return err;
+	return iwl_mvm_ftm_set_secured_ranging(mvm, vif, target->bssid,
+					      &target->cipher, target->hltk,
+					      target->tk, target->rx_pn,
+					      target->tx_pn,
+					      &target->initiator_ap_flags);
 }
 
 static int iwl_mvm_ftm_start_v11(struct iwl_mvm *mvm,
@@ -881,11 +900,13 @@ iwl_mvm_ftm_put_target_v10(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	iwl_mvm_ftm_set_target_flags(mvm, peer, &target->initiator_ap_flags);
 	iwl_mvm_ftm_set_sta(mvm, vif, peer, &target->sta_id,
 			    &target->initiator_ap_flags);
-	iwl_mvm_ftm_set_secured_ranging(mvm, vif, target->bssid,
-					&target->cipher, target->hltk,
-					target->tk, target->rx_pn,
-					target->tx_pn,
-					&target->initiator_ap_flags);
+	ret = iwl_mvm_ftm_set_secured_ranging(mvm, vif, target->bssid,
+					      &target->cipher, target->hltk,
+					      target->tk, target->rx_pn,
+					      target->tx_pn,
+					      &target->initiator_ap_flags);
+	if (ret)
+		return ret;
 
 	i2r_max_sts = IWL_MVM_FTM_I2R_MAX_STS > 1 ? 1 :
 		IWL_MVM_FTM_I2R_MAX_STS;
-- 
2.34.1

