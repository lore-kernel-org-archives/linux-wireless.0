Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:53297 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab0CDOLx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 09:11:53 -0500
Received: from localhost (localhost [127.0.0.1])
	by venema.h4ckr.net (Postfix) with ESMTP id 8D9EE33E813
	for <linux-wireless@vger.kernel.org>; Thu,  4 Mar 2010 15:11:52 +0100 (CET)
Received: from venema.h4ckr.net ([127.0.0.1])
	by localhost (venema.h4ckr.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bTJjzrjtgU2q for <linux-wireless@vger.kernel.org>;
	Thu,  4 Mar 2010 15:11:47 +0100 (CET)
Received: from nomad.localnet (CPE-58-174-132-139.mjcz1.woo.bigpond.net.au [58.174.132.139])
	by venema.h4ckr.net (Postfix) with ESMTP id D738C33E7E1
	for <linux-wireless@vger.kernel.org>; Thu,  4 Mar 2010 15:11:46 +0100 (CET)
To: linux-wireless@vger.kernel.org
Subject: [PATCH] crda: allow build with gcrypt support
From: Kel Modderman <kel@otaku42.de>
Date: Fri, 5 Mar 2010 00:11:44 +1000
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003050011.44807.kel@otaku42.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

USE_GCRYPT=0 disables using gcrypt for signature verification.

Signed-off-by: Kel Modderman <kel@otaku42.de>
---
--- a/Makefile
+++ b/Makefile
@@ -28,6 +28,7 @@ CFLAGS += -DUSE_OPENSSL -DPUBKEY_DIR=\"$
 LDLIBS += `pkg-config --libs openssl`
 
 else
+ifneq ($(USE_GCRYPT),0)
 PUBKEY_DIR?=pubkeys
 CFLAGS += -DUSE_GCRYPT
 LDLIBS += -lgcrypt
@@ -40,6 +41,7 @@ keys-gcrypt: utils/key2pub.py $(wildcard
 	$(Q)./utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem) $@
 
 endif
+endif
 MKDIR ?= mkdir -p
 INSTALL ?= install
 
---
