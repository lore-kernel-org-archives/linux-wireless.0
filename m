Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE68C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 23:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 497FB2077B
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 23:18:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=4sigma.it header.i=@4sigma.it header.b="LG+iFrXb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbfBUXSR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 18:18:17 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]:50655 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbfBUXSR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 18:18:17 -0500
Received: by mail-wm1-f41.google.com with SMTP id x7so290182wmj.0
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 15:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=4sigma.it; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=SHCZcq75JOjWtrMf+pQpsXLfYDUgVS1o2/f5AgqqKD8=;
        b=LG+iFrXbVLjNQLuJt483bCVScUby4RrnHRLQQhjt81ZpH5HNRlR1L535loTx2oai1L
         ohF8YxD41sf5zrs97f4NNNdgOWaTJEn8qx3KUpYw7oWVo/IPjfCX4XpN4ihZGq/S7q7I
         AiRV/FJFPQDRXbTaMk7tx9MeU9PPrBhDZ4GRU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SHCZcq75JOjWtrMf+pQpsXLfYDUgVS1o2/f5AgqqKD8=;
        b=Bi5ye4imBumcrflPkvbOjNdmnr5sxQNxXcY379MMN1/77JdfXErFpbmMtsQXtSzhvn
         qJNB0os/OvcjWSWyAAKnE/MK7GmVmJ7EoLUt4McbZEZs3xYcVTwyK9x3htxxLsgyLERd
         IIA6ysaUKSN257hpUrmi225Ks/a3dkLuFmDWJ6/sQV4V8WoXt/Ji7B6XGc1uz/b94eW+
         p6RBDlkIBnE3qbPQfb8wpmh9DcvGs1oJmPii2Lm1zkkyoSFJvAjmyFzdhStLfbE5sxQF
         HbKcOKRz2WnOVznu7KLkDqce8IT9yDLJxz6kiMXATd+tQ2wlHi8FPeApdnC9cnNB5Yj3
         IbvA==
X-Gm-Message-State: AHQUAubDIMh7qpynrAIOqzyw8Rz2ZlmVHxqGqWRZYkZRhIx/WYk5GnEo
        x5KQ02p29osHyDO3Vqb5v56/aNEaZimREw==
X-Google-Smtp-Source: AHgI3IbSoUN9draoKPsGf2xoCoD86bj76LnaiUdCe7X+8jD5+CnqOiUOiesYAXjfs2lJD3pM+pvIzQ==
X-Received: by 2002:a1c:9acd:: with SMTP id c196mr518885wme.145.1550791095272;
        Thu, 21 Feb 2019 15:18:15 -0800 (PST)
Received: from localhost.localdomain (host121-71-dynamic.24-79-r.retail.telecomitalia.it. [79.24.71.121])
        by smtp.googlemail.com with ESMTPSA id 132sm316249wmd.27.2019.02.21.15.18.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 Feb 2019 15:18:14 -0800 (PST)
From:   Andrea Greco <a.greco@4sigma.it>
X-Google-Original-From: Andrea Greco <andrea.greco.gapmilano@gmail.com>
To:     johannes@sipsolutions.net
Cc:     johannes.berg@intel.com, linux-wireless@vger.kernel.org,
        Andrea Greco <a.greco@4sigma.it>
Subject: [PATCH] iw: allow to set wmm parameters from iw
Date:   Fri, 22 Feb 2019 00:18:07 +0100
Message-Id: <20190221231807.6969-1-andrea.greco.gapmilano@gmail.com>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Andrea Greco <a.greco@4sigma.it>

---
 phy.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/phy.c b/phy.c
index 77df7a7..3154754 100644
--- a/phy.c
+++ b/phy.c
@@ -843,3 +843,83 @@ static int handle_get_txq(struct nl80211_state *state,
 COMMAND(get, txq, "",
 	NL80211_CMD_GET_WIPHY, 0, CIB_PHY, handle_get_txq,
 	"Get TXQ parameters.");
+
+static int handle_wmm_params(struct nl80211_state *state,
+			     struct nl_msg *msg,
+			     int argc, char **argv,
+			     enum id_input id)
+{
+	char *end;
+	struct nlattr *txq, *params;
+	int queue, cw_min, cw_max, aifs, txop;
+
+	if (argc != 5)
+		return 1;
+
+	if (!strcmp(argv[0], "VO"))
+		queue = NL80211_TXQ_Q_VO;
+	else if (!strcmp(argv[0], "VI"))
+		queue = NL80211_TXQ_Q_VI;
+	else if (!strcmp(argv[0], "BK"))
+		queue = NL80211_TXQ_Q_BK;
+	else if (!strcmp(argv[0], "BE"))
+		queue = NL80211_TXQ_Q_BE;
+	else {
+		printf("Invalid parameter: %s\n", argv[0]);
+		return 2;
+	}
+
+	if (!*argv[1] || !*argv[2] || !*argv[3] || !*argv[4])
+		return 1;
+
+	cw_min = strtoul(argv[1], &end, 0);
+	if (*end)
+		return 1;
+
+	cw_max = strtoul(argv[2], &end, 0);
+	if (*end)
+		return 1;
+
+	aifs = strtoul(argv[3], &end, 0);
+	if (*end)
+		return 1;
+
+	txop = strtoul(argv[4], &end, 0);
+	if (*end)
+		return 1;
+
+	txq = nla_nest_start(msg, NL80211_ATTR_WIPHY_TXQ_PARAMS);
+	if (!txq) {
+		goto nla_put_failure;
+	}
+
+	params = nla_nest_start(msg, 1);
+	if (!params) {
+		goto nla_put_failure;
+	}
+
+	NLA_PUT_U8(msg, NL80211_TXQ_ATTR_QUEUE, queue);
+	NLA_PUT_U16(msg, NL80211_TXQ_ATTR_CWMIN, cw_min);
+	NLA_PUT_U16(msg, NL80211_TXQ_ATTR_CWMAX, cw_max);
+	NLA_PUT_U16(msg, NL80211_TXQ_ATTR_TXOP, txop);
+	NLA_PUT_U8(msg, NL80211_TXQ_ATTR_AIFS, aifs);
+
+	nla_nest_end(msg,params);
+	nla_nest_end(msg,txq);
+
+	printf("cw_min:%d, cw_max:%d txop:%d aifs:%d\n", cw_min, cw_max, txop, aifs);
+
+	return 0;
+
+ nla_put_failure:
+	return -ENOBUFS;
+}
+
+COMMAND(set, wmm_params, "<VO|VI|BE|BK> <cw_min> <cw_max> <aifs> <txop>",
+	NL80211_CMD_SET_WIPHY, 0, CIB_NETDEV, handle_wmm_params,
+	"Set WMM parameters for a queue (VO, VI, BE, or BK):\n"
+	" * cw_min/cw_max - contention window minimum/maximum\n"
+	"                   (a value of the form 2^n-1 in the range 1..32767)\n"
+	" * aifs - arbitration interframe spacing (0..255)\n"
+	" * txop - maximum burst time in units of 32 usecs, 0 meaning disabled\n"
+	);
-- 
2.17.2

