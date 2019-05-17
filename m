Return-Path: <SRS0=tPxB=TR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25D95C04E87
	for <linux-wireless@archiver.kernel.org>; Fri, 17 May 2019 19:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED1F8216FD
	for <linux-wireless@archiver.kernel.org>; Fri, 17 May 2019 19:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbfEQTad (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 17 May 2019 15:30:33 -0400
Received: from nbd.name ([46.4.11.11]:37378 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728958AbfEQTa3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 May 2019 15:30:29 -0400
Received: from p548c8c9f.dip0.t-ipconnect.de ([84.140.140.159] helo=bertha.fritz.box)
        by ds12 with esmtpa (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hRiYl-0006cc-Km; Fri, 17 May 2019 21:30:27 +0200
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, John Crispin <john@phrozen.org>
Subject: [PATCH 3/7] iw: fix memory leak inside handle_cac
Date:   Fri, 17 May 2019 21:29:52 +0200
Message-Id: <20190517192956.18372-4-john@phrozen.org>
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
 phy.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/phy.c b/phy.c
index 77df7a7..a4425ea 100644
--- a/phy.c
+++ b/phy.c
@@ -328,12 +328,15 @@ static int handle_cac(struct nl80211_state *state,
 	} else if (strcmp(argv[2], "freq") == 0) {
 		err = parse_freqchan(&chandef, false, argc - 3, argv + 3, NULL);
 	} else {
-		return 1;
+		err = 1;
+		goto err_out;
 	}
 
 	cac_trigger_argv = calloc(argc + 1, sizeof(char*));
-	if (!cac_trigger_argv)
-		return -ENOMEM;
+	if (!cac_trigger_argv) {
+		err = -ENOMEM;
+		goto err_out;
+	}
 
 	cac_trigger_argv[0] = argv[0];
 	cac_trigger_argv[1] = "cac";
@@ -341,9 +344,8 @@ static int handle_cac(struct nl80211_state *state,
 	memcpy(&cac_trigger_argv[3], &argv[2], (argc - 2) * sizeof(char*));
 
 	err = handle_cmd(state, id, argc + 1, cac_trigger_argv);
-	free(cac_trigger_argv);
 	if (err)
-		return err;
+		goto err_out;
 
 	cac_event.ret = 1;
 	cac_event.freq = chandef.control_freq;
@@ -357,7 +359,13 @@ static int handle_cac(struct nl80211_state *state,
 	while (cac_event.ret > 0)
 		nl_recvmsgs(state->nl_sock, radar_cb);
 
-	return 0;
+	err = 0;
+err_out:
+	if (radar_cb)
+		nl_cb_put(radar_cb);
+	if (cac_trigger_argv)
+		free(cac_trigger_argv);
+	return err;
 }
 TOPLEVEL(cac, "channel <channel> [NOHT|HT20|HT40+|HT40-|5MHz|10MHz|80MHz]\n"
 	      "freq <freq> [NOHT|HT20|HT40+|HT40-|5MHz|10MHz|80MHz]\n"
-- 
2.20.1

