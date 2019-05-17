Return-Path: <SRS0=tPxB=TR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0763AC04E84
	for <linux-wireless@archiver.kernel.org>; Fri, 17 May 2019 19:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D89ED216FD
	for <linux-wireless@archiver.kernel.org>; Fri, 17 May 2019 19:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728978AbfEQTa3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 17 May 2019 15:30:29 -0400
Received: from nbd.name ([46.4.11.11]:37368 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728951AbfEQTa2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 May 2019 15:30:28 -0400
Received: from p548c8c9f.dip0.t-ipconnect.de ([84.140.140.159] helo=bertha.fritz.box)
        by ds12 with esmtpa (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hRiYk-0006cc-IE; Fri, 17 May 2019 21:30:26 +0200
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, John Crispin <john@phrozen.org>
Subject: [PATCH 1/7] iw: fix memory leak inside register_mgmt_frame
Date:   Fri, 17 May 2019 21:29:50 +0200
Message-Id: <20190517192956.18372-2-john@phrozen.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190517192956.18372-1-john@phrozen.org>
References: <20190517192956.18372-1-john@phrozen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Signed-off-by: John Crispin <john@phrozen.org>
---
 mgmt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mgmt.c b/mgmt.c
index 60f544b..88fe3fd 100644
--- a/mgmt.c
+++ b/mgmt.c
@@ -69,9 +69,11 @@ static int register_mgmt_frame(struct nl80211_state *state,
 	NLA_PUT_U16(msg, NL80211_ATTR_FRAME_TYPE, type);
 	NLA_PUT(msg, NL80211_ATTR_FRAME_MATCH, match_len, match);
 
+	free(match);
 	return 0;
 
 nla_put_failure:
+	free(match);
 	return -ENOBUFS;
 }
 
-- 
2.20.1

