Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D03C636D7
	for <linux-wireless@archiver.kernel.org>; Thu, 23 Feb 2023 10:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234130AbjBWKM3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 23 Feb 2023 05:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234095AbjBWKMT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2023 05:12:19 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7B151915
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2023 02:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677147138; x=1708683138;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r62uH3sdVqE6J5c5+puxa6H9aaTzV+A11gimufUyV4A=;
  b=h7aDiPknhFIhWK5lImk53bH3ZF1x+VP/Ft74+rWTnwQiS9LKUraK2+Pj
   vCKyBi2/9ykeRQmzLwW/qLFzNim1lPoqTX2KnZTBUSkOk/lirp64xSsB1
   VONFBuXvZXbkCzXSvmw0kZjHhe3XxtDqTjYSraUc+OthRUi15vMKbTpJ+
   pRSzqQhqMHmrpnGlY+UZLE0iCdLMkW64lB1iyNp+DKonM7TsXzfCbVQ8E
   rxmZA3Q7+d31XTjQGrC8RA5ZdIBCfVeqPpVhIIzDhMtqvtTdIKHULPZEx
   3ArLG1cuc4GQCk4qFoiifnGUd+KoTNoEwHVNlxhSPFAsiiqEnCJgGR/NL
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="419396478"
X-IronPort-AV: E=Sophos;i="5.97,320,1669104000"; 
   d="scan'208";a="419396478"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 02:11:12 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="796245714"
X-IronPort-AV: E=Sophos;i="5.97,320,1669104000"; 
   d="scan'208";a="796245714"
Received: from bkalend-mobl1.ger.corp.intel.com (HELO ggreenma-mobl2.intel.com) ([10.214.227.25])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 02:11:10 -0800
From:   gregory.greenman@intel.com
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Gregory Greenman <gregory.greenman@intel.com>
Subject: [PATCH 19/21] wifi: mac80211: simplify reasoning about EHT capa handling
Date:   Thu, 23 Feb 2023 12:09:40 +0200
Message-Id: <20230223114629.02cc52fb3219.I6fef7484721be9bd5364f64921fc5e9168495f62@changeid>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230223100942.767589-1-gregory.greenman@intel.com>
References: <20230223100942.767589-1-gregory.greenman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Given the code in cfg80211, EHT capa cannot be non-NULL when
HE capa is NULL, but it's easier to reason about it if both
are checked and the compiler will likely integrate the check
with the previous one for HE capa anyway.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
---
 net/mac80211/cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7e90f4a81962..2c8fa19c2f24 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1788,7 +1788,7 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 						  (void *)params->he_6ghz_capa,
 						  link_sta);
 
-	if (params->eht_capa)
+	if (params->he_capa && params->eht_capa)
 		ieee80211_eht_cap_ie_to_sta_eht_cap(sdata, sband,
 						    (u8 *)params->he_capa,
 						    params->he_capa_len,
-- 
2.38.1

