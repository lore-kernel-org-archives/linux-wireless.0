Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:60094 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751665AbeEROrF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 10:47:05 -0400
Received: from mail-io0-f199.google.com ([209.85.223.199])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1fJgeu-0006XO-Hn
        for linux-wireless@vger.kernel.org; Fri, 18 May 2018 14:47:04 +0000
Received: by mail-io0-f199.google.com with SMTP id s12-v6so5279597ioc.20
        for <linux-wireless@vger.kernel.org>; Fri, 18 May 2018 07:47:04 -0700 (PDT)
From: Seth Forshee <seth.forshee@canonical.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wireless-regdb: Fix comparison of WmmRule with NoneType in python 3
Date: Fri, 18 May 2018 09:47:01 -0500
Message-Id: <20180518144701.25138-1-seth.forshee@canonical.com> (sfid-20180518_164708_524837_BDF810C0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Python 3 gives errors as a result of the changes to add wmm
rules since Permission.wmmrule can be set to None:

 TypeError: '<' not supported between instances of 'WmmRule' and 'NoneType'

To fix this, supply compairson methods for WmmRule instead of
using the ones provided by attrs. Doing this means we also need
to supply a __hash__ method.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 dbparse.py | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/dbparse.py b/dbparse.py
index 5cb8b3f13266..5fe752b4ff31 100755
--- a/dbparse.py
+++ b/dbparse.py
@@ -32,7 +32,7 @@ dfs_regions = {
 
 @total_ordering
 
-@attr.s(frozen=True)
+@attr.s(frozen=True, cmp=False)
 class WmmRule(object):
     vo_c = attr.ib()
     vi_c = attr.ib()
@@ -47,6 +47,22 @@ class WmmRule(object):
         return (self.vo_c, self.vi_c, self.be_c, self.bk_c,
                 self.vo_ap, self.vi_ap, self.be_ap, self.bk_ap)
 
+    def __eq__(self, other):
+        if other is None:
+            return False
+        return (self._as_tuple() == other._as_tuple())
+
+    def __ne__(self, other):
+        return not (self == other)
+
+    def __lt__(self, other):
+        if other is None:
+            return False
+        return (self._as_tuple() < other._as_tuple())
+
+    def __hash__(self):
+        return hash(self._as_tuple())
+
 class FreqBand(object):
     def __init__(self, start, end, bw, comments=None):
         self.start = start
-- 
2.17.0
