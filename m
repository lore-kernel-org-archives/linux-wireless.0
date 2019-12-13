Return-Path: <SRS0=3oid=2D=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A41CCC43603
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Dec 2019 09:26:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8097D214D8
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Dec 2019 09:26:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfLMJ0p (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 13 Dec 2019 04:26:45 -0500
Received: from nbd.name ([46.4.11.11]:32788 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbfLMJ0p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Dec 2019 04:26:45 -0500
Received: from pd95fd344.dip0.t-ipconnect.de ([217.95.211.68] helo=bertha.fritz.box)
        by ds12 with esmtpa (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1ifhDe-0001pp-VG; Fri, 13 Dec 2019 10:26:43 +0100
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Sven Eckelmann <seckelmann@datto.com>,
        John Crispin <john@phrozen.org>
Subject: [PATCH] mac80211: he_support was not set when bringing up a HE mesh interface
Date:   Fri, 13 Dec 2019 10:26:36 +0100
Message-Id: <20191213092636.17736-1-john@phrozen.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>

The he_support flag inside bss_conf was not set when a HE mesh interface
gets created. This causes the drivers to not set the HW up correctly.

Fixes: 60ad72da55ac ("mac80211: implement HE support for mesh")

Cc: Sven Eckelmann <seckelmann@datto.com>
Signed-off-by: John Crispin <john@phrozen.org>
Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
---
 net/mac80211/mesh.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index d09b3c789314..98d70f4ef6a4 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -551,6 +551,8 @@ int mesh_add_he_cap_ie(struct ieee80211_sub_if_data *sdata,
 	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_10)
 		return 0;
 
+	sdata->vif.bss_conf.he_support = 1;
+
 	if (skb_tailroom(skb) < ie_len)
 		return -ENOMEM;
 
-- 
2.20.1

