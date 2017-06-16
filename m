Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40363 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751689AbdFPD5b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 23:57:31 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 4/4] test: Add option to deactivate tag
Date: Thu, 15 Jun 2017 20:57:28 -0700
Message-Id: <20170616035728.19415-5-mgreer@animalcreek.com> (sfid-20170616_055745_116348_3F57C57A)
In-Reply-To: <20170616035728.19415-1-mgreer@animalcreek.com>
References: <20170616035728.19415-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the 'deactivate' option to test-tag which deactivates the
specified tag.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 test/test-tag | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/test/test-tag b/test/test-tag
index fd80132..cb2c9e8 100755
--- a/test/test-tag
+++ b/test/test-tag
@@ -11,6 +11,7 @@ def usage():
 	text = """
 list
 dump <tag>
+deactivate <tag>
 write <tag> <type> <...>
 
 	If type is Text, parameters are <encoding> <language> <representation>
@@ -165,5 +166,17 @@ if (sys.argv[1] == "write"):
 	else:
 		usage()
 
+	sys.exit(0)
+
+if (sys.argv[1] == "deactivate"):
+	print sys.argv[2]
+	if (len(sys.argv) != 2):
+		tag = neardutils.find_tag(sys.argv[2])
+		tag.Deactivate()
+	else:
+		usage()
+
+	sys.exit(0)
+
 else:
 	usage()
-- 
2.13.0
