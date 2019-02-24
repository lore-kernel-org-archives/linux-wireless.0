Return-Path: <SRS0=tIsG=Q7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F2B6C43381
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Feb 2019 15:26:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 214E720663
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Feb 2019 15:26:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=4sigma.it header.i=@4sigma.it header.b="FY952F3v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbfBXP0P (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 24 Feb 2019 10:26:15 -0500
Received: from mail-wm1-f49.google.com ([209.85.128.49]:34358 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfBXP0O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Feb 2019 10:26:14 -0500
Received: by mail-wm1-f49.google.com with SMTP id o10so1189083wmc.1
        for <linux-wireless@vger.kernel.org>; Sun, 24 Feb 2019 07:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=4sigma.it; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PDjsh9Ldc3hFBOgkykUt4r3l2vD0rJiagbFma9W7reA=;
        b=FY952F3v8VgGBeRv3V2e4muGtmi+8jYbiTJA+7WbE1tvBRUdg/zpoWUoZvtpiY5g0I
         fz/4lu3lAHk5ISIH0zy/gmLyBMjsK3iyWriqGyCDqpXL7R4kO3ABv3zDTKECF2t/atL0
         j2DlNptK58Svm7CWqwIA8m7j8otMyMRJu1doU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PDjsh9Ldc3hFBOgkykUt4r3l2vD0rJiagbFma9W7reA=;
        b=nFy5rxbVLV/+DzjrUzOMhVO8I7NWm0+o69bv6rcSl25js2VS6bUHn/pFFgsXseQyYK
         RJIh9yev2KySA+5/YSeMef2JoKAGw2niATYmgPPzgXZWNT9nrMVlHU4ovqOHOhQ38utD
         KUoq8QOz0PHolk0l0KQYGa+rCbZ4t3cWHLUZuRVAcQu91pVSIF1PhC/LBxcXdkiQjdMa
         gwzYgW9BxB2ccjVGU179AEa6Hljyii+ufL02TW1F8ej8/IZtq2CN4dLo5KCX8dhWZZdR
         JQsxyUicu68v19qCcrpoSFZICoZCR44qxICFzCVVeDu4N+sYR7ExHXpspbbCvzd3si0g
         ucIg==
X-Gm-Message-State: AHQUAuZSa0wjusF+1GeMAjv/KpyMMceRxQ4FjAzVssXgR9ErcCZy4TVI
        PKqoK5cT046KDXdP/oBZEkPI5qwWYug=
X-Google-Smtp-Source: AHgI3IZEnoT6Ma70QFhlavWT3b5MaW1i+xxMMXHorG5rUvkjm+oGeEvh+yNSGGpHZE91BcSHWaKmmg==
X-Received: by 2002:a7b:c413:: with SMTP id k19mr8286293wmi.75.1551021971771;
        Sun, 24 Feb 2019 07:26:11 -0800 (PST)
Received: from localhost.localdomain (host121-71-dynamic.24-79-r.retail.telecomitalia.it. [79.24.71.121])
        by smtp.googlemail.com with ESMTPSA id f7sm6315049wru.3.2019.02.24.07.26.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 24 Feb 2019 07:26:11 -0800 (PST)
From:   Andrea Greco <a.greco@4sigma.it>
X-Google-Original-From: Andrea Greco <andrea.greco.gapmilano@gmail.com>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Andrea Greco <a.greco@4sigma.it>
Subject: [PATCH v2] iw: allow to set wmm parameters from iw
Date:   Sun, 24 Feb 2019 16:25:46 +0100
Message-Id: <20190224152546.9755-1-andrea.greco.gapmilano@gmail.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <E1gx8bq-0000er-7g@sipsolutions.net>
References: <E1gx8bq-0000er-7g@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Andrea Greco <a.greco@4sigma.it>

Allow iw modify cw_min cw_max aifs txop

Signed-off-by: Andrea Greco <a.greco@4sigma.it>
---
Changelog:
  - Removed useless printf
 phy.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/phy.c b/phy.c
index 77df7a7..d723dde 100644
--- a/phy.c
+++ b/phy.c
@@ -843,3 +843,81 @@ static int handle_get_txq(struct nl80211_state *state,
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

