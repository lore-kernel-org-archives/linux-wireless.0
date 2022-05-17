Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84B0EC433F5
	for <linux-wireless@archiver.kernel.org>; Tue, 17 May 2022 09:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbiEQJHp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 17 May 2022 05:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243998AbiEQJGp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 May 2022 05:06:45 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC2A21828
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2022 02:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652778393; x=1684314393;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=X/uyHbVlQA8hVGzzFATBMx7IXCafqOtE0vkyAZoaYt4=;
  b=DBuWS8ie161NXtPdMuok0Jvx7q1ig6syn6lLjlj4vmD1+Yjh6bq4+P+2
   /6a2cLIZNFO8AM76tAdSZD28lS3BJ771lo3ARy3RCoSLDf4DrbDkcOIfu
   snwHjonrDA+iOz4sc+nbJiBoD2LzX9CqAyVUaFomtE9aco/hLTpu8JqAP
   xY1AiNlWdC0xn0F+p0/lCjqZM1Qu3fOwWigjFPlqGepQTLuQbT9PvjWP4
   jBXh7fx7t9kERQ1GE8rA4MkgfPAra1m2NT578pLzxGtZ2jvvL0m76UbaZ
   kLQkryXBbm2hLmsMUQgpaDkXw3QnVjRxprenhs/IEzwjalp056Olq8HLz
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="268700427"
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="268700427"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 02:05:53 -0700
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="741679516"
Received: from sgens-mobl3.ger.corp.intel.com (HELO ggreenma-mobl2.lan) ([10.214.212.48])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 02:05:51 -0700
From:   gregory.greenman@intel.com
To:     kvalo@kernel.org
Cc:     johannes@sipsolutions.net, gregory.greenman@intel.com,
        linux-wireless@vger.kernel.org
Subject: [PATCH 00/10] iwlwifi: updates intended for v5.18 2022-05-17
Date:   Tue, 17 May 2022 12:05:04 +0300
Message-Id: <20220517090514.211796-1-gregory.greenman@intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Gregory Greenman <gregory.greenman@intel.com>

Hello,

Here's a set of patches intended for v5.18 if time permits. It's the
usual developement, bugfixes and small cleanups. Nothing major in this
series.

Thanks,
Gregory

Avraham Stern (1):
  iwlwifi: mei: clear the sap data header before sending

Emmanuel Grumbach (2):
  iwlwifi: mvm: fix assert 1F04 upon reconfig
  iwlwifi: mvm: always tell the firmware to accept MCAST frames in BSS

Haim Dreyfuss (1):
  iwlwifi: mvm: use NULL instead of ERR_PTR when parsing wowlan status

Johannes Berg (4):
  iwlwifi: pcie: simplify MSI-X cause mapping
  iwlwifi: mvm: clean up authorized condition
  iwlwifi: fw: init SAR GEO table only if data is present
  iwlwifi: mei: fix potential NULL-ptr deref

Miri Korenblit (1):
  iwlwifi: mvm: remove vif_count

Mordechay Goodstein (1):
  iwlwifi: mvm: add OTP info in case of init failure

 drivers/net/wireless/intel/iwlwifi/fw/acpi.c  |  3 ++
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h |  2 +
 drivers/net/wireless/intel/iwlwifi/mei/main.c |  3 ++
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   | 22 ++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c   | 15 +++---
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 32 +++----------
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 17 ++-----
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  1 -
 .../net/wireless/intel/iwlwifi/mvm/power.c    |  3 ++
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c   | 44 ++++++++++++-----
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 48 +++++++++++--------
 11 files changed, 102 insertions(+), 88 deletions(-)

-- 
2.35.1

