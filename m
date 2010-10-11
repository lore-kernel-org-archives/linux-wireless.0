Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:48091 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304Ab0JKLqi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 07:46:38 -0400
Message-ID: <4CB2F91B.9000702@openwrt.org>
Date: Mon, 11 Oct 2010 13:46:35 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] compat: fix a crash in the netlink backport
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not set the .doit wrapper if there is no .doit function.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/compat/compat-2.6.37.c
+++ b/compat/compat-2.6.37.c
@@ -130,7 +130,8 @@ int compat_genl_register_family_with_ops
 		__copy(dumpit);
 		__copy(done);
 #undef __copy
-		ops[i].ops.doit = nl_doit_wrapper;
+		if (ops[i].doit)
+			ops[i].ops.doit = nl_doit_wrapper;
 		ret = genl_register_ops(&family->family, &ops[i].ops);
 		if (ret < 0)
 			goto error_ops;

