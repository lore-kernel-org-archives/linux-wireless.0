Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:51087 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab1FBVrW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 17:47:22 -0400
Received: by yia27 with SMTP id 27so534737yia.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jun 2011 14:47:22 -0700 (PDT)
From: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, lauro.venancio@openbossa.org,
	marcio.macedo@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com, Waldemar.Rymarkiewicz@tieto.com
Subject: [PATCH 3/6] NFC: add NFC socket family
Date: Thu,  2 Jun 2011 18:46:07 -0300
Message-Id: <1307051170-17374-4-git-send-email-lauro.venancio@openbossa.org> (sfid-20110602_234731_084388_C52F52E4)
In-Reply-To: <1307051170-17374-1-git-send-email-lauro.venancio@openbossa.org>
References: <1307051170-17374-1-git-send-email-lauro.venancio@openbossa.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>

Signed-off-by: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Signed-off-by: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
---
 include/linux/nfc.h    |    3 +
 include/linux/socket.h |    4 +-
 net/core/sock.c        |    6 +-
 net/nfc/Makefile       |    2 +-
 net/nfc/af_nfc.c       |   98 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/nfc/core.c         |    7 +++
 net/nfc/nfc.h          |   14 +++++++
 7 files changed, 129 insertions(+), 5 deletions(-)
 create mode 100644 net/nfc/af_nfc.c

diff --git a/include/linux/nfc.h b/include/linux/nfc.h
index be8fc88..7361f80 100644
--- a/include/linux/nfc.h
+++ b/include/linux/nfc.h
@@ -119,4 +119,7 @@ enum nfc_target_attr {
 };
 #define NFC_TARGET_ATTR_MAX (__NFC_TARGET_ATTR_AFTER_LAST - 1)
 
