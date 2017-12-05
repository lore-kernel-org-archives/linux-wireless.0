Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:54258 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753178AbdLELCI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 06:02:08 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Paul Menzel <pmenzel+linux-wireless@molgen.mpg.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] wireless: replace usage of hexdump with od/sed
Date: Tue,  5 Dec 2017 12:02:03 +0100
Message-Id: <20171205110204.18579-1-johannes@sipsolutions.net> (sfid-20171205_120211_520081_67911701)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since od/sed are in posix, hopefully there's a better chance
people will have them, over hexdump.

Fixes: 90a53e4432b1 ("cfg80211: implement regdb signature checking")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index 278d979c211a..63cbb6432b2d 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -27,7 +27,7 @@ $(obj)/shipped-certs.c: $(wildcard $(srctree)/$(src)/certs/*.x509)
 	@$(kecho) "  GEN     $@"
 	@echo '#include "reg.h"' > $@
 	@echo 'const u8 shipped_regdb_certs[] = {' >> $@
-	@for f in $^ ; do hexdump -v -e '1/1 "0x%.2x," "\n"' < $$f >> $@ ; done
+	@for f in $^ ; do od -An -v -tx1 < $$f | sed -e 's/ /\n/g' | sed -e 's/^[0-9a-f]\+$$/\0/;t;d' | sed -e 's/^/0x/;s/$$/,/' >> $@ ; done
 	@echo '};' >> $@
 	@echo 'unsigned int shipped_regdb_certs_len = sizeof(shipped_regdb_certs);' >> $@
 
@@ -36,6 +36,6 @@ $(obj)/extra-certs.c: $(CONFIG_CFG80211_EXTRA_REGDB_KEYDIR:"%"=%) \
 	@$(kecho) "  GEN     $@"
 	@echo '#include "reg.h"' > $@
 	@echo 'const u8 extra_regdb_certs[] = {' >> $@
-	@for f in $^ ; do test -f $$f && hexdump -v -e '1/1 "0x%.2x," "\n"' < $$f >> $@ || true ; done
+	@for f in $^ ; do test -f $$f && od -An -v -tx1 < $$f | sed -e 's/ /\n/g' | sed -e 's/^[0-9a-f]\+$$/\0/;t;d' | sed -e 's/^/0x/;s/$$/,/' >> $@ ; done
 	@echo '};' >> $@
 	@echo 'unsigned int extra_regdb_certs_len = sizeof(extra_regdb_certs);' >> $@
-- 
2.14.2
