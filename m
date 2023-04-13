Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1BB6C77B6E
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Apr 2023 18:41:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjDMSlj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Apr 2023 14:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjDMSlj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2023 14:41:39 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46599524B
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2023 11:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681411297; x=1712947297;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YM0Lzt3cFtk5LJxsDkPJAgleetC/oRViexTj+kYKZjY=;
  b=digwxHhvfmYAGW8NY/S//GpqZ9Wcrv7909WSYYJbOmBdcMvac3PGPK9Y
   wsSY2FpyzG6paDhn5DdaizlAk/VladDeeaWBvSTy8rgpG2A1CKpVRvDpN
   ycl42QSgEBbXeyYcLUt7uUzkwz03ZPtRiAYMWtU+LDFaMH8sU79ATzG8u
   GvxOEep/uVTvEluKwKpQic0QFaZ0KCLQuNHINqi9HB0+RWbs0EeubfNBh
   DhHfdaJ2N18S76S2WSfpZ9SIjizrBhYRt56X5Akxte4xDQDDWdo0GAb68
   74lnXc9H3aXwCBWC/Sb7jxZiSQj+N5jOwRm7gUnP1fsZ0fAeN5guUbqns
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="372126999"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="372126999"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 11:41:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="719984345"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="719984345"
Received: from apeled2-mobl.ger.corp.intel.com (HELO ggreenma-mobl2.lan) ([10.251.184.75])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 11:41:00 -0700
From:   gregory.greenman@intel.com
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>
Subject: [PATCH 05/15] wifi: iwlwifi: mvm: request limiting to 8 MSDUs per A-MSDU
Date:   Thu, 13 Apr 2023 21:40:25 +0300
Message-Id: <20230413213309.e6c518f2724f.I15c13d13b38289edbcd64f67d57cf18f6026457a@changeid>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230413184035.1140892-1-gregory.greenman@intel.com>
References: <20230413184035.1140892-1-gregory.greenman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Due to hardware limitations when splitting up A-MSDUs, it
cannot handle an arbitrary number of MSDUs per A-MSDU. Set
the bits to ask transmitters to send only 8 MSDUs in one
A-MSDU.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index fc15636beec0..ac5c4799fa7e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -227,14 +227,18 @@ int iwl_mvm_init_fw_regd(struct iwl_mvm *mvm)
 static const u8 he_if_types_ext_capa_sta[] = {
 	 [0] = WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING,
 	 [2] = WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT,
-	 [7] = WLAN_EXT_CAPA8_OPMODE_NOTIF,
+	 [7] = WLAN_EXT_CAPA8_OPMODE_NOTIF |
+	       WLAN_EXT_CAPA8_MAX_MSDU_IN_AMSDU_LSB,
+	 [8] = WLAN_EXT_CAPA9_MAX_MSDU_IN_AMSDU_MSB,
 };
 
 static const u8 tm_if_types_ext_capa_sta[] = {
 	 [0] = WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING,
 	 [2] = WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT |
 	       WLAN_EXT_CAPA3_TIMING_MEASUREMENT_SUPPORT,
-	 [7] = WLAN_EXT_CAPA8_OPMODE_NOTIF,
+	 [7] = WLAN_EXT_CAPA8_OPMODE_NOTIF |
+	       WLAN_EXT_CAPA8_MAX_MSDU_IN_AMSDU_LSB,
+	 [8] = WLAN_EXT_CAPA9_MAX_MSDU_IN_AMSDU_MSB,
 	 [9] = WLAN_EXT_CAPA10_TWT_REQUESTER_SUPPORT,
 };
 
-- 
2.38.1

