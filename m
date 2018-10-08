Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B333C65C20
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 17:51:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 531182064E
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 17:51:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="VU31EoP+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 531182064E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbeJIBE2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 21:04:28 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38345 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbeJIBE1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 21:04:27 -0400
Received: by mail-pg1-f193.google.com with SMTP id f8-v6so1754689pgq.5
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2018 10:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=90O4pIvTELFsKTsz8g+Cwd1Kw+Qu5XmA1l345IEbUR8=;
        b=VU31EoP+6NrA4YA0dCGJNKriOhPUyyZIeJfPGz6NLlJaNFz8YsW4b+LM+PyQxEYO5n
         aecjT+u1YKeWyVNpcU4t3GUrA7HsWKe3XzFh233zU7AekJVZ4rKDes7ebTRPcn2dF8Jz
         TatqvQkMTj+0S2AwhilZvtSogK4uXA34wdCnM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=90O4pIvTELFsKTsz8g+Cwd1Kw+Qu5XmA1l345IEbUR8=;
        b=AS+EQc6wXmRtUBf0wnKK8VAnGedbvIgoesD+8fiqM7yTsnruZMoJwj0xYC3wBmeyjV
         YBhs0PHe2dXh3ElpNMd3WgXvlsATJqBUkY/pV+b3PrykNkPYBnrjk9gFoz20/v8ZWst6
         LsVnuy1bfOWDxdGKXegQUHfUXLjTGOxjwEj1U5tHl9qB1OkDmig0MzdN1/JROfaXiP5O
         kgvIu4WZtEulKUCqUqmSEV0PL2A2XwgxTPujq/B+OSJFA0i47Cu5O8gJQEe0F4VPGzcu
         19jKAB+AMViCf8Zl1eNbVRBkORRl33RT9uEMZ6vPzUnNxVSfmlobJqczFWmUdOO+hzdP
         JDsg==
X-Gm-Message-State: ABuFfohzydaHIB15+2w8lKaXDNDxBDP0HuRf0ZtNZMEPu6sSWwcZ+Xif
        faXOeQs1ipmTrHzl7Ytpz+mokt9ZYPTKkA==
X-Google-Smtp-Source: ACcGV62lScesfblWEsBk4jPCcAWF2dP8/oN1auDrpZG9qFf+44sPVi1N/4EaJnQwnu+OsbInO1/ElQ==
X-Received: by 2002:a63:4107:: with SMTP id o7-v6mr22358793pga.256.1539021096548;
        Mon, 08 Oct 2018 10:51:36 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id q127-v6sm18287522pgq.19.2018.10.08.10.51.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Oct 2018 10:51:35 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH iw] iw: fix enum warnings
Date:   Mon,  8 Oct 2018 10:51:26 -0700
Message-Id: <20181008175126.82965-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.19.0.605.g01d371f741-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

clang warns about the misuse of enums:

reg.c:246:26: warning: implicit conversion from enumeration type 'enum command_identify_by' to different enumeration type 'enum id_input' [-Wenum-conversion]
        err = handle_cmd(state, CIB_NONE, 2, dump_args);
              ~~~~~~~~~~        ^~~~~~~~
info.c:645:26: warning: implicit conversion from enumeration type 'enum command_identify_by' to different enumeration type 'enum id_input' [-Wenum-conversion]
        err = handle_cmd(state, CIB_NONE, 2, feat_args);
              ~~~~~~~~~~        ^~~~~~~~

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 info.c | 2 +-
 reg.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/info.c b/info.c
index fbf3ee095f9c..d0577e32552e 100644
--- a/info.c
+++ b/info.c
@@ -718,7 +718,7 @@ static int handle_info(struct nl80211_state *state,
 	char *feat_args[] = { "features", "-q" };
 	int err;
 
-	err = handle_cmd(state, CIB_NONE, 2, feat_args);
+	err = handle_cmd(state, II_NONE, 2, feat_args);
 	if (!err && nl80211_has_split_wiphy) {
 		nla_put_flag(msg, NL80211_ATTR_SPLIT_WIPHY_DUMP);
 		nlmsg_hdr(msg)->nlmsg_flags |= NLM_F_DUMP;
diff --git a/reg.c b/reg.c
index cadff3884c04..a2368df39009 100644
--- a/reg.c
+++ b/reg.c
@@ -243,7 +243,7 @@ static int handle_reg_get(struct nl80211_state *state,
 	char *dump_args[] = { "reg", "dump" };
 	int err;
 
-	err = handle_cmd(state, CIB_NONE, 2, dump_args);
+	err = handle_cmd(state, II_NONE, 2, dump_args);
 	/*
 	 * dump might fail since it's not supported on older kernels,
 	 * in that case the handler is still registered already
-- 
2.19.0.605.g01d371f741-goog

