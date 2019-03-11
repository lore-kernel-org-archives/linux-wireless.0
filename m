Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB2ABC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 20:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EDC4214AE
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 20:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552335149;
	bh=98Wv0G4tOoKN5NDxpaUpvGfEOQOuWdYy+kY8tkJwsnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=e9KzZ8px7QfVJkdhtO2DAJlvH0zSOkFLRBXVl0WtTPEGSYWxEXFRh1l/0shoNTpfp
	 dIcrJVNYpZbJf1aBXtJyKVxRJyBtbTM/IemE/A8X8JmMqtYDqWkmadv8g7O1lZYjU2
	 FSfzBgqIJki6FvtRGFtklzLhrcMumbw6tw1k0gE0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbfCKUMV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 16:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728500AbfCKT4L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 15:56:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E51CD21738;
        Mon, 11 Mar 2019 19:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552334170;
        bh=98Wv0G4tOoKN5NDxpaUpvGfEOQOuWdYy+kY8tkJwsnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g+899Cyadu56PCrrpoxH5asKzSF321fuLEHKDh5xQxp7lcFhXm4rJmaQE4C7Ab0nA
         sWBLhPcsXCbaqjfL7lCkA4ENyqfp1Cgc3EUdWpPAOLUNDFrArn4nedre0z9q0+wc5Q
         QxaaCqWZrhr5GNT5r8EtQPa1nXFs2OCHX2vclBjg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 28/52] mac80211: call drv_ibss_join() on restart
Date:   Mon, 11 Mar 2019 15:54:52 -0400
Message-Id: <20190311195516.137772-28-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190311195516.137772-1-sashal@kernel.org>
References: <20190311195516.137772-1-sashal@kernel.org>
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
index dddfff7cf44f..57ad01560023 100644
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
@@ -2144,6 +2144,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
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

