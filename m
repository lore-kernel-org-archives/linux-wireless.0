Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B25E748ED
	for <linux-wireless@archiver.kernel.org>; Sun,  1 Oct 2023 10:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbjJAKB0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 1 Oct 2023 06:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234745AbjJAKBZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 1 Oct 2023 06:01:25 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11732B7
        for <linux-wireless@vger.kernel.org>; Sun,  1 Oct 2023 03:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696154483; x=1727690483;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6+FFrc6b0FXcvD575AVv7nOCUa3sH/ALEnx0pDJ9wVk=;
  b=e4OaKPViTZPfJzg/z7JF+sEsk90aLwrL2PaATkWifX1yuHrL/fPT4HiU
   qokn6GjRpADykSne3t8fggb7qGSUEcRKKtI9ZL98gQnJh+4ANXdrM+Rru
   zo5sIENCFuqw4I3CEvGPRWiQgx7MrqNqhiC5O2ppcIhnBAdMng2Br59A5
   AZMq02TooyWeLBLA5zEUz9YiNoFu/IDeMVH3FKxEhZ+rnXHB7re5mhviS
   j8t8qIcKYmSycKk8ccNKoBUAt50QV36p3TcrLDpqlNzJcJ9Q0XOAmLpkH
   dlpKlWc5u7IUApwH38ulYlqA8g4d1T7SmC/0MkBYoAvfcLgeKxDxSrU3M
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10849"; a="361891555"
X-IronPort-AV: E=Sophos;i="6.03,191,1694761200"; 
   d="scan'208";a="361891555"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2023 03:01:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10849"; a="750335604"
X-IronPort-AV: E=Sophos;i="6.03,191,1694761200"; 
   d="scan'208";a="750335604"
Received: from gsharon-mobl.ger.corp.intel.com (HELO ggreenma-mobl2.lan) ([10.214.196.63])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2023 03:01:20 -0700
From:   gregory.greenman@intel.com
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>
Subject: [PATCH v2 02/18] wifi: mac80211: drop robust action frames before assoc
Date:   Sun,  1 Oct 2023 13:01:09 +0300
Message-Id: <20231001125722.b2fd37083371.Ie9f4906e2f6c698989bce6681956ed2f9454f27c@changeid>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

To be able to more easily understand the code, drop robust
action frames before being associated, even if there's no
MFP in the end, as they are Class 3 Frames and shouldn't
be transmitted in the first place.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
---
v2: rebase adjustments, for c419d884551f
    ("wifi: mac80211: fix ieee80211_drop_unencrypted_mgmt return type/value")
---
 net/mac80211/rx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 051db97a92b4..f2ea15d31c31 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2474,6 +2474,15 @@ ieee80211_drop_unencrypted_mgmt(struct ieee80211_rx_data *rx)
 			return RX_DROP_U_UNPROT_UNICAST_PUB_ACTION;
 	}
 
+	/*
+	 * Drop robust action frames before assoc regardless of MFP state,
+	 * after assoc we also have decided on MFP or not.
+	 */
+	if (ieee80211_is_action(fc) &&
+	    ieee80211_is_robust_mgmt_frame(rx->skb) &&
+	    (!rx->sta || !test_sta_flag(rx->sta, WLAN_STA_ASSOC)))
+		return -EACCES;
+
 	return RX_CONTINUE;
 }
 
-- 
2.38.1

