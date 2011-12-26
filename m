Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nautica.notk.org ([91.121.71.147]:39743 "EHLO nautica.notk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab1LZVLy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Dec 2011 16:11:54 -0500
From: Dominique Martinet <asmadeus@codewreck.org>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH] compat-wireless: build: Throw error if space in path
Date: Mon, 26 Dec 2011 22:04:19 +0100
Message-Id: <1324933459-17242-1-git-send-email-asmadeus@codewreck.org> (sfid-20111226_221159_667736_20F9A43C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because of make limitations, the build will fail if there are spaces in
the path leading to the compat-wireless directory.
I tried to make it work anyway for a while and, while it probably is
possible, it would involve rewriting part of kbuild and well...
This at least throws up nicely if there is a space in the path.

---
 Makefile |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index d3a9d93..c81d680 100644
--- a/Makefile
+++ b/Makefile
@@ -47,6 +47,13 @@ obj-$(CONFIG_COMPAT_BLUETOOTH_MODULES) += drivers/bluetooth/
 else
 
 export PWD :=	$(shell pwd)
+
+# The build will fail if there is any space in PWD.
+ifneq (,$(findstring  $() ,$(PWD)))
+$(error "The path to this compat-wireless directory has spaces in it." \
+	"Please put it somewhere where there is no space")
+endif
+
 CFLAGS += \
         -DCOMPAT_BASE_TREE="\"$(shell cat compat_base_tree)\"" \
         -DCOMPAT_BASE_TREE_VERSION="\"$(shell cat compat_base_tree_version)\"" \
-- 
1.7.5.1

