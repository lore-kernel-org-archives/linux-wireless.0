Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C6D4DEC0A
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 14:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557383; cv=none; b=QKBEIpUF+wIWjqTUb+vdzRdS+h7RTP0WMj3e5P6oBlQuWepCL0iJGkXEsu8Uw5R3rkUNkOfRvudEGBt6kRmdPD+e+qWXXqKun0l4EvmF+0Z59/J89ln0KGq82O4BGWhP2rgazCbRoCo8O7WjF5d4vIQTYDq7HnXQKrhxmT41ajc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557383; c=relaxed/simple;
	bh=S9GdiFcMCfIYskNt/7VBZM5zpgJGOx9+c9tHKqi1Y4k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GdgFWs8AYxAYNJS6yIlJ47dCe4/SbfKuTZodUe9LLod0jvsPgyW5/bQn2UaQUlfgLECLWdKwmtuZ/ej8V+U2ovzCOtE9i0O/dL576CYVGY9JNqLgRJagPMN/rAiUV7Q0jl7fVMbvz5Rd0mPdtNgJ5nOju3HsVFLSHgZHYanW6RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=iG2/SJm0; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="iG2/SJm0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=tNx2DI8K02BpBy/07nmtc53SjqfM1uMXOveflXapnC4=; t=1791557381; x=1792766981; 
	b=iG2/SJm0IjC/YSnDhmReaz1Wst3qDCqUu5M03OYzecL24OuIz8Vy0ttL13B2meyWB0gi+ohmrID
	0VURkC4Os6E8cyCcf3A9A0XzNcWcuA0Prus8sn8Fn3zzc1yRGFttGxWh9R/BBTQaHZ/0Z/u9SfDRs
	/Hhn8aWOhAmpwMj/Nf5pRjw7/GjKaepLBcYYzX8g5VQMLSMpA67dijbHGSJOM3Ha9yAshNJEK4rw1
	tObroIxko2CIGwsVADxwE0aTcX0i1nd/8r66UfwCQW7Y8EvOeZ04xDrrnf6QOMF4IP5oMDC2pX4h0
	+lgYpJ5Z16rGLXNFRQlsnfw57mS2nNu5+wjQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFBuk-0000000AkxE-3EAj;
	Fri, 09 Oct 2026 16:49:38 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH iwlwifi-next] wifi: iwlwifi: don't take RTNL for NVM/INIT ucode
Date: Fri,  9 Oct 2026 16:49:35 +0200
Message-ID: <20261009164935.54ff392e7e18.I1cbd2c4abea959f548d6609d42992410ade9bcec@changeid>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Recently RTNL was dropped from regulatory code, so it's
no longer needed in iwlwifi for regulatory. Remove it.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/mld.c | 4 ----
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 3 ---
 2 files changed, 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mld.c b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
index 6e991fb99ff3..75ec1e0120b3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mld.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
@@ -425,8 +425,6 @@ iwl_op_mode_mld_start(struct iwl_trans *trans, const struct iwl_rf_cfg *cfg,
 	/* Configure transport layer with the opmode specific params */
 	iwl_mld_configure_trans(op_mode);
 
-	/* needed for regulatory init */
-	rtnl_lock();
 	/* Needed for sending commands */
 	wiphy_lock(mld->wiphy);
 
@@ -448,7 +446,6 @@ iwl_op_mode_mld_start(struct iwl_trans *trans, const struct iwl_rf_cfg *cfg,
 		/* wiphy memory is about to be freed, we should cancel any pending work */
 		wiphy_work_cancel(mld->wiphy, &mld->async_handlers_wk);
 		wiphy_unlock(mld->wiphy);
-		rtnl_unlock();
 		goto err;
 	}
 
@@ -460,7 +457,6 @@ iwl_op_mode_mld_start(struct iwl_trans *trans, const struct iwl_rf_cfg *cfg,
 	iwl_mld_stop_fw(mld);
 
 	wiphy_unlock(mld->wiphy);
-	rtnl_unlock();
 
 	ret = iwl_mld_leds_init(mld);
 	if (ret)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 1dd27292af9b..59dce2a0f514 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -851,7 +851,6 @@ static int iwl_mvm_start_get_nvm(struct iwl_mvm *mvm)
 	}
 
 get_nvm_from_fw:
-	rtnl_lock();
 	wiphy_lock(mvm->hw->wiphy);
 	mutex_lock(&mvm->mutex);
 
@@ -859,7 +858,6 @@ static int iwl_mvm_start_get_nvm(struct iwl_mvm *mvm)
 	if (ret) {
 		mutex_unlock(&mvm->mutex);
 		wiphy_unlock(mvm->hw->wiphy);
-		rtnl_unlock();
 		return ret;
 	}
 
@@ -875,7 +873,6 @@ static int iwl_mvm_start_get_nvm(struct iwl_mvm *mvm)
 
 	mutex_unlock(&mvm->mutex);
 	wiphy_unlock(mvm->hw->wiphy);
-	rtnl_unlock();
 
 	if (ret)
 		IWL_ERR(mvm, "Failed to run INIT ucode: %d\n", ret);
-- 
2.56.0

