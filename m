Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F273C1F;
	Mon, 19 Oct 2026 01:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792373400; cv=none; b=VlxIYI32344GNDhd2RkQWp6p0YZVgFEg1uHcHXyqVteKif+wFek4c+b+6wqrewaFV85WXOMYOY6TGtuuNl4Sbiz+JByqAKfMuzPD6zfIazh5tV4wZdlXnHlZU+0RxC1x8a+EdXNfoHRJd4HFyRc5hQewv2kPjQC6SxmJv+ndRuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792373400; c=relaxed/simple;
	bh=hGRjRg6f/p3fRdYlCiCyQPMahjskxPW83H+HXKfD6/8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ug+Xa6G7BLF/l0cBeHc0qMo87V7PfbgPXKg2XZKGjaODf1DJ5x15fsMwoE8PmLbhME9lGmN1ZhXPLna2uPzSgtKWczAFiYk4dsjj/EyIVQqaE6+MCa1jXAyVeszkbzXxwdQ4iMi2BSK8e0QD6rqLkMKF0++tey7cfK4PwqSEND0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=K6HuEcr2; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="K6HuEcr2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=DG
	GT3zreU9iHKS1t8R0HuXBRygSbLCU1j5Aida0NaO8=; b=K6HuEcr2nE71sWUDca
	Em6qhaY0NBVSXZ4rSbkt2xZ6Z8Uwpatg3lIyTxQn0Kz45ny0wVreLvV45EN02B3b
	7QV//NDhwickVPpc2uKBj0n9X3dGsDuwaLmBqr+dopsp9TqajtxcXH1qYAonfosq
	rEOf99mfWEhYvF5pcimhv4T4I=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wD3X+OJctVqNKdTBA--.46590S2;
	Mon, 19 Oct 2026 09:29:46 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Sara Sharon <sara.sharon@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH] wifi: iwlwifi: mvm: clear vif mapping on add failure
Date: Mon, 19 Oct 2026 09:29:41 +0800
Message-Id: <20261019012941.1486770-1-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3X+OJctVqNKdTBA--.46590S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZFykZFW7JFWfur18XFyxKrg_yoW5GF4DpF
	4UG3yqgrn8ta1kXay8Gan5Cr95Xa12k393CFy5Cw45ZF1vqF1Svw409Fy3A3sYkrWUJFWa
	yr1qya15WF1rK3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0p_9a9rUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7wrOCWrVcoojBwAA3B

Both legacy and MLD add_interface paths publish the vif in vif_id_to_mac
before operations which can fail. mac80211 does not call
remove_interface after a failed add, leaving a stale pointer which can
later be dereferenced.

Clear the mapping on every failure after publication.

Fixes: 698478c49294 ("iwlwifi: mvm: add an option to dereference vif by id")
Fixes: cb145863e7ab ("wifi: iwlwifi: mvm: add link to firmware earlier")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c     | 6 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c | 4 +++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 5bd246e37943..83b1e355ec35 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1748,7 +1748,7 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 
 	ret = iwl_mvm_mac_ctxt_add(mvm, vif);
 	if (ret)
-		goto out_unlock;
+		goto out_clear_vif;
 
 	ret = iwl_mvm_power_update_mac(mvm);
 	if (ret)
@@ -1792,12 +1792,16 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 	if (!ret && (vif->type == NL80211_IFTYPE_AP ||
 		     vif->type == NL80211_IFTYPE_ADHOC))
 		ret = iwl_mvm_alloc_bcast_mcast_sta(mvm, vif);
+	if (ret)
+		goto out_clear_vif;
 
 	goto out_unlock;
 
  out_remove_mac:
 	mvmvif->deflink.phy_ctxt = NULL;
 	iwl_mvm_mac_ctxt_remove(mvm, vif);
+ out_clear_vif:
+	RCU_INIT_POINTER(mvm->vif_id_to_mac[mvmvif->id], NULL);
  out_unlock:
 	mutex_unlock(&mvm->mutex);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
index 6ea9a7c8da0c..314794b8a26f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
@@ -46,7 +46,7 @@ static int iwl_mvm_mld_mac_add_interface(struct ieee80211_hw *hw,
 
 	ret = iwl_mvm_mld_mac_ctxt_add(mvm, vif);
 	if (ret)
-		return ret;
+		goto out_clear_vif;
 
 	/* beacon filtering */
 	ret = iwl_mvm_disable_beacon_filter(mvm, vif);
@@ -106,6 +106,8 @@ static int iwl_mvm_mld_mac_add_interface(struct ieee80211_hw *hw,
  out_remove_mac:
 	mvmvif->link[0] = NULL;
 	iwl_mvm_mld_mac_ctxt_remove(mvm, vif);
+ out_clear_vif:
+	RCU_INIT_POINTER(mvm->vif_id_to_mac[mvmvif->id], NULL);
 	return ret;
 }
 
-- 
2.34.1

