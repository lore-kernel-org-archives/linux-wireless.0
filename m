Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC01253D0B3
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790077708; cv=none; b=ZNDgRGB1Efp9gm3JlWWHJkVUkMHVjoEgP1YBgCE1KNnA9KKNvZ7XMN+wjVXV/LW1dVf+EmsIDK/0mw2ZUiyIM7q93TgMq3FBDid0wePvMWGU2NwJKqMepO9Fk7iGNzcIN4Nx7jcC3hu00FfRwnvSEn60MQAxjADpfeHlvulbDIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790077708; c=relaxed/simple;
	bh=Sx7zsB4Aqz9fPQQMdrFtG6MQ1DTIEMIcPKk02YiWOSg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=obyjSooNOvvOy9TKbnDP4rxrYAKG19n8Teq4GobUp2KbsPCwi29tNPBXVox8NIkiTDGZdezNtsGvHn0Pb45qwoq46gZCsEwh4hPe0W/nzP4hFLG3wGpNTPUpPRCZtraG73NSxBTWGpX0IycV+9k/8yoRoHLD1DVt7O4slr4hebE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FaU9ztKx; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FaU9ztKx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790077706; x=1821613706;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Sx7zsB4Aqz9fPQQMdrFtG6MQ1DTIEMIcPKk02YiWOSg=;
  b=FaU9ztKxGYBDAwTAgW35uhBiEp8GrKh1qCS2qBOOq7T+zJkST0esgkoK
   W13aZLsDI3em+35o8sNStV3bbU0Endccm3ryhbMzEGpKq9wvXMLkRhr1V
   JP78aX944kgd9gUPo7Co29L1ajXJCd7EXZj87bMIDvQa0XgKOl5FXZvTw
   s1Qs2drEuCBdSoLT2Avrhfq7LSdQApWwXpD8NPNMSQKeS1ClZWlC0f3lI
   EzatkVnSKeNKQlQKZMovDh0tzQvLGYuR+96kLKL/alcv6CaQDIrt+WdRa
   IbiL3pKrwUBBDBh/SMRdAevT+yi6yrmvMLREd/XHjtRYUjy9z7fe7AboA
   Q==;
X-CSE-ConnectionGUID: 1F8AfXpQTrOqPo3wvuAGDA==
X-CSE-MsgGUID: 4SvegxtqT4WzPf1Wps1mEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="108170560"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="108170560"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:22 -0700
X-CSE-ConnectionGUID: fBqUP0lwRr6sSq2h2yEmSw==
X-CSE-MsgGUID: /hnHk0M4R4qF2QRgJJYfBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="273275425"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:21 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: [PATCH iwlwifi-next 13/15] wifi: iwlwifi: fw: reject empty UEFI DSM query bitmap
Date: Tue, 22 Sep 2026 14:50:00 +0300
Message-Id: <20260922144819.fe9c61c887e1.I735e6a67f7fb4903ddeca84f0a2ca5cd062ba1df@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
References: <20260922115002.934469-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

Some platforms expose a UEFI DSM table with the expected revision
but with an empty QUERY bitmap, which means no DSM function is
advertised as valid.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
index bf6a31e6f149..7c290b526383 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
@@ -915,6 +915,12 @@ static int iwl_uefi_load_dsm_values(struct iwl_fw_runtime *fwrt)
 				data->revision);
 		goto out;
 	}
+	if (!data->functions[DSM_FUNC_QUERY]) {
+		IWL_DEBUG_RADIO(fwrt,
+				"UEFI DSM query bitmap is empty, revision:%d\n",
+				data->revision);
+		goto out;
+	}
 	fwrt->dsm_revision = data->revision;
 	fwrt->dsm_source = BIOS_SOURCE_UEFI;
 
-- 
2.34.1

