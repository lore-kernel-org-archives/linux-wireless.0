Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:35148 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750975AbeERRR3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 13:17:29 -0400
Received: from mail-io0-f198.google.com ([209.85.223.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1fJj0S-0006V4-FV
        for linux-wireless@vger.kernel.org; Fri, 18 May 2018 17:17:28 +0000
Received: by mail-io0-f198.google.com with SMTP id f9-v6so5717135iob.14
        for <linux-wireless@vger.kernel.org>; Fri, 18 May 2018 10:17:28 -0700 (PDT)
From: Seth Forshee <seth.forshee@canonical.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wireless-regdb: Fix iteration in create_wmms() for python 3
Date: Fri, 18 May 2018 12:17:25 -0500
Message-Id: <20180518171725.28828-1-seth.forshee@canonical.com> (sfid-20180518_191733_399278_1836BC7B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The iteration in this function is over countries.itervalues(),
which is not compatible with python 3. Switch to iterating over
contries.values() instead.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 db2fw.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db2fw.py b/db2fw.py
index 269325604ea3..0c0f030c0c63 100755
--- a/db2fw.py
+++ b/db2fw.py
@@ -29,7 +29,7 @@ def create_collections(countries):
 
 def create_wmms(countries):
     result = {}
-    for c in countries.itervalues():
+    for c in countries.values():
         for rule in c.permissions:
             if rule.wmmrule is not None:
                 result[rule.wmmrule] = 1
-- 
2.17.0
