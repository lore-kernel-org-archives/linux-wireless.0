Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E7FC433FE
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Nov 2022 21:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236558AbiKWVD3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 23 Nov 2022 16:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235823AbiKWVD1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2022 16:03:27 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CC22A430
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2022 13:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669237406; x=1700773406;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iJPZL3JOccOn4mpzTpiiWBOXFJgmhr41/b/tkoxvqJY=;
  b=PaOawmDHXxQqcKcgtwe2PN2j2kEUjtPvDCFmYEUcKNHfeuI9UzuCyWSr
   hg6DqmcO5Mw7/wA3U6WEaKzsDCrN6TC1ASUTGy2jF7lcQHJvkW/PTs2jZ
   Yv82NoVOvRFrkgp66Jxk4ulEKERv1h62h+RRLJiYO+CnBRrYLfRwPz5pR
   Z3gzJFYW0VAoqDuo4brbUQI5nbAs339i9QN3H5ca9DPY+1z6pOBTs/Bw3
   13MaGPI923hcB+AucpkXhCjf1bX5gUaw0nKl2QGugb66yElo2z7AQ6WTe
   q24DMWNYez9MpqNZ9QbRdtL4zl69NswOv7aDBETMkkCKMpHXmOm6Tv/zZ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="294546380"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="294546380"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 13:03:26 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="619761574"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="619761574"
Received: from stopaz-mobl1.ger.corp.intel.com (HELO ggreenma-mobl2.lan) ([10.214.194.175])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 13:03:24 -0800
From:   gregory.greenman@intel.com
To:     kvalo@kernel.org, johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Daniel Gabay <daniel.gabay@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>
Subject: [PATCH 1/5] wifi: iwlwifi: mvm: print OTP info after alive
Date:   Wed, 23 Nov 2022 23:02:05 +0200
Message-Id: <20221123225313.a5ae3679491b.Ic618934df084a9b269e56d892665523c79e40eee@changeid>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221123210209.2941641-1-gregory.greenman@intel.com>
References: <20221123210209.2941641-1-gregory.greenman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Daniel Gabay <daniel.gabay@intel.com>

These are register values which are needed for debug regardless of alive
fail/success.

Signed-off-by: Daniel Gabay <daniel.gabay@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index ef43f6971cd9..b3101d12a0a1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -354,6 +354,18 @@ static int iwl_mvm_load_ucode_wait_alive(struct iwl_mvm *mvm,
 	 */
 	ret = iwl_wait_notification(&mvm->notif_wait, &alive_wait,
 				    MVM_UCODE_ALIVE_TIMEOUT);
+
+	if (mvm->trans->trans_cfg->device_family ==
+	    IWL_DEVICE_FAMILY_AX210) {
+		/* print these registers regardless of alive fail/success */
+		IWL_INFO(mvm, "WFPM_UMAC_PD_NOTIFICATION: 0x%x\n",
+			 iwl_read_umac_prph(mvm->trans, WFPM_ARC1_PD_NOTIFICATION));
+		IWL_INFO(mvm, "WFPM_LMAC2_PD_NOTIFICATION: 0x%x\n",
+			 iwl_read_umac_prph(mvm->trans, WFPM_LMAC2_PD_NOTIFICATION));
+		IWL_INFO(mvm, "WFPM_AUTH_KEY_0: 0x%x\n",
+			 iwl_read_umac_prph(mvm->trans, SB_MODIFY_CFG_FLAG));
+	}
+
 	if (ret) {
 		struct iwl_trans *trans = mvm->trans;
 
-- 
2.35.3

