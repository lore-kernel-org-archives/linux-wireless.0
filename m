Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89563E9C11;
	Fri, 11 Sep 2026 06:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789106973; cv=none; b=FZZD6wmAlgudP4WBQquF8L1TBG9ytFwZ5G5Klc4ZoxVRsHYubi+Ul+41TFxi27zsa+krk3WXoAPJ1NweKBjcoX0Ok77uggpU3uPJc72XEXlu60WTz0eEMJobEqGsOcpC144aJp0VCyZt6eRhL0fYTNbNv99N6OJQm6efAz6d0no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789106973; c=relaxed/simple;
	bh=7r9vyyBeoKi5W41cScRIoD8LjOdyYcqdhNQy+OaCCtk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kgRTnLiMqvSry3tdK/jGBWapt7yluCnv+fopDORR4TiuIYqPF5Io4NMr6xOB3y03Eu2GATK+R3fPnwgyqCz4O57zvTIMDvI7IFf9qRCFZIZSBso+wIJCqFkoIiKjfa9bA50zlge8My1fPa52n0YGSplrEsCuc2lQZkbs9kwzXBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=eSdoaNkB; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="eSdoaNkB"
Received: from seu.edu.cn (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4d62c4fb8;
	Fri, 11 Sep 2026 14:09:24 +0800 (GMT+08:00)
From: Slavin Liu <bolin.liu@seu.edu.cn>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bolin.liu@seu.edu.cn
Subject: [PATCH RFC net] wifi: iwlwifi: mvm: normalize failed wakeup status queries
Date: Fri, 11 Sep 2026 14:09:24 +0800
Message-Id: <20260911060924.94421-1-bolin.liu@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa08f15c91603a1kunmedca26e11c7361
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDTUsYVk5OHx9LT08fT0pMT1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSU
	hOQ0NVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=eSdoaNkBURwQhIGwng2xyo2RfP+vMBlW8//PHa0YnEja49npYE59jgCbWF51D1+ZMSYfRxjPfe7HEu8ljoFkimuV5n4ixaAr5a2IO6Fgn3HorBbS/pCbGX62Gc1rXVQc0rlK5vm0VZg9bwaJHZXHE1Rj39nlAyMekcnm0ElGm+4=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=AClg1+28IOkTpMcB9HvjR4Sph5IEAoXKIlYMLzhgybY=;
	h=date:mime-version:subject:message-id:from;

GET_STATUS may return ERR_PTR. Convert it to the NULL failure state
expected by the existing wakeup-query paths, preserving their mutex
release and cleanup instead of returning directly from the caller.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: 537b76d26cbb ("iwlwifi: mvm: use NULL instead of ERR_PTR when parsing wowlan status")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 6b11fa32ea5c..9bbf4185eab5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2747,6 +2747,8 @@ iwl_mvm_choose_query_wakeup_reasons(struct iwl_mvm *mvm,
 
 		d3_data->status = iwl_mvm_send_wowlan_get_status(mvm, sta_id);
 	}
+	if (IS_ERR(d3_data->status))
+		d3_data->status = NULL;
 
 	if (mvm->net_detect) {
 		iwl_mvm_query_netdetect_reasons(mvm, vif, d3_data);
