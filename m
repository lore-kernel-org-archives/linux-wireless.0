Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8A43C4361B
	for <linux-wireless@archiver.kernel.org>; Sun,  6 Dec 2020 10:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9281722D2C
	for <linux-wireless@archiver.kernel.org>; Sun,  6 Dec 2020 10:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbgLFKRg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 6 Dec 2020 05:17:36 -0500
Received: from smail.rz.tu-ilmenau.de ([141.24.186.67]:50195 "EHLO
        smail.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbgLFKRf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 6 Dec 2020 05:17:35 -0500
Received: from isengard.fritz.box (unknown [87.147.53.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smail.rz.tu-ilmenau.de (Postfix) with ESMTPSA id 4151F58007E;
        Sun,  6 Dec 2020 11:16:54 +0100 (CET)
From:   Markus Theil <markus.theil@tu-ilmenau.de>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Markus Theil <markus.theil@tu-ilmenau.de>
Subject: [PATCH] iw: print ctrl port tx status event
Date:   Sun,  6 Dec 2020 11:16:42 +0100
Message-Id: <20201206101642.3606-1-markus.theil@tu-ilmenau.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
---
 event.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/event.c b/event.c
index 8dd4345..61395f8 100644
--- a/event.c
+++ b/event.c
@@ -1171,6 +1171,11 @@ static int print_event(struct nl_msg *msg, void *arg)
 			(unsigned long long)nla_get_u64(tb[NL80211_ATTR_COOKIE]),
 			tb[NL80211_ATTR_ACK] ? "acked" : "no ack");
 		break;
+	case NL80211_CMD_CONTROL_PORT_FRAME_TX_STATUS:
+		printf("ctrl. port TX status (cookie %llx): %s\n",
+			(unsigned long long)nla_get_u64(tb[NL80211_ATTR_COOKIE]),
+			tb[NL80211_ATTR_ACK] ? "acked" : "no ack");
+		break;
 	case NL80211_CMD_PMKSA_CANDIDATE:
 		printf("PMKSA candidate found\n");
 		break;
-- 
2.29.2

