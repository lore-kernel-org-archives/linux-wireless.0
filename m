Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1350C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 17:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF1D520818
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 17:10:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cR4GtMpf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF1D520818
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbeKJCve (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 21:51:34 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43549 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727961AbeKJCve (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 21:51:34 -0500
Received: by mail-wr1-f65.google.com with SMTP id y3-v6so2642282wrh.10
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2018 09:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bFBjKgQGl0cRNFwN3OT7IPyacTUidwjy0UJ+CuB04T0=;
        b=cR4GtMpfByhcVDn6hVQB8o2xMkAR5KFzWXu0tRIiNh+4cJjKo4rD1loBMlMvalDRq3
         ovsKCerWtkA5L8YvijMAzmBwkUE9spZj+y9VXNhoQsNrAFm0ZLHNK0v+5F7PZ4HcBoyF
         Elfsk2DurLDxYhj9WpyvaXzeW7gIsrI4RkgHwgwWVanQSLIwGlD7rJlHFQxjrLVoubbb
         lBI+b5unkpgnzeXeaeGZIp39rdup1FoG5ahfG1ZOXyoEg05VG1T2LQUj0LWZ8Kbz++Ky
         aVfYdRo6s5piivKk5b/Z0zNVkLezAJgj22pXfRgTwT2oNxW07A+To15uY7xEZvl7pJA8
         jVAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bFBjKgQGl0cRNFwN3OT7IPyacTUidwjy0UJ+CuB04T0=;
        b=OaSNzL3G4bwF4Q9MqdX8zSLNd3Om+rMmRz2M41v3wE/ztZAkSYQXENNsucEQjeKh5u
         hQvUBnkQMsx4e4MP/5Wiu3wlp6WYZ4CNLumVZO7xFJLEJF9d7IrJfzmja0AXYDl1WqYR
         4PcF+0wVYvR9PHz/FO2oi9XN1VjY+3rbCx1QniEevKqNWP4dCfor/H8klTcxMyxEFY8D
         D5K3vCy7mPqSAdY1oLSOhpp5kLO/oB8Vh4aeNAGwU7LJBbzDVy2dY+xGx0WsWUQI+DC/
         QauikSnBV/SPfFmaWxtXOprnr+MLjzndMZEQzk1YnUDEp6/FoNUK1q8mTOIpp/ddVJI3
         uWcA==
X-Gm-Message-State: AGRZ1gInDXM1QljTsxyvIe+AZ3/tJE3rHko2vYbhMMRRbLrN122oq+LA
        7u/2Rn2gfir78n3u3xbkuYUwRHQ=
X-Google-Smtp-Source: AJdET5dSw5EplIFbLpJQg3weipOEdNbICMoAbjUsqw9ACfJDxmplRSuRshv2jgc7/gFwCczAwiAlpw==
X-Received: by 2002:adf:fb12:: with SMTP id c18-v6mr8947935wrr.200.1541783405177;
        Fri, 09 Nov 2018 09:10:05 -0800 (PST)
Received: from localhost (1.red-83-37-105.dynamicip.rima-tde.net. [83.37.105.1])
        by smtp.gmail.com with ESMTPSA id p7-v6sm7819988wrs.23.2018.11.09.09.10.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Nov 2018 09:10:04 -0800 (PST)
From:   Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc:     Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        WIRELESS ML <linux-wireless@vger.kernel.org>,
        REGDB ML <wireless-regdb@lists.infradead.org>
Subject: [PATCH] wireless-regdb: add URLs in README
Date:   Fri,  9 Nov 2018 18:10:03 +0100
Message-Id: <20181109171003.27069-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: WIRELESS ML <linux-wireless@vger.kernel.org>
Cc: REGDB ML <wireless-regdb@lists.infradead.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/README b/README
index 4028223..4a059de 100644
--- a/README
+++ b/README
@@ -1,3 +1,7 @@
+ wireless-regdb
+================
+<https://wireless.wiki.kernel.org/en/developers/regulatory/wireless-regdb>
+
 This repository contains the plain text version of the regulatory
 database file I maintain for use with Central Regulatory Database
 Agent daemon.  Also included is the compiled binary version of this
@@ -9,6 +13,7 @@ either expressed or implied.
 Also included are the tools used to compile and sign the regulatory.bin
 file as well as a MoinMoin macro used for viewing the database.
 
+
  TECHNICAL INFORMATION
 =======================
 
@@ -21,9 +26,13 @@ to allow viewing the database for verification.
 The dbparse module is also used by db2bin.py and db2fw.py, the `compilers'
 that compile the database to its binary formats.
 
-For more information, please see the CRDA git repository:
+For more information, please see the CRDA page:
+
+	https://wireless.wiki.kernel.org/en/developers/regulatory/crda
+
+and the full description of the Linux regulatory stack:
 
-	git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/crda.git
+	https://wireless.wiki.kernel.org/en/developers/regulatory
 
 John W. Linville
 17 November 2008
-- 
2.19.1

