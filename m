Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E930449B0B
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 20:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790023183; cv=none; b=X16gY8cgcLOkXB1yZjcECxEuOo42SBDWL+Af/ZxZP26IzAAJy0TjvQlMQuQLeppgbjITgZXU3RJ6YR6j3L5J2obZrnf6P9er1LVFUp9J7/OaALLuPYxW9+W0gF1FCKh5gXzMwzVTEdACkXZXqVMXgZ9e8PUS0Gd1r0zo2Un1eso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790023183; c=relaxed/simple;
	bh=PlzUJSr+2vhdUbJzG+FdBPvFx2/PyX2tXR1hvEjIxpM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RKuyCBM7FuJ9uZEhn77NPm1UO7w+eDPSNJ1PdmMVk839QSNSipkCYE7uwxM/Qyjqf85iLlkc44kVLS9WL0iTBKZUKDYBJag16r10Ao6myODEMXLwQGrhocwIdW99+YWvH2/BcgfW+JvNqKBP5TGO8LM1gThOn259KUKDZT8suC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=abptyg4M; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="abptyg4M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790023181; x=1821559181;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PlzUJSr+2vhdUbJzG+FdBPvFx2/PyX2tXR1hvEjIxpM=;
  b=abptyg4MnW84Z7YL0jD32aJIlfibwd5BV56RZv3LTdIHXiV9+sP4aZ43
   aKG/MuXeHR2dWH49GDxBNveESVmX3HLA0uLhvukO6cHNsmDH8E6oO4LnJ
   VFih7aJvW2wGKkBVuMcMMj5g3fxj0EaMRIAorgBNHeNOi9AhQDihZips3
   4mxwwepzGdvuG0U044lTMc7LxdnCdL9SmU8tbD0H9deGxuc6Trpxs3B+R
   ihkhCDNZOZ2preFHNEYt9XhDNrS7nFMh5oCTt/xW6XmOu/AVWobD5qEhP
   QeJoC8usStOclj6Itm9tW0GsJJQxS0J67tG5dXUvMqAIej12/KOJ9P/OV
   g==;
X-CSE-ConnectionGUID: TEuXfgmqQa+AjLW4Q8n24g==
X-CSE-MsgGUID: W0n8n4/9QX6uNyVLlaPQUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="78128783"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="78128783"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:41 -0700
X-CSE-ConnectionGUID: PSsp3900QNKdhk3mbH56Dg==
X-CSE-MsgGUID: aYo05DhHSp2tQalhvBLmFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="300762023"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 13:39:40 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Shahar Tzarfati <shahar.tzarfati@intel.com>
Subject: [PATCH iwlwifi-next 07/15] wifi: iwlwifi: validate TLV length before reading fields
Date: Mon, 21 Sep 2026 23:41:17 +0300
Message-Id: <20260921233730.6127e849e40a.If963f766dbe29cbb8c226e163ab678be97240730@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260921204125.1313346-1-miriam.rachel.korenblit@intel.com>
References: <20260921204125.1313346-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Shahar Tzarfati <shahar.tzarfati@intel.com>

The INI/Yoyo debug TLVs are parsed from an untrusted firmware-debug
file. The dispatcher only guarantees that the
TLV length covers the 8-byte common header, yet several per-type
handlers dereferenced fields located beyond that header before
checking the TLV length.

Add the missing minimum-length check in iwl_dbg_tlv_config_set() so
the short TLV is rejected before it is stored, and move the field
reads in the other handlers to after their existing length checks so
no field is dereferenced before the buffer is known to be large
enough.

