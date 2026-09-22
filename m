Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5450F3AFCEF
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 11:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790077702; cv=none; b=Qe+yPuFQR9ewPEfQtUStFLanl2gbs4rPh+ZXZfpg3f3u/I/aLpVgIHq3wtbGvNq4zbwGMvVXCOpGbkCfyUGdigXC9GX8LBLJ7cHyuKI8keoeXWKanGSIclz5mHulOU5zj+jAdYY/2xxWWRmLbTFafzXqt217fiWRO7hhyR/y2l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790077702; c=relaxed/simple;
	bh=CKPbmorfOUPZ4YqiILJl7/0kW0/MOpJq5HRisYylS+Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pnn2XJep6XL2tOcarIzdhuYTTxWvcKPPGr20N+kogN6kAOhtxdjRDxrHTNmr78pr8wME5AMg4aNXZsWGxvLh6geX/IhQbnGbPjengJb/E3FXNMBFQ81RqlMU4/9ouSVL7+HwFwofOPBlh24U7e15RNvxitgoE6wnITifYI57GcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jcqdArtZ; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jcqdArtZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790077701; x=1821613701;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CKPbmorfOUPZ4YqiILJl7/0kW0/MOpJq5HRisYylS+Y=;
  b=jcqdArtZkGTazGSMnl64q05d9WakTSNGpfZ6JCCw8NsaE8bfEK9bzm6l
   o4qjC4bOSsnUoJNtACXfkleH37qFA49zerX0sAubWoTREru/f95+I1f/O
   IhvOQWrooRJd7Ua2icALKILV/9le0haswS8ddDUTfJyTiIDc4D1T/lOy9
   CMG2CLNsomHP6KeV8hbwW0mCMx08amtjma8eaO8PIXUiiTRqzYHuHSM9X
   2THRaDkPIkn8/8csgHjhkM75QnqWwiCQH0ZRR1bhB8pcQLl06N47urBzy
   fS7rCuphv/JCslkAqO1ficNW3mQBXRHdmuGnrHvfCDLV8/4Mjqb5JgZwl
   g==;
X-CSE-ConnectionGUID: fnLG+pmKQYW1VwFKSpNRmQ==
X-CSE-MsgGUID: r+xfObEYSOWW6DkkBI2SGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="108170521"
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="108170521"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:11 -0700
X-CSE-ConnectionGUID: 53vQLvRpSvSDkGkVK5FJig==
X-CSE-MsgGUID: /5kCgXAMS4ajH8pMKYm6ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,116,1787036400"; 
   d="scan'208";a="273275364"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 04:48:10 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH iwlwifi-next 05/15] wifi: iwlwifi: mld: stop filling link fields unused by the firmware
Date: Tue, 22 Sep 2026 14:49:52 +0300
Message-Id: <20260922144819.887695af3d15.Ie0f0804a28ec4e1e8e41d0eb11615ed2a0f2823e@changeid>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The htc_trig_based_pkt_ext, rand_alloc_ecwmin, rand_alloc_ecwmax and
frame_time_rts_th fields of the LINK context config command are not
used by the firmware. Stop filling them.

Assisted-by: GithubCopilot:claude-opus-4.8
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/link.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/link.c b/drivers/net/wireless/intel/iwlwifi/mld/link.c
index 96e06940b34c..65eddbd63016 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/link.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/link.c
@@ -361,13 +361,6 @@ iwl_mld_change_link_in_fw(struct iwl_mld *mld, struct ieee80211_bss_conf *link,
 			flags |= LINK_FLG_MLPM;
 	}
 
-	cmd.htc_trig_based_pkt_ext = link->htc_trig_based_pkt_ext;
-
-	if (link->uora_exists) {
-		cmd.rand_alloc_ecwmin = link->uora_ocw_range & 0x7;
-		cmd.rand_alloc_ecwmax = (link->uora_ocw_range >> 3) & 0x7;
-	}
-
 	if (iwl_mld_fill_mu_edca(mld, mld_link, cmd.trig_based_txf))
 		flags |= LINK_FLG_MU_EDCA_CW;
 
@@ -376,8 +369,6 @@ iwl_mld_change_link_in_fw(struct iwl_mld *mld, struct ieee80211_bss_conf *link,
 	if (!link->he_bss_color.enabled)
 		flags |= LINK_FLG_BSS_COLOR_DIS;
 
-	cmd.frame_time_rts_th = cpu_to_le16(link->frame_time_rts_th);
-
 	/* Block 26-tone RU OFDMA transmissions */
 	if (mld_link->he_ru_2mhz_block)
 		flags |= LINK_FLG_RU_2MHZ_BLOCK;
-- 
2.34.1

