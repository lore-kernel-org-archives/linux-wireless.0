Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59320 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab2B1BFs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 20:05:48 -0500
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <hauke@hauke-m.de>, <nbd@nbd.name>, <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 1/7] compat: fix parallel builds
Date: Mon, 27 Feb 2012 17:05:35 -0800
Message-ID: <1330391141-19909-2-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120228_020552_906482_DC5EA3F3)
In-Reply-To: <1330391141-19909-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1330391141-19909-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@frijolero.org>

We broke parallel builds by breaking GNU Make's heuristics.
GNU Make does not whether or not target commands are sub-make
commands or not, these must be explicitly annotated. To tell
GNU Make that target command is going to be a sub-process
we can use the $(MAKE) variable for a command. Another option
is to tell GNU Make that a target command is *not* a sub-make
command instead explicitly by prepending a command with a plus,
"+" prior to the command. This will force GNU Make to avoid
supporting certain flags for those targets but more importantly,
it will also ensure that during execution of commands that are
*not* sub-make commands it will yield the jobserver to ensure
file descriptor / job sanity.

Annotate to GNU Make two commands that we issue are *not* sub-make
commands. This avoids stop the job server for these commands but
also allows GNU Make to figure out the heuristics to run the job
server for further sub-make commands -- in this case the recursive
call to make.

Reported-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index d96d098..d11da17 100644
--- a/Makefile
+++ b/Makefile
@@ -62,8 +62,8 @@ install: modules
 $(COMPAT_AUTOCONF): ;
 
 $(COMPAT_CONFIG):
-	@$(PWD)/scripts/gen-compat-config.sh > $(PWD)/$(COMPAT_CONFIG)
-	@$(PWD)/scripts/gen-compat-autoconf.sh $(COMPAT_CONFIG) > $(PWD)/$(COMPAT_AUTOCONF)
+	+@$(PWD)/scripts/gen-compat-config.sh > $(PWD)/$(COMPAT_CONFIG)
+	+@$(PWD)/scripts/gen-compat-autoconf.sh $(COMPAT_CONFIG) > $(PWD)/$(COMPAT_AUTOCONF)
 	@$(MAKE) -C $(PWD) modules
 
 install: modules
-- 
1.7.4.15.g7811d

