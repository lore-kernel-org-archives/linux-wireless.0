Return-Path: <SRS0=tPxB=TR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B4FC04E87
	for <linux-wireless@archiver.kernel.org>; Fri, 17 May 2019 19:30:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDD3E216FD
	for <linux-wireless@archiver.kernel.org>; Fri, 17 May 2019 19:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbfEQTaa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 17 May 2019 15:30:30 -0400
Received: from nbd.name ([46.4.11.11]:37398 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728951AbfEQTaa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 May 2019 15:30:30 -0400
Received: from p548c8c9f.dip0.t-ipconnect.de ([84.140.140.159] helo=bertha.fritz.box)
        by ds12 with esmtpa (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hRiYm-0006cc-PZ; Fri, 17 May 2019 21:30:28 +0200
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, John Crispin <john@phrozen.org>
Subject: [PATCH 6/7] iw: fix memory leaks inside handle_scan
Date:   Fri, 17 May 2019 21:29:55 +0200
Message-Id: <20190517192956.18372-7-john@phrozen.org>
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
 scan.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/scan.c b/scan.c
index 980bfb4..6ad3ad4 100644
--- a/scan.c
+++ b/scan.c
@@ -389,7 +389,7 @@ static int handle_scan(struct nl80211_state *state,
 	bool passive = false, have_ssids = false, have_freqs = false;
 	bool duration_mandatory = false;
 	size_t ies_len = 0, meshid_len = 0;
-	unsigned char *ies = NULL, *meshid = NULL, *tmpies;
+	unsigned char *ies = NULL, *meshid = NULL, *tmpies = NULL;
 	unsigned int flags = 0;
 
 	ssids = nlmsg_alloc();
@@ -450,7 +450,8 @@ static int handle_scan(struct nl80211_state *state,
 		case DONE:
 			nlmsg_free(ssids);
 			nlmsg_free(freqs);
-			return 1;
+			err = 1;
+			goto nla_put_failure;
 		case FREQ:
 			freq = strtoul(argv[i], &eptr, 10);
 			if (eptr != argv[i] + strlen(argv[i])) {
@@ -462,6 +463,8 @@ static int handle_scan(struct nl80211_state *state,
 			NLA_PUT_U32(freqs, i, freq);
 			break;
 		case IES:
+			if (ies)
+				free(ies);
 			ies = parse_hex(argv[i], &ies_len);
 			if (!ies)
 				goto nla_put_failure;
@@ -490,24 +493,14 @@ static int handle_scan(struct nl80211_state *state,
 
 	if (ies || meshid) {
 		tmpies = (unsigned char *) malloc(ies_len + meshid_len);
-		if (!tmpies) {
-			free(ies);
-			free(meshid);
+		if (!tmpies)
 			goto nla_put_failure;
-		}
-		if (ies) {
+		if (ies)
 			memcpy(tmpies, ies, ies_len);
-			free(ies);
-		}
-		if (meshid) {
+		if (meshid)
 			memcpy(&tmpies[ies_len], meshid, meshid_len);
-			free(meshid);
-		}
-		if (nla_put(msg, NL80211_ATTR_IE, ies_len + meshid_len, tmpies) < 0) {
-			free(tmpies);
+		if (nla_put(msg, NL80211_ATTR_IE, ies_len + meshid_len, tmpies) < 0)
 			goto nla_put_failure;
-		}
-		free(tmpies);
 	}
 
 	if (!have_ssids)
@@ -535,6 +528,12 @@ static int handle_scan(struct nl80211_state *state,
  nla_put_failure:
 	nlmsg_free(ssids);
 	nlmsg_free(freqs);
+	if (meshid)
+		free(meshid);
+	if (ies)
+		free(ies);
+	if (tmpies)
+		free(tmpies);
 	return err;
 }
 
-- 
2.20.1

