Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05309C4332F
	for <linux-wireless@archiver.kernel.org>; Mon, 13 Nov 2023 09:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbjKMJgG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 13 Nov 2023 04:36:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233330AbjKMJgE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2023 04:36:04 -0500
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32D410D0
        for <linux-wireless@vger.kernel.org>; Mon, 13 Nov 2023 01:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699868161; x=1731404161;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HteM5FXANcM5ayvW/va3mVhts6mlcC7/guBLUTaAo6w=;
  b=S947rZXw2zra+zXbZLn31DAe4TsyTkGxAImfwNJtp3BqneWBBvr1vCFM
   MR/NIo3M3l8dr0p1Fk1wztQwC3r4Y6qdOEW9guRYB0sQ+ZqQ20Z4lr6bD
   M6L8ARNDPEXqreXx+0f1NVO1GINUupJRtIIbVnJSVTTAn7h6KEueWfl5d
   ALrXqvM6/xj/YNriIEAxFSGAXVmS5qFrHV4BqMKZ/l+KA/j0TOD6oWdNN
   d+3csfKd+qLs5NHbGGGlTwW8Ztnb0WU1+vmL7kEAea6VeiLdSvfdRipKA
   FvjUoOmJjd3GF5YFv6zLBdgwHr4CMpql8dG9gY8yNisF+bjFuZfTljT7X
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10892"; a="369735743"
X-IronPort-AV: E=Sophos;i="6.03,299,1694761200"; 
   d="scan'208";a="369735743"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2023 01:36:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10892"; a="937695275"
X-IronPort-AV: E=Sophos;i="6.03,299,1694761200"; 
   d="scan'208";a="937695275"
Received: from tdistelf-mobl2.ger.corp.intel.com (HELO ggreenma-mobl2.intel.com) ([10.214.220.47])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2023 01:35:59 -0800
From:   gregory.greenman@intel.com
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>
Subject: [PATCH 5/6] wifi: mac80211: Schedule regulatory channels check on bandwith change
Date:   Mon, 13 Nov 2023 11:35:04 +0200
Message-Id: <20231113112844.0fdca73c5306.If8915d13e203ebd380579f55fd9148e9b3f43306@changeid>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20231113093505.456824-1-gregory.greenman@intel.com>
References: <20231113093505.456824-1-gregory.greenman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Some devices may support concurrent DFS operation which relies on the
BSS channel width for its relaxations. Notify cfg80211 about BW change
so it can schedule regulatory checks.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
---
 net/mac80211/mlme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 887b496f2b81..e464a3984f87 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -595,6 +595,7 @@ static int ieee80211_config_bw(struct ieee80211_link_data *link,
 		return ret;
 	}
 
+	cfg80211_schedule_channels_check(sdata->dev);
 	return 0;
 }
 
-- 
2.38.1

