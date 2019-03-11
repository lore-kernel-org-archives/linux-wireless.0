Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A8C7C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 20:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ACA22064A
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 20:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552334805;
	bh=BxhVKlU1kSlcmaTW/zhPth8olLIL/MGXu4T5cRAGOMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=t6Rlkzk7ZmVSCUw4LG96luscQCXOxE0ohN0HoBWl6BY4Ev1hVGsRDNuVJynXAWs1C
	 fi0rG05BHjd6BPWqaAY0eJkkWPuvTpMm31O4nIRVl2kwpCi1RFkA7/SxNyLsoaw8CO
	 ksk2I7nsKY+a9KyDXTFd+RpkKhy2bMdmdcqW0VM0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbfCKUGd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 16:06:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728443AbfCKT5u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 15:57:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14D0A21738;
        Mon, 11 Mar 2019 19:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552334269;
        bh=BxhVKlU1kSlcmaTW/zhPth8olLIL/MGXu4T5cRAGOMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5V9kX2/qFSi23ks0esz4+vhWS6QHH2lzh168zFwfOlQCE5NyiVfcFtVf9Upk3s/i
         KJOjj5l/dR7jzkDyN8Uq24hvJXJlcPyOPr70iIVK9EHTzog0g1uHFQKUwA4jphMg1h
         Yjzd26FHIlhw1nSyDOKGADXq7nF7gSYnStqJvLTg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 26/44] mac80211: call drv_ibss_join() on restart
Date:   Mon, 11 Mar 2019 15:56:42 -0400
Message-Id: <20190311195700.138462-26-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190311195700.138462-1-sashal@kernel.org>
References: <20190311195700.138462-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 4926b51bfaa6d36bd6f398fb7698679d3962e19d ]

If a driver does any significant activity in its ibss_join method,
then it will very well expect that to be called during restart,
before any stations are added. Do that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/util.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 716cd6442d86..3deaa01ebee4 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -5,7 +5,7 @@
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright (C) 2015-2017	Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018-2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -2020,6 +2020,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		case NL80211_IFTYPE_AP_VLAN:
 		case NL80211_IFTYPE_MONITOR:
 			break;
+		case NL80211_IFTYPE_ADHOC:
+			if (sdata->vif.bss_conf.ibss_joined)
+				WARN_ON(drv_join_ibss(local, sdata));
+			/* fall through */
 		default:
 			ieee80211_reconfig_stations(sdata);
 			/* fall through */
-- 
2.19.1

