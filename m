Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A362AC169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 17:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 721A2218A4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 17:04:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="F/yyxudr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbfBKREj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 12:04:39 -0500
Received: from mail.toke.dk ([52.28.52.200]:47033 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728640AbfBKREh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 12:04:37 -0500
Subject: [PATCH 3/3] iw: Print airtime fairness feature
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1549904675; bh=zdN5I5K73u7dELp6JvRfvfXDJn2pR63cxAxFm4vrb6U=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=F/yyxudrtdZm/p+r/IQYYPmeJyc3/tJSlKQGcT7Ynd9dZH1/uR9WbYUMOQOWXr4UK
         bMjwBqBPvJsDPyYqFC2dv0VXLyFNddM/9BBJlp3NOC2vzxELOKrpHfuBdq+U1IOdXC
         TpaYVaO1Z8q4qG5TlOuXekZHbgC2TF+3DzfXEPqbIoAKE0QHiy0EsgElmGbrL/lY8N
         8Wbeukrfqz0uDJmWDrk6JkwQDbnvwgJJ+ID6M+WuOG/gkXo8RZTEltyfwSryO6yQyP
         rDFG1ovMMRErTkWW1Ih3UbeRIRJQWd3X8RWCL5nx5apgFZmNoUA8vhF7uGuYcf6Jm3
         HV5t2EbHmBekQ==
From:   Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To:     linux-wireless@vger.kernel.org
Date:   Mon, 11 Feb 2019 18:04:34 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <154990467416.6770.1883292163406897027.stgit@alrua-x1>
In-Reply-To: <154990467406.6770.8841156470323507480.stgit@alrua-x1>
References: <154990467406.6770.8841156470323507480.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This adds printing of the newly introduced airtime fairness EXT_FEATURE
flag to iw.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 info.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/info.c b/info.c
index f1a25da..92c7d1d 100644
--- a/info.c
+++ b/info.c
@@ -694,6 +694,8 @@ broken_combination:
 			       "control port over nl80211");
 		ext_feat_print(tb, NL80211_EXT_FEATURE_TXQS,
 			       "TXQS", "FQ-CoDel-enabled intermediate TXQs");
+		ext_feat_print(tb, NL80211_EXT_FEATURE_AIRTIME_FAIRNESS,
+			       "AIRTIME_FAIRNESS", "airtime fairness scheduling");
 	}
 
 	if (tb_msg[NL80211_ATTR_COALESCE_RULE]) {

