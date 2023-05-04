Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37679C77B78
	for <linux-wireless@archiver.kernel.org>; Thu,  4 May 2023 13:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjEDNp2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 May 2023 09:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjEDNp0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 May 2023 09:45:26 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD2C7A99
        for <linux-wireless@vger.kernel.org>; Thu,  4 May 2023 06:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683207925; x=1714743925;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=p9krqr+xm2nJWIxjgOB5fSPNEOB5VXGX/b7fHRvUU8M=;
  b=ezRiW3+1tYXY6fl6tc/B9RaUBGWpKVxKSWVhQTfIpdxzlaj95Yumpdmc
   ayAf7AQFs7tIhhCDX//L5hQBGER3No6GlfzaVrhTp3iKZSiS/qpgOLYex
   BPMlstvhoZQsNAEjIkm7ban0ZsonRJoRopc9QWdos2z3HM0FN683rJTQK
   0s63oNYUzTYHEKlfNffZatb1rXy938yNRdKWRrvuVXR63L59opCBOSLMW
   y1qVQ/1nhRbCt2nTZCinu1Rhv2qZ697sUBToDJyCflkg/pABEx/aLIsGq
   dV5QuzNhju+lxXA19iVUo9m4rKyuxdHl6JyOYH3r08IE4T8Dy1bHMDODO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10700"; a="435242556"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="435242556"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2023 06:45:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10700"; a="766591600"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="766591600"
Received: from haddadra-mobl1.ger.corp.intel.com (HELO ggreenma-mobl2.intel.com) ([10.214.238.144])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2023 06:45:24 -0700
From:   gregory.greenman@intel.com
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Gregory Greenman <gregory.greenman@intel.com>
Subject: [PATCH 00/11] cfg80211/mac80211 patches from our internal tree 2023-05-04
Date:   Thu,  4 May 2023 16:45:00 +0300
Message-Id: <20230504134511.828474-1-gregory.greenman@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Gregory Greenman <gregory.greenman@intel.com>

Hi,

A bunch of patches from our internal tree with mac80211 and
cfg80211 changes. It's the usual developement, cleanups and
bugfixes.

Thanks,
Gregory

Emmanuel Grumbach (1):
  wifi: mac80211: fetch and store the EML capability information

Ilan Peer (1):
  wifi: mac80211: Fix elements scratch buffer allocation

Johannes Berg (8):
  wifi: mac80211: fix min center freq offset tracing
  wifi: mac80211: simplify chanctx allocation
  wifi: mac80211: consider reserved chanctx for mindef
  wifi: mac80211: recalc chanctx mindef before assigning
  wifi: mac80211: HW restart for MLO
  wifi: mac80211_hwsim: avoid warning with MLO PS stations
  wifi: mac80211: skip EHT BSS membership selector
  wifi: mac80211: implement proper AP MLD HW restart

Mukesh Sisodiya (1):
  wifi: cfg80211: Add null check for ie data

 drivers/net/wireless/virtual/mac80211_hwsim.c |   9 +-
 include/linux/ieee80211.h                     |  40 ++++-
 include/net/mac80211.h                        |   2 +
 net/mac80211/chan.c                           |  75 +++++----
 net/mac80211/ieee80211_i.h                    |   6 +-
 net/mac80211/mlme.c                           |  16 +-
 net/mac80211/trace.h                          |   2 +-
 net/mac80211/util.c                           | 155 +++++++++++++-----
 net/wireless/sme.c                            |   2 +-
 9 files changed, 232 insertions(+), 75 deletions(-)

-- 
2.38.1