+/* NFC socket protocols */
+#define NFC_SOCKPROTO_MAX	0
+
 #endif /*__LINUX_NFC_H */
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 4ef98e4..e17f822 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -192,7 +192,8 @@ struct ucred {
 #define AF_IEEE802154	36	/* IEEE802154 sockets		*/
 #define AF_CAIF		37	/* CAIF sockets			*/
 #define AF_ALG		38	/* Algorithm sockets		*/
-#define AF_MAX		39	/* For now.. */
+#define AF_NFC		39	/* NFC sockets			*/
+#define AF_MAX		40	/* For now.. */
 
 /* Protocol families, same as address families. */
 #define PF_UNSPEC	AF_UNSPEC
@@ -234,6 +235,7 @@ struct ucred {
 #define PF_IEEE802154	AF_IEEE802154
 #define PF_CAIF		AF_CAIF
 #define PF_ALG		AF_ALG
+#define PF_NFC		AF_NFC
 #define PF_MAX		AF_MAX
 
 /* Maximum queue length specifiable by listen.  */
diff --git a/net/core/sock.c b/net/core/sock.c
index 6e81978..84d6de8 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -158,7 +158,7 @@ static const char *const af_family_key_strings[AF_MAX+1] = {
   "sk_lock-AF_TIPC"  , "sk_lock-AF_BLUETOOTH", "sk_lock-IUCV"        ,
   "sk_lock-AF_RXRPC" , "sk_lock-AF_ISDN"     , "sk_lock-AF_PHONET"   ,
   "sk_lock-AF_IEEE802154", "sk_lock-AF_CAIF" , "sk_lock-AF_ALG"      ,
-  "sk_lock-AF_MAX"
+  "sk_lock-AF_NFC"   , "sk_lock-AF_MAX"
 };
 static const char *const af_family_slock_key_strings[AF_MAX+1] = {
   "slock-AF_UNSPEC", "slock-AF_UNIX"     , "slock-AF_INET"     ,
@@ -174,7 +174,7 @@ static const char *const af_family_slock_key_strings[AF_MAX+1] = {
   "slock-AF_TIPC"  , "slock-AF_BLUETOOTH", "slock-AF_IUCV"     ,
   "slock-AF_RXRPC" , "slock-AF_ISDN"     , "slock-AF_PHONET"   ,
   "slock-AF_IEEE802154", "slock-AF_CAIF" , "slock-AF_ALG"      ,
-  "slock-AF_MAX"
+  "slock-AF_NFC"   , "slock-AF_MAX"
 };
 static const char *const af_family_clock_key_strings[AF_MAX+1] = {
   "clock-AF_UNSPEC", "clock-AF_UNIX"     , "clock-AF_INET"     ,
@@ -190,7 +190,7 @@ static const char *const af_family_clock_key_strings[AF_MAX+1] = {
   "clock-AF_TIPC"  , "clock-AF_BLUETOOTH", "clock-AF_IUCV"     ,
   "clock-AF_RXRPC" , "clock-AF_ISDN"     , "clock-AF_PHONET"   ,
   "clock-AF_IEEE802154", "clock-AF_CAIF" , "clock-AF_ALG"      ,
-  "clock-AF_MAX"
+  "clock-AF_NFC"   , "clock-AF_MAX"
 };
 
 /*
diff --git a/net/nfc/Makefile b/net/nfc/Makefile
index 8aeaddc..c65add7 100644
--- a/net/nfc/Makefile
+++ b/net/nfc/Makefile
@@ -4,6 +4,6 @@
 
 obj-$(CONFIG_NFC) += nfc.o
 
-nfc-objs := core.o netlink.o
+nfc-objs := core.o netlink.o af_nfc.o
 
 ccflags-$(CONFIG_NFC_DEBUG) := -DDEBUG
diff --git a/net/nfc/af_nfc.c b/net/nfc/af_nfc.c
new file mode 100644
index 0000000..e982cef
--- /dev/null
+++ b/net/nfc/af_nfc.c
@@ -0,0 +1,98 @@
+/*
+ * Copyright (C) 2011 Instituto Nokia de Tecnologia
+ *
+ * Authors:
+ *    Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
+ *    Lauro Ramos Venancio <lauro.venancio@openbossa.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the
+ * Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include <linux/nfc.h>
+
+#include "nfc.h"
+
+static DEFINE_RWLOCK(proto_tab_lock);
+static const struct nfc_protocol *proto_tab[NFC_SOCKPROTO_MAX];
+
+static int nfc_sock_create(struct net *net, struct socket *sock, int proto,
+								int kern)
+{
+	int rc = -EPROTONOSUPPORT;
+
+	if (net != &init_net)
+		return -EAFNOSUPPORT;
+
+	if (proto < 0 || proto >= NFC_SOCKPROTO_MAX)
+		return -EINVAL;
+
+	read_lock(&proto_tab_lock);
+	if (proto_tab[proto] &&	try_module_get(proto_tab[proto]->owner)) {
+		rc = proto_tab[proto]->create(net, sock, proto_tab[proto]);
+		module_put(proto_tab[proto]->owner);
+	}
+	read_unlock(&proto_tab_lock);
+
+	return rc;
+}
+
+static struct net_proto_family nfc_sock_family_ops = {
+	.owner  = THIS_MODULE,
+	.family = PF_NFC,
+	.create = nfc_sock_create,
+};
+
+int nfc_proto_register(const struct nfc_protocol *nfc_proto)
+{
+	int rc;
+
+	if (nfc_proto->id < 0 || nfc_proto->id >= NFC_SOCKPROTO_MAX)
+		return -EINVAL;
+
+	rc = proto_register(nfc_proto->proto, 0);
+	if (rc)
+		return rc;
+
+	write_lock(&proto_tab_lock);
+	if (proto_tab[nfc_proto->id])
+		rc = -EBUSY;
+	else
+		proto_tab[nfc_proto->id] = nfc_proto;
+	write_unlock(&proto_tab_lock);
+
+	return rc;
+}
+EXPORT_SYMBOL(nfc_proto_register);
+
+void nfc_proto_unregister(const struct nfc_protocol *nfc_proto)
+{
+	write_lock(&proto_tab_lock);
+	proto_tab[nfc_proto->id] = NULL;
+	write_unlock(&proto_tab_lock);
+
+	proto_unregister(nfc_proto->proto);
+}
+EXPORT_SYMBOL(nfc_proto_unregister);
+
+int __init af_nfc_init(void)
+{
+	return sock_register(&nfc_sock_family_ops);
+}
+
+void af_nfc_exit(void)
+{
+	sock_unregister(PF_NFC);
+}
diff --git a/net/nfc/core.c b/net/nfc/core.c
index b73c917..d4d2ecc 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -366,8 +366,14 @@ static int __init nfc_init(void)
 	if (rc)
 		goto err_genl;
 
+	rc = af_nfc_init();
+	if (rc)
+		goto err_af_nfc;
+
 	return 0;
 
+err_af_nfc:
+	nfc_genl_exit();
 err_genl:
 	class_unregister(&nfc_class);
 err:
@@ -376,6 +382,7 @@ err:
 
 static void __exit nfc_exit(void)
 {
+	af_nfc_exit();
 	nfc_genl_exit();
 	class_unregister(&nfc_class);
 }
diff --git a/net/nfc/nfc.h b/net/nfc/nfc.h
index 33d19eb..76b891f 100644
--- a/net/nfc/nfc.h
+++ b/net/nfc/nfc.h
@@ -25,6 +25,20 @@
 #define __LOCAL_NFC_H
 
 #include <net/nfc.h>
+#include <net/sock.h>
+
+struct nfc_protocol {
+	int id;
+	struct proto *proto;
+	struct module *owner;
+	int (*create)(struct net *net, struct socket *sock,
+			const struct nfc_protocol *nfc_proto);
+};
+
+int __init af_nfc_init(void);
+void af_nfc_exit(void);
+int nfc_proto_register(const struct nfc_protocol *nfc_proto);
+void nfc_proto_unregister(const struct nfc_protocol *nfc_proto);
 
 int __init nfc_genl_init(void);
 
-- 
1.7.1

