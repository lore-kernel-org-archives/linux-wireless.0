Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBA247A0B8
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 19:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784142365; cv=none; b=oYrSjW3QfQ26DTapqJ3RJHujB47GytidZNHUkm+lmQ+5ci+wrO8ztgZ/a1drvg0gbKmeUocWcESA8qI8G5kuxNfiJcNitD7SnAllr9mUjOm7doNH5LK+sEW3l5DJ9bKcs1TTUvP/1Zqox6OjwsQ3A+50wZi/M8v/yAyQAajD8dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784142365; c=relaxed/simple;
	bh=rBPAzR0nw9+0tnWw1womk16kizEZfdeliYgwPgjoSdM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XQhRkck8H4BTaAGw4La3hxvHpNpu8dWaJUnHho3gUxs+j6NwBWana2RlN296sTYsgLWKbx+tg9dw/PJ0Q8AauE5scGAcul8+uGRiw/I5YpJuUjxJhh3WVyLhyGjDF1oBJPgK79B5156Ubk2S14HROOM5hVoq2ccDCejb/SdxctY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cVtZOWeP; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cVtZOWeP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784142354; x=1815678354;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rBPAzR0nw9+0tnWw1womk16kizEZfdeliYgwPgjoSdM=;
  b=cVtZOWePhzpMAKOmyOWzsUWV975k3U8wSAs7wy9GzoJu/o/mkUwd8jAG
   fYF5s8X9JFGxNkFw1lRNpRy5cBWjoiVKdqFKWKhaXqWQ8mA3JCKJP2tKW
   kdbPLSb8UeImOHwKkoI/bU2EI9bUQbeKmgvjD2kfvDZcE6+GTz0kt0kGS
   xllyrdTPH/SaKtB8l08n8gNEFjeA6xbc8oZJdSeovEVMY+d/28dg9KLTh
   9O3NmJPK9Zea5xXm+1JouFV3/dVrP+Z6yFmYeEBmkoQVEQokA1K9F+MR6
   UM24mlxAdwypXYsfhEWLuODU+nMJT3ZL+iJDTk55kQgxAsbSL+b28mJbU
   A==;
X-CSE-ConnectionGUID: iQuIJA+2Tou+hb1bqzUGwQ==
X-CSE-MsgGUID: gp5uiHW+RVmLZ2xmV5vqhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="87340747"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="87340747"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:05:14 -0700
X-CSE-ConnectionGUID: hUd38K1jTaKsS1bV/jrAcQ==
X-CSE-MsgGUID: L0zfEHRTSByd8zNDV5L0tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="251852060"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:05:13 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>
Subject: [PATCH iwlwifi-next 15/15] wifi: iwlwifi: mei: pass correct argument to function
Date: Wed, 15 Jul 2026 22:04:31 +0300
Message-Id: <20260715220243.24cea60c6428.I42301010c31487b1458faa967b22c8320b0cfd23@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715190431.327910-1-miriam.rachel.korenblit@intel.com>
References: <20260715190431.327910-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Avraham Stern <avraham.stern@intel.com>

The first argument to iwl_mei_write_cyclic_buf() should be the cldev
but the q_head pointer is passed instead. Fix it.

Fixes: 652291601459 ("iwlwifi: mei: don't rely on the size from the shared area")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mei/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mei/main.c b/drivers/net/wireless/intel/iwlwifi/mei/main.c
index c462c3b22ec1..ce92e26c42d7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mei/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/mei/main.c
@@ -458,7 +458,7 @@ static int iwl_mei_send_sap_msg_payload(struct mei_cl_device *cldev,
 	notif_q = &dir->q_ctrl_blk[SAP_QUEUE_IDX_NOTIF];
 	q_head = mei->shared_mem.q_head[SAP_DIRECTION_HOST_TO_ME][SAP_QUEUE_IDX_NOTIF];
 	q_sz = mei->shared_mem.q_size[SAP_DIRECTION_HOST_TO_ME][SAP_QUEUE_IDX_NOTIF];
-	ret = iwl_mei_write_cyclic_buf(q_head, notif_q, q_head, hdr, q_sz);
+	ret = iwl_mei_write_cyclic_buf(cldev, notif_q, q_head, hdr, q_sz);
 
 	if (ret < 0)
 		return ret;
-- 
2.34.1

