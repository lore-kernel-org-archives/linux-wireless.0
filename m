Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:54262 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753199AbdLELCI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 06:02:08 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Paul Menzel <pmenzel+linux-wireless@molgen.mpg.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] wireless: don't write C files on failures
Date: Tue,  5 Dec 2017 12:02:04 +0100
Message-Id: <20171205110204.18579-2-johannes@sipsolutions.net> (sfid-20171205_120212_145137_FE29705F)
In-Reply-To: <20171205110204.18579-1-johannes@sipsolutions.net>
References: <20171205110204.18579-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Change the scripting inside the shipped/extra certs C code
generation to not write the file when there are any failures.
That way, if the build aborts due to failures, we don't get
into a situation where a dummy file has been created and the
next build succeeds, but not with the desired output.

Fixes: 90a53e4432b1 ("cfg80211: implement regdb signature checking")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/Makefile | 48 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 10 deletions(-)

diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index 63cbb6432b2d..d7d6cb00c47b 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -25,17 +25,45 @@ endif
 
 $(obj)/shipped-certs.c: $(wildcard $(srctree)/$(src)/certs/*.x509)
 	@$(kecho) "  GEN     $@"
-	@echo '#include "reg.h"' > $@
-	@echo 'const u8 shipped_regdb_certs[] = {' >> $@
-	@for f in $^ ; do od -An -v -tx1 < $$f | sed -e 's/ /\n/g' | sed -e 's/^[0-9a-f]\+$$/\0/;t;d' | sed -e 's/^/0x/;s/$$/,/' >> $@ ; done
-	@echo '};' >> $@
-	@echo 'unsigned int shipped_regdb_certs_len = sizeof(shipped_regdb_certs);' >> $@
+	@(set -e; \
+	  allf=""; \
+	  for f in $^ ; do \
+	      # similar to hexdump -v -e '1/1 "0x%.2x," "\n"' \
+	      thisf=$$(od -An -v -tx1 < $$f | \
+	                   sed -e 's/ /\n/g' | \
+	                   sed -e 's/^[0-9a-f]\+$$/\0/;t;d' | \
+	                   sed -e 's/^/0x/;s/$$/,/'); \
+	      # file should not be empty - maybe command substitution failed? \
+	      test ! -z "$$thisf";\
+	      allf=$$allf$$thisf;\
+	  done; \
+	  ( \
+	      echo '#include "reg.h"'; \
+	      echo 'const u8 shipped_regdb_certs[] = {'; \
+	      echo "$$allf"; \
+	      echo '};'; \
+	      echo 'unsigned int shipped_regdb_certs_len = sizeof(shipped_regdb_certs);'; \
+	  ) >> $@)
 
 $(obj)/extra-certs.c: $(CONFIG_CFG80211_EXTRA_REGDB_KEYDIR:"%"=%) \
 		      $(wildcard $(CONFIG_CFG80211_EXTRA_REGDB_KEYDIR:"%"=%)/*.x509)
 	@$(kecho) "  GEN     $@"
-	@echo '#include "reg.h"' > $@
-	@echo 'const u8 extra_regdb_certs[] = {' >> $@
-	@for f in $^ ; do test -f $$f && od -An -v -tx1 < $$f | sed -e 's/ /\n/g' | sed -e 's/^[0-9a-f]\+$$/\0/;t;d' | sed -e 's/^/0x/;s/$$/,/' >> $@ ; done
-	@echo '};' >> $@
-	@echo 'unsigned int extra_regdb_certs_len = sizeof(extra_regdb_certs);' >> $@
+	@(set -e; \
+	  allf=""; \
+	  for f in $^ ; do \
+	      # similar to hexdump -v -e '1/1 "0x%.2x," "\n"' \
+	      thisf=$$(od -An -v -tx1 < $$f | \
+	                   sed -e 's/ /\n/g' | \
+	                   sed -e 's/^[0-9a-f]\+$$/\0/;t;d' | \
+	                   sed -e 's/^/0x/;s/$$/,/'); \
+	      # file should not be empty - maybe command substitution failed? \
+	      test ! -z "$$thisf";\
+	      allf=$$allf$$thisf;\
+	  done; \
+	  ( \
+	      echo '#include "reg.h"'; \
+	      echo 'const u8 extra_regdb_certs[] = {'; \
+	      echo "$$allf"; \
+	      echo '};'; \
+	      echo 'unsigned int extra_regdb_certs_len = sizeof(extra_regdb_certs);'; \
+	  ) >> $@)
-- 
2.14.2
