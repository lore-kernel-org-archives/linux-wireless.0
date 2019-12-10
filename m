Return-Path: <SRS0=GVYC=2A=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 028B6C43603
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Dec 2019 14:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C57A420637
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Dec 2019 14:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfLJOoN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 10 Dec 2019 09:44:13 -0500
Received: from smail.rz.tu-ilmenau.de ([141.24.186.67]:44990 "EHLO
        smail.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727480AbfLJOoN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Dec 2019 09:44:13 -0500
Received: from isengard.tu-ilmenau.de (unknown [141.24.207.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smail.rz.tu-ilmenau.de (Postfix) with ESMTPSA id 6D9B5580074;
        Tue, 10 Dec 2019 15:44:11 +0100 (CET)
From:   Markus Theil <markus.theil@tu-ilmenau.de>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Markus Theil <markus.theil@tu-ilmenau.de>
Subject: [PATCH] iw: event: add sta opmode changed command
Date:   Tue, 10 Dec 2019 15:43:56 +0100
Message-Id: <20191210144356.15377-1-markus.theil@tu-ilmenau.de>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Parsing this command helps tracking num spatial stream
and bandwidth changes.

Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
---
 event.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/event.c b/event.c
index 0cedeb9..7600781 100644
--- a/event.c
+++ b/event.c
@@ -708,6 +708,32 @@ static void parse_set_interface(struct nlattr **attrs)
 	printf("\n");
 }
 
+static void parse_sta_opmode_changed(struct nlattr **attrs)
+{
+	char macbuf[ETH_ALEN*3];
+
+	printf("sta opmode changed");
+
+	if (attrs[NL80211_ATTR_MAC]) {
+		mac_addr_n2a(macbuf, nla_data(attrs[NL80211_ATTR_MAC]));
+		printf(" %s", macbuf);
+	}
+
+	if (attrs[NL80211_ATTR_SMPS_MODE]) {
+		printf(" smps mode %i", nla_get_u8(attrs[NL80211_ATTR_SMPS_MODE]));
+	}
+
+	if (attrs[NL80211_ATTR_CHANNEL_WIDTH]) {
+		printf(" chan width %i", nla_get_u8(attrs[NL80211_ATTR_CHANNEL_WIDTH]));
+	}
+
+	if (attrs[NL80211_ATTR_NSS]) {
+		printf(" nss %i", nla_get_u8(attrs[NL80211_ATTR_NSS]));
+	}
+
+	printf("\n");
+}
+
 static int print_event(struct nl_msg *msg, void *arg)
 {
 	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
@@ -1055,6 +1081,10 @@ static int print_event(struct nl_msg *msg, void *arg)
 		parse_set_interface(tb);
 		break;
 	}
+	case NL80211_CMD_STA_OPMODE_CHANGED: {
+		parse_sta_opmode_changed(tb);
+		break;
+	}
 	default:
 		printf("unknown event %d (%s)\n",
 		       gnlh->cmd, command_name(gnlh->cmd));
-- 
2.24.0

