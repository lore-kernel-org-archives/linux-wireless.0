Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C36F7EDEC49
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Sep 2023 11:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240605AbjIML6K (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Sep 2023 07:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240608AbjIML6J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Sep 2023 07:58:09 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6938219A8
        for <linux-wireless@vger.kernel.org>; Wed, 13 Sep 2023 04:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694606285; x=1726142285;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ii9/Kw5cZvBrFj4DTdipmjFe5erCypq59xbQv+xOM58=;
  b=j5hYXdw7NdFZqMUvDafM6IhhkppytKqAZz4tFnWjOEioIc3o3WZaOLnD
   yWgZkTNlMBsK/ZfIZ/cUYHBtkypWt8bys7aRsYyCkKhP5RU55woRzEbH7
   iP92VehU3AD0e+aeT+sHrPcW53p4vl0N0t5m1sgfZmTmHI8fOlkGwpVIv
   e14iABMameo9jS1QeGQsQJfFMgi31aEzgtKGyCFFbGRq7E9jWLghPk6vF
   vF1V/frr0oABhvudbNeekX5iZQEkZuceH9hQ7yo4Cb7COL33dtfCJ/ryh
   VWPU9iMYT9yzZDgX5RnfYq4xl/tqRgNi/+J3Bp7pfo5A3KY9HSoJsSD14
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="368903106"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="368903106"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 04:57:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="737470993"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="737470993"
Received: from ggreenma-mobl2.jer.intel.com ([10.13.17.40])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 04:57:42 -0700
From:   gregory.greenman@intel.com
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>
Subject: [PATCH 15/15] wifi: iwlwifi: mvm: add a debug print when we get a BAR
Date:   Wed, 13 Sep 2023 14:56:51 +0300
Message-Id: <20230913145231.913e989a1751.I6bff9020e339d91b61b5ad6aede27bcf8c7e6819@changeid>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230913115651.190558-1-gregory.greenman@intel.com>
References: <20230913115651.190558-1-gregory.greenman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Getting a BAR can be an explanation if we're chasing packet loss. Add a
print with the relevant debug level in that code path.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 42d69f557e71..041afc97a911 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -2803,6 +2803,9 @@ void iwl_mvm_rx_bar_frame_release(struct iwl_mvm *mvm, struct napi_struct *napi,
 		 tid))
 		goto out;
 
+	IWL_DEBUG_DROP(mvm, "Received a BAR, expect packet loss: nssn %d\n",
+		       nssn);
+
 	iwl_mvm_release_frames_from_notif(mvm, napi, baid, nssn, queue, 0);
 out:
 	rcu_read_unlock();
-- 
2.38.1

