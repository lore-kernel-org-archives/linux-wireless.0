Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:54897 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbaAXWqt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 17:46:49 -0500
Received: by mail-pb0-f43.google.com with SMTP id md12so3741537pbc.16
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 14:46:49 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 02/11] rel-html: change default file extension to tar.xz
Date: Fri, 24 Jan 2014 14:46:24 -0800
Message-Id: <1390603593-27728-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20140124_234652_921524_8CFB55BC)
In-Reply-To: <1390603593-27728-1-git-send-email-mcgrof@do-not-panic.com>
References: <1390603593-27728-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The kernel.org server is now not dumping out tar.bz2 files
so embrace their practice for preference for relying on tar.xz
tarballs. You can always override the extension with the
release_extension attribute, see the project file for hostapd
projects/hostapd.cfg as an example.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 rel-html.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rel-html.py b/rel-html.py
index c563280..d787b92 100755
--- a/rel-html.py
+++ b/rel-html.py
@@ -764,7 +764,7 @@ class index_parser(HTMLParser):
             self.release_extension = "." + \
                 self.config.get("project", "release_extension")
         else:
-            self.release_extension = ".tar.bz2"
+            self.release_extension = ".tar.xz"
 
         self.next_rel_day = 0
         self.next_rel_month = 0
-- 
1.8.5.2

