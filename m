Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:44425 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaAXWrL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 17:47:11 -0500
Received: by mail-pd0-f182.google.com with SMTP id v10so3610387pde.41
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 14:47:11 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 07/11] rel-html: revise stable releases prior to display
Date: Fri, 24 Jan 2014 14:46:29 -0800
Message-Id: <1390603593-27728-8-git-send-email-mcgrof@do-not-panic.com> (sfid-20140124_234716_040890_A109B5A9)
In-Reply-To: <1390603593-27728-1-git-send-email-mcgrof@do-not-panic.com>
References: <1390603593-27728-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rel-html currently will look for each supported release tag
on earch base URL it enters and if it finds any major release
it'll eventually display it. This is displaying some old
stable releases on supported releases which have sublevels
on the releases. This adds a sanity check on the releases
that revises the weights of each release against the supplied
release tags.

The final stable releases shown are only the releases that
have the *max weight* for the supplied supported release tags.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 rel-html.py | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/rel-html.py b/rel-html.py
index ae61187..95d4877 100755
--- a/rel-html.py
+++ b/rel-html.py
@@ -358,6 +358,12 @@ class index_tarball_hunter(HTMLParser):
         p = re.compile(index_parser.release_extension + '$')
         rel_name = p.sub("", value)
 
+        base_release = ''
+        for r in index_parser.supported:
+            if (r in value):
+                base_release = r
+                break
+
         ver = rel_name.lstrip(rel_match['rel_name'] + '-')
 
         p = re.compile('-[usnpc]*$')
@@ -378,6 +384,7 @@ class index_tarball_hunter(HTMLParser):
             return
 
         tar = dict(version=short_ver,
+                   base_release=r,
                    weight=w,
                    rel=rel_name,
                    specifics=rel_specifics,
@@ -463,10 +470,27 @@ class index_tarball_hunter(HTMLParser):
                               specifics['RELMOD_UPDATE'],
                               specifics['RELMOD_TYPE']))
 
+    def is_biggest_tarball(self, pivot_tar, tars):
+        other_greater = 0
+        for tar in tars:
+            if pivot_tar.get('rel') == tar.get('rel'):
+                continue
+            if pivot_tar.get('base_release') == tar.get('base_release'):
+                if pivot_tar.get('weight') < tar.get('weight'):
+                    other_greater = other_greater + 1
+
+        if (other_greater == 0):
+            return True
+
+        return False
+
     def update_rel_candidates(self):
         index_parser = self.index_parser
         for tar in self.tarballs:
             index_parser.rel_html_rels.append(tar)
+        for tar in index_parser.rel_html_rels:
+            if not self.is_biggest_tarball(tar, index_parser.rel_html_rels):
+                index_parser.rel_html_rels.remove(tar)
 
     def is_next_rel(self, value):
         index_parser = self.index_parser
-- 
1.8.5.2

