Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:33807 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbdLSTXM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 14:23:12 -0500
Received: by mail-it0-f66.google.com with SMTP id m11so9238307iti.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 Dec 2017 11:23:11 -0800 (PST)
From: Brian Norris <briannorris@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Paul Menzel <pmenzel+linux-wireless@molgen.mpg.de>,
        Damian Tometzki <damian.tometzki@icloud.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH for-4.15] wireless: create, don't append, to shipped-certs.c
Date: Tue, 19 Dec 2017 11:23:03 -0800
Message-Id: <20171219192303.31395-1-briannorris@chromium.org> (sfid-20171219_202341_687489_14BA47D3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current rule for generating the {shipped,extra}-certs.c source files
might create an invalid C source file, containing redefinitions of the
same variables:

  CC [M]  net/wireless/shipped-certs.o
net/wireless/shipped-certs.c:686:10: error: redefinition of 'shipped_regdb_certs'
 const u8 shipped_regdb_certs[] = {
          ^
net/wireless/shipped-certs.c:2:10: note: previous definition of 'shipped_regdb_certs' was here
 const u8 shipped_regdb_certs[] = {
          ^
net/wireless/shipped-certs.c:1368:14: error: redefinition of 'shipped_regdb_certs_len'
 unsigned int shipped_regdb_certs_len = sizeof(shipped_regdb_certs);
              ^
net/wireless/shipped-certs.c:684:14: note: previous definition of 'shipped_regdb_certs_len' was here
 unsigned int shipped_regdb_certs_len = sizeof(shipped_regdb_certs);
              ^

This can be easily triggered by forcing a rebuild of these files:

  $ touch net/wireless/certs/sforshee.x509
  $ make

In practice, this is seen often by having a separate source and build
directory, where the build artifacts remain but the source tree changes
(even if Seth's cert doesn't change, it might get created/removed when
checking out different source revisions).

I don't see why this rule should be an append; we're writing the file
all in one go.

Fixes: 90a53e4432b1 ("cfg80211: implement regdb signature checking")
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
This is an error introduced in 4.15-rc1.

I've seen other errors reported by Paul and Damian (CC'd); I think Paul's
failure was fixed already, but Damian might have still been having problems
with not having a "clean" environment. Perhaps he was hitting this bug?

 net/wireless/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index d7d6cb00c47b..b662be3422e1 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -43,7 +43,7 @@ $(obj)/shipped-certs.c: $(wildcard $(srctree)/$(src)/certs/*.x509)
 	      echo "$$allf"; \
 	      echo '};'; \
 	      echo 'unsigned int shipped_regdb_certs_len = sizeof(shipped_regdb_certs);'; \
-	  ) >> $@)
+	  ) > $@)
 
 $(obj)/extra-certs.c: $(CONFIG_CFG80211_EXTRA_REGDB_KEYDIR:"%"=%) \
 		      $(wildcard $(CONFIG_CFG80211_EXTRA_REGDB_KEYDIR:"%"=%)/*.x509)
@@ -66,4 +66,4 @@ $(obj)/extra-certs.c: $(CONFIG_CFG80211_EXTRA_REGDB_KEYDIR:"%"=%) \
 	      echo "$$allf"; \
 	      echo '};'; \
 	      echo 'unsigned int extra_regdb_certs_len = sizeof(extra_regdb_certs);'; \
-	  ) >> $@)
+	  ) > $@)
-- 
2.15.1.504.g5279b80103-goog
