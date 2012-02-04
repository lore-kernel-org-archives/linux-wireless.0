Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60041 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab2BDB0E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 20:26:04 -0500
Received: by mail-pw0-f46.google.com with SMTP id u11so3334452pbd.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Feb 2012 17:26:04 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [RFC 04/11] crda: close fd upon leaving
Date: Fri,  3 Feb 2012 17:25:41 -0800
Message-Id: <1328318748-21044-5-git-send-email-mcgrof@frijolero.org> (sfid-20120204_022614_810142_9E8C5807)
In-Reply-To: <1328318748-21044-1-git-send-email-mcgrof@frijolero.org>
References: <1328318748-21044-1-git-send-email-mcgrof@frijolero.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was never done. Do this at the end for now but soon
this will be changed in preference for the file opening
only to be done by crda for checking which file to use
to pass on to reglib for usage.

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 crda.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/crda.c b/crda.c
index 1db54a5..5a1cd83 100644
--- a/crda.c
+++ b/crda.c
@@ -10,6 +10,7 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <arpa/inet.h>
+#include <unistd.h>
 
 #include <netlink/genl/genl.h>
 #include <netlink/genl/family.h>
@@ -333,5 +334,7 @@ nla_put_failure:
 	nlmsg_free(msg);
 out:
 	nl80211_cleanup(&nlstate);
+	close(fd);
+
 	return r;
 }
-- 
1.7.4.15.g7811d

