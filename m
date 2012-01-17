Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nautica.notk.org ([91.121.71.147]:40510 "EHLO nautica.notk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab2AQAIt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 19:08:49 -0500
From: Dominique Martinet <asmadeus@codewreck.org>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH v2] compat-wireless: build: Throw error if space in path
Date: Tue, 17 Jan 2012 01:08:12 +0100
Message-Id: <1326758892-32135-1-git-send-email-asmadeus@codewreck.org> (sfid-20120117_010904_758548_2C83D669)
In-Reply-To: <CAB=NE6WAhddiUuf4yOfNAgqMF7GxM--ksDwEmvwdJdFYSjLGzA@mail.gmail.com>
References: <CAB=NE6WAhddiUuf4yOfNAgqMF7GxM--ksDwEmvwdJdFYSjLGzA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because of make limitations, the build will fail if there are spaces in
the path leading to the compat-wireless directory.
I tried to make it work anyway for a while and, while it probably is
possible, it would involve rewriting part of kbuild and well...
This at least throws up nicely if there is a space in the path.

Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
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
1.7.2.5

