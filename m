Return-Path: <SRS0=tPxB=TR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47A75C072AF
	for <linux-wireless@archiver.kernel.org>; Fri, 17 May 2019 19:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2466521726
	for <linux-wireless@archiver.kernel.org>; Fri, 17 May 2019 19:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729033AbfEQTad (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 17 May 2019 15:30:33 -0400
Received: from nbd.name ([46.4.11.11]:37390 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728970AbfEQTa3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 May 2019 15:30:29 -0400
Received: from p548c8c9f.dip0.t-ipconnect.de ([84.140.140.159] helo=bertha.fritz.box)
        by ds12 with esmtpa (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hRiYm-0006cc-Fu; Fri, 17 May 2019 21:30:28 +0200
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, John Crispin <john@phrozen.org>
Subject: [PATCH 5/7] iw: fix memory leak inside parse_sched_scan
Date:   Fri, 17 May 2019 21:29:54 +0200
Message-Id: <20190517192956.18372-6-john@phrozen.org>
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
 scan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scan.c b/scan.c
index b0b7828..980bfb4 100644
--- a/scan.c
+++ b/scan.c
@@ -355,11 +355,12 @@ int parse_sched_scan(struct nl_msg *msg, int *argc, char ***argv)
 nla_put_failure:
 	if (match)
 		nla_nest_end(msg, match);
+out:
 	nlmsg_free(freqs);
 	nlmsg_free(matchset);
 	nlmsg_free(scan_plans);
+	nlmsg_free(ssids);
 
-out:
 	*argc = c;
 	*argv = v;
 	return err;
-- 
2.20.1