Signed-off-by: Shahar Tzarfati <shahar.tzarfati@intel.com>
Assisted-by: GitHub-Copilot:claude-opus-4-8
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.c  | 34 +++++++++++++------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 11763dec77ec..bd2a9e4b4b5f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -167,11 +167,13 @@ static int iwl_dbg_tlv_alloc_hcmd(struct iwl_trans *trans,
 				  const struct iwl_ucode_tlv *tlv)
 {
 	const struct iwl_fw_ini_hcmd_tlv *hcmd = (const void *)tlv->data;
-	u32 tp = le32_to_cpu(hcmd->time_point);
+	u32 tp;
 
 	if (le32_to_cpu(tlv->length) <= sizeof(*hcmd))
 		return -EINVAL;
 
+	tp = le32_to_cpu(hcmd->time_point);
+
 	/* Host commands can not be sent in early time point since the FW
 	 * is not ready
 	 */
@@ -194,9 +196,14 @@ static int iwl_dbg_tlv_alloc_region(struct iwl_trans *trans,
 {
 	const struct iwl_fw_ini_region_tlv *reg = (const void *)tlv->data;
 	struct iwl_ucode_tlv **active_reg;
-	u32 id = le32_to_cpu(reg->id);
-	u8 type = reg->type;
 	u32 tlv_len = sizeof(*tlv) + le32_to_cpu(tlv->length);
+	u32 id;
+	u8 type;
+
+	if (le32_to_cpu(tlv->length) < sizeof(*reg))
+		return -EINVAL;
+
+	id = le32_to_cpu(reg->id);
 
 	/*
 	 * The higher part of the ID from version 2 is debug policy.
@@ -205,9 +212,6 @@ static int iwl_dbg_tlv_alloc_region(struct iwl_trans *trans,
 	if (le32_to_cpu(reg->hdr.version) >= 2)
 		id &= IWL_FW_INI_REGION_ID_MASK;
 
-	if (le32_to_cpu(tlv->length) < sizeof(*reg))
-		return -EINVAL;
-
 	/* for safe use of a string from FW, limit it to IWL_FW_INI_MAX_NAME */
 	IWL_DEBUG_FW(trans, "WRT: parsing region: %.*s\n",
 		     IWL_FW_INI_MAX_NAME, reg->name);
@@ -217,6 +221,8 @@ static int iwl_dbg_tlv_alloc_region(struct iwl_trans *trans,
 		return -EINVAL;
 	}
 
+	type = reg->type;
+
 	if (type <= IWL_FW_INI_REGION_INVALID ||
 	    type >= IWL_FW_INI_REGION_NUM) {
 		IWL_ERR(trans, "WRT: Invalid region type %u\n", type);
@@ -251,13 +257,14 @@ static int iwl_dbg_tlv_alloc_trigger(struct iwl_trans *trans,
 				     const struct iwl_ucode_tlv *tlv)
 {
 	const struct iwl_fw_ini_trigger_tlv *trig = (const void *)tlv->data;
-	u32 tp = le32_to_cpu(trig->time_point);
-	u32 rf = le32_to_cpu(trig->reset_fw);
+	u32 tp, rf;
 	struct iwl_ucode_tlv *new_tlv;
 
 	if (le32_to_cpu(tlv->length) < sizeof(*trig))
 		return -EINVAL;
 
+	tp = le32_to_cpu(trig->time_point);
+
 	if (tp <= IWL_FW_INI_TIME_POINT_INVALID ||
 	    tp >= IWL_FW_INI_TIME_POINT_NUM) {
 		IWL_ERR(trans,
@@ -266,6 +273,8 @@ static int iwl_dbg_tlv_alloc_trigger(struct iwl_trans *trans,
 		return -EINVAL;
 	}
 
+	rf = le32_to_cpu(trig->reset_fw);
+
 	IWL_DEBUG_FW(trans,
 		     "WRT: time point %u for trigger TLV with reset_fw %u\n",
 		     tp, rf);
@@ -288,8 +297,13 @@ static int iwl_dbg_tlv_config_set(struct iwl_trans *trans,
 				  const struct iwl_ucode_tlv *tlv)
 {
 	const struct iwl_fw_ini_conf_set_tlv *conf_set = (const void *)tlv->data;
-	u32 tp = le32_to_cpu(conf_set->time_point);
-	u32 type = le32_to_cpu(conf_set->set_type);
+	u32 tp, type;
+
+	if (le32_to_cpu(tlv->length) < sizeof(*conf_set))
+		return -EINVAL;
+
+	tp = le32_to_cpu(conf_set->time_point);
+	type = le32_to_cpu(conf_set->set_type);
 
 	if (tp <= IWL_FW_INI_TIME_POINT_INVALID ||
 	    tp >= IWL_FW_INI_TIME_POINT_NUM) {
-- 
2.34.1

