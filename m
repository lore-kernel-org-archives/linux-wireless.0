Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F50EC677E8
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 16:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C58A52084D
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 16:03:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C58A52084D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hauke-m.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbeJFXHI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 19:07:08 -0400
Received: from mx2.mailbox.org ([80.241.60.215]:28636 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725266AbeJFXHI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 19:07:08 -0400
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx2.mailbox.org (Postfix) with ESMTPS id 6BFFD406F8;
        Sat,  6 Oct 2018 18:03:14 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id Bhk4KKAZbuQ3; Sat,  6 Oct 2018 18:03:13 +0200 (CEST)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     seth.forshee@canonical.com
Cc:     haim.dreyfuss@intel.com, linux-wireless@vger.kernel.org,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] wireless-regdb: remove dependency to python attr
Date:   Sat,  6 Oct 2018 18:02:54 +0200
Message-Id: <20181006160254.7980-1-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Commit 8607edfdb6568 ("wireless-regdb: Parse wmm rule data") introduced
a dependency to the python module attr which is not included by default
in all python installations. Replace the code with manually coding the
constructor instead of using attr. This makes the code also work on
systems without attr.

I would like to avoid an additional dependency in OpenWrt where we
compile the regulatory database inside of the build system.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 dbparse.py | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/dbparse.py b/dbparse.py
index 5fe752b..993f757 100755
--- a/dbparse.py
+++ b/dbparse.py
@@ -5,7 +5,6 @@ from functools import total_ordering
 import sys, math
 from math import ceil, log
 from collections import defaultdict, OrderedDict
-import attr
 
 # must match <linux/nl80211.h> enum nl80211_reg_rule_flags
 
@@ -32,16 +31,17 @@ dfs_regions = {
 
 @total_ordering
 
-@attr.s(frozen=True, cmp=False)
 class WmmRule(object):
-    vo_c = attr.ib()
-    vi_c = attr.ib()
-    be_c = attr.ib()
-    bk_c = attr.ib()
-    vo_ap = attr.ib()
-    vi_ap = attr.ib()
-    be_ap = attr.ib()
-    bk_ap = attr.ib()
+
+    def __init__(self, vo_c, vi_c, be_c, bk_c, vo_ap, vi_ap, be_ap, bk_ap):
+        self.vo_c = vo_c
+        self.vi_c = vi_c
+        self.be_c = be_c
+        self.bk_c = bk_c
+        self.vo_ap = vo_ap
+        self.vi_ap = vi_ap
+        self.be_ap = be_ap
+        self.bk_ap = bk_ap
 
     def _as_tuple(self):
         return (self.vo_c, self.vi_c, self.be_c, self.bk_c,
-- 
2.11.0

