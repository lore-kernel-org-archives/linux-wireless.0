Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6942 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab2B1BGC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 20:06:02 -0500
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <hauke@hauke-m.de>, <nbd@nbd.name>, <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 5/7] compat: split COMPAT_CONFIG and COMPAT_AUTOCONF targets
Date: Mon, 27 Feb 2012 17:05:39 -0800
Message-ID: <1330391141-19909-6-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120228_024249_697766_33D2C478)
In-Reply-To: <1330391141-19909-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1330391141-19909-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@frijolero.org>

Let GNU Make take care of the dependency map.

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 2f47e3f..537d759 100644
--- a/Makefile
+++ b/Makefile
@@ -58,11 +58,11 @@ install: modules
 		modules_install
 	depmod -a
 
-$(COMPAT_AUTOCONF): ;
+$(COMPAT_AUTOCONF): $(COMPAT_CONFIG)
+	+@$(PWD)/scripts/gen-compat-autoconf.sh $(COMPAT_CONFIG) > $(COMPAT_AUTOCONF)
 
 $(COMPAT_CONFIG):
 	+@$(PWD)/scripts/gen-compat-config.sh > $(COMPAT_CONFIG)
-	+@$(PWD)/scripts/gen-compat-autoconf.sh $(COMPAT_CONFIG) > $(COMPAT_AUTOCONF)
 	@$(MAKE) -C $(PWD) modules
 
 install: modules
-- 
1.7.4.15.g7811d

