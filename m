Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:46002 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752432AbdLNNdm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 08:33:42 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wireless: Always rewrite generated files from scratch
Date: Thu, 14 Dec 2017 14:33:38 +0100
Message-Id: <20171214133338.10551-1-thierry.reding@gmail.com> (sfid-20171214_143400_562769_81210641)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thierry Reding <treding@nvidia.com>

Currently the certs C code generation appends to the generated files,
which is most likely a leftover from commit 715a12334764 ("wireless:
don't write C files on failures"). This causes duplicate code in the
generated files if the certificates have their timestamps modified
between builds and thereby trigger the generation rules.

Fixes: 715a12334764 ("wireless: don't write C files on failures")
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Based on next-20171214

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
2.15.1
