Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbbGQQTe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 12:19:34 -0400
Subject: [PATCH 23/27] modsign: Use extract-cert to process
 CONFIG_SYSTEM_TRUSTED_KEYS
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Fri, 17 Jul 2015 17:19:28 +0100
Message-ID: <20150717161928.2578.21019.stgit@warthog.procyon.org.uk> (sfid-20150717_182121_994457_4B3734BA)
In-Reply-To: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
References: <20150717161456.2578.95678.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Woodhouse <David.Woodhouse@intel.com>

Fix up the dependencies somewhat too, while we're at it.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/Makefile              |   25 ++++++++++++-------------
 kernel/system_certificates.S |    3 +++
 scripts/Makefile             |    3 ++-
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 686d93b93006..9e31922138d0 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -166,23 +166,22 @@ endef
 #
 ###############################################################################
 
-
 ifeq ($(CONFIG_SYSTEM_TRUSTED_KEYRING),y)
 
 $(eval $(call config_filename,SYSTEM_TRUSTED_KEYS))
 
-SIGNING_X509-$(CONFIG_MODULE_SIG) += signing_key.x509
-
-kernel/system_certificates.o: $(obj)/x509_certificate_list
+# GCC doesn't include .incbin files in -MD generated dependencies (PR#66871)
+$(obj)/system_certificates.o: $(obj)/x509_certificate_list
 
-quiet_cmd_x509certs  = CERTS   $(SIGNING_X509-y) $(patsubst "%",%,$(2))
-      cmd_x509certs  = ( cat $(SIGNING_X509-y) /dev/null; \
-			 awk '/-----BEGIN CERTIFICATE-----/{flag=1;next}/-----END CERTIFICATE-----/{flag=0}flag' $(2) /dev/null | base64 -d ) > $@ || ( rm $@; exit 1)
+# Cope with signing_key.x509 existing in $(srctree) not $(objtree)
+AFLAGS_system_certificates.o := -I$(srctree)
 
-targets += $(obj)/x509_certificate_list
-$(obj)/x509_certificate_list: $(SIGNING_X509-y) include/config/system/trusted/keys.h $(wildcard include/config/module/sig.h) $(SYSTEM_TRUSTED_KEYS_SRCPREFIX)$(SYSTEM_TRUSTED_KEYS_FILENAME)
-	$(call if_changed,x509certs,$(SYSTEM_TRUSTED_KEYS_SRCPREFIX)$(CONFIG_SYSTEM_TRUSTED_KEYS))
+quiet_cmd_extract_certs  = EXTRACT_CERTS   $(patsubst "%",%,$(2))
+      cmd_extract_certs  = scripts/extract-cert $(2) $@ || ( rm $@; exit 1)
 
+targets += x509_certificate_list
+$(obj)/x509_certificate_list: scripts/extract-cert $(SYSTEM_TRUSTED_KEYS_SRCPREFIX)$(SYSTEM_TRUSTED_KEYS_FILENAME) FORCE
+	$(call if_changed,extract_certs,$(SYSTEM_TRUSTED_KEYS_SRCPREFIX)$(CONFIG_SYSTEM_TRUSTED_KEYS))
 endif
 
 clean-files := x509_certificate_list .x509.list
@@ -248,9 +247,9 @@ ifeq ($(patsubst pkcs11:%,%,$(firstword $(MODULE_SIG_KEY_FILENAME))),$(firstword
 X509_DEP := $(MODULE_SIG_KEY_SRCPREFIX)$(MODULE_SIG_KEY_FILENAME)
 endif
 
-quiet_cmd_extract_der = SIGNING_CERT $(patsubst "%",%,$(2))
-      cmd_extract_der = scripts/extract-cert $(2) signing_key.x509
+# GCC PR#66871 again.
+$(obj)/system_certificates.o: signing_key.x509
 
 signing_key.x509: scripts/extract-cert include/config/module/sig/key.h $(X509_DEP)
-	$(call cmd,extract_der,$(MODULE_SIG_KEY_SRCPREFIX)$(CONFIG_MODULE_SIG_KEY))
+	$(call cmd,extract_certs,$(MODULE_SIG_KEY_SRCPREFIX)$(CONFIG_MODULE_SIG_KEY))
 endif
diff --git a/kernel/system_certificates.S b/kernel/system_certificates.S
index 3e9868d47535..6ba2f75e7ba5 100644
--- a/kernel/system_certificates.S
+++ b/kernel/system_certificates.S
@@ -7,6 +7,9 @@
 	.globl VMLINUX_SYMBOL(system_certificate_list)
 VMLINUX_SYMBOL(system_certificate_list):
 __cert_list_start:
+#ifdef CONFIG_MODULE_SIG
+	.incbin "signing_key.x509"
+#endif
 	.incbin "kernel/x509_certificate_list"
 __cert_list_end:
 
diff --git a/scripts/Makefile b/scripts/Makefile
index 236f683510bd..1b2661712d44 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -16,7 +16,8 @@ hostprogs-$(CONFIG_VT)           += conmakehash
 hostprogs-$(BUILD_C_RECORDMCOUNT) += recordmcount
 hostprogs-$(CONFIG_BUILDTIME_EXTABLE_SORT) += sortextable
 hostprogs-$(CONFIG_ASN1)	 += asn1_compiler
-hostprogs-$(CONFIG_MODULE_SIG)	 += sign-file extract-cert
+hostprogs-$(CONFIG_MODULE_SIG)	 += sign-file
+hostprogs-$(CONFIG_SYSTEM_TRUSTED_KEYRING) += extract-cert
 
 HOSTCFLAGS_sortextable.o = -I$(srctree)/tools/include
 HOSTCFLAGS_asn1_compiler.o = -I$(srctree)/include

