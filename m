Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495AbbE1Psc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 11:48:32 -0400
Subject: [PATCH 15/20] modsign: Add explicit CONFIG_SYSTEM_TRUSTED_KEYS
 option [ver #5]
From: David Howells <dhowells@redhat.com>
To: mcgrof@gmail.com
Cc: mjg59@srcf.ucam.org, keyrings@linux-nfs.org,
	gregkh@linuxfoundation.org, kyle@kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	seth.forshee@canonical.com, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dwmw2@infradead.org
Date: Thu, 28 May 2015 16:48:24 +0100
Message-ID: <20150528154824.1259.43494.stgit@warthog.procyon.org.uk> (sfid-20150528_174958_829510_13172844)
In-Reply-To: <20150528154605.1259.42518.stgit@warthog.procyon.org.uk>
References: <20150528154605.1259.42518.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Woodhouse <David.Woodhouse@intel.com>

Let the user explicitly provide a file containing trusted keys, instead of
just automatically finding files matching *.x509 in the build tree and
trusting whatever we find. This really ought to be an *explicit*
configuration, and the build rules for dealing with the files were
fairly painful too.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/module-signing.txt |   15 +++--
 init/Kconfig                     |   13 ++++
 kernel/Makefile                  |  125 ++++++++++++++++++++------------------
 3 files changed, 89 insertions(+), 64 deletions(-)

diff --git a/Documentation/module-signing.txt b/Documentation/module-signing.txt
index 5d5e4e32dc26..4e62bc29666e 100644
--- a/Documentation/module-signing.txt
+++ b/Documentation/module-signing.txt
@@ -88,6 +88,7 @@ This has a number of options available:
      than being a module) so that modules signed with that algorithm can have
      their signatures checked without causing a dependency loop.
 
+
  (4) "File name or PKCS#11 URI of module signing key" (CONFIG_MODULE_SIG_KEY)
 
      Setting this option to something other than its default of
@@ -104,6 +105,13 @@ This has a number of options available:
      means of the KBUILD_SIGN_PIN variable.
 
 
+ (5) "Additional X.509 keys for default system keyring" (CONFIG_SYSTEM_TRUSTED_KEYS)
+
+     This option can be set to the filename of a PEM-encoded file containing
+     additional certificates which will be included in the system keyring by
+     default.
+
+
 =======================
 GENERATING SIGNING KEYS
 =======================
@@ -171,10 +179,9 @@ in a keyring called ".system_keyring" that can be seen by:
 	302d2d52 I------     1 perm 1f010000     0     0 asymmetri Fedora kernel signing key: d69a84e6bce3d216b979e9505b3e3ef9a7118079: X509.RSA a7118079 []
 	...
 
-Beyond the public key generated specifically for module signing, any file
-placed in the kernel source root directory or the kernel build root directory
-whose name is suffixed with ".x509" will be assumed to be an X.509 public key
-and will be added to the keyring.
+Beyond the public key generated specifically for module signing, additional
+trusted certificates can be provided in a PEM-encoded file referenced by the
+CONFIG_SYSTEM_TRUSTED_KEYS configuration option.
 
 Further, the architecture code may take public keys from a hardware store and
 add those in also (e.g. from the UEFI key database).
diff --git a/init/Kconfig b/init/Kconfig
index a52935338419..b46c19525074 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1758,6 +1758,19 @@ config SYSTEM_TRUSTED_KEYRING
 
 	  Keys in this keyring are used by module signature checking.
 
+config SYSTEM_TRUSTED_KEYS
+	string "Additional X.509 keys for default system keyring"
+	depends on SYSTEM_TRUSTED_KEYRING
+	help
+	  If set, this option should be the filename of a PEM-formatted file
+	  containing trusted X.509 certificates to be included in the default
+	  system keyring. Any certificate used for module signing is implicitly
+	  also trusted.
+
+	  NOTE: If you previously provided keys for the system keyring in the
+	  form of DER-encoded *.x509 files in the top-level build directory,
+	  those are no longer used. You will need to set this option instead.
+
 config SYSTEM_DATA_VERIFICATION
 	def_bool n
 	select SYSTEM_TRUSTED_KEYRING
diff --git a/kernel/Makefile b/kernel/Makefile
index 541e1e89e90c..2d03e870ba8d 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -114,46 +114,75 @@ $(obj)/config_data.h: $(obj)/config_data.gz FORCE
 
 ###############################################################################
 #
-# Roll all the X.509 certificates that we can find together and pull them into
-# the kernel so that they get loaded into the system trusted keyring during
-# boot.
+# When a Kconfig string contains a filename, it is suitable for
+# passing to shell commands. It is surrounded by double-quotes, and
+# any double-quotes or backslashes within it are escaped by
+# backslashes.
 #
-# We look in the source root and the build root for all files whose name ends
-# in ".x509".  Unfortunately, this will generate duplicate filenames, so we
-# have make canonicalise the pathnames and then sort them to discard the
-# duplicates.
+# This is no use for dependencies or $(wildcard). We need to strip the
+# surrounding quotes and the escaping from quotes and backslashes, and
+# we *do* need to escape any spaces in the string. So, for example:
+#
+# Usage: $(eval $(call config_filename,FOO))
+#
+# Defines FOO_FILENAME based on the contents of the CONFIG_FOO option,
+# transformed as described above to be suitable for use within the
+# makefile.
+#
+# Also, if the filename is a relative filename and exists in the source
+# tree but not the build tree, define FOO_SRCPREFIX as $(srctree)/ to
+# be prefixed to *both* command invocation and dependencies.
+#
+# Note: We also print the filenames in the quiet_cmd_foo text, and
+# perhaps ought to have a version specially escaped for that purpose.
+# But it's only cosmetic, and $(patsubst "%",%,$(CONFIG_FOO)) is good
+# enough.  It'll strip the quotes in the common case where there's no
+# space and it's a simple filename, and it'll retain the quotes when
+# there's a space. There are some esoteric cases in which it'll print
+# the wrong thing, but we don't really care. The actual dependencies
+# and commands *do* get it right, with various combinations of single
+# and double quotes, backslashes and spaces in the filenames.
 #
 ###############################################################################
-ifeq ($(CONFIG_SYSTEM_TRUSTED_KEYRING),y)
-X509_CERTIFICATES-y := $(wildcard *.x509) $(wildcard $(srctree)/*.x509)
-X509_CERTIFICATES-$(CONFIG_MODULE_SIG) += $(objtree)/signing_key.x509
-X509_CERTIFICATES-raw := $(sort $(foreach CERT,$(X509_CERTIFICATES-y), \
-				$(or $(realpath $(CERT)),$(CERT))))
-X509_CERTIFICATES := $(subst $(realpath $(objtree))/,,$(X509_CERTIFICATES-raw))
-
-ifeq ($(X509_CERTIFICATES),)
-$(warning *** No X.509 certificates found ***)
+#
+quote := $(firstword " ")
+space :=
+space +=
+space_escape := %%%SPACE%%%
+#
+define config_filename =
+ifneq ($$(CONFIG_$(1)),"")
+$(1)_FILENAME := $$(subst \\,\,$$(subst \$$(quote),$$(quote),$$(subst $$(space_escape),\$$(space),$$(patsubst "%",%,$$(subst $$(space),$$(space_escape),$$(CONFIG_$(1)))))))
+ifneq ($$(patsubst /%,%,$$(firstword $$($(1)_FILENAME))),$$(firstword $$($(1)_FILENAME)))
+else
+ifeq ($$(wildcard $$($(1)_FILENAME)),)
+ifneq ($$(wildcard $$(srctree)/$$($(1)_FILENAME)),)
+$(1)_SRCPREFIX := $(srctree)/
+endif
 endif
-
-ifneq ($(wildcard $(obj)/.x509.list),)
-ifneq ($(shell cat $(obj)/.x509.list),$(X509_CERTIFICATES))
-$(info X.509 certificate list changed)
-$(shell rm $(obj)/.x509.list)
 endif
 endif
+endef
+#
+###############################################################################
+
+
+ifeq ($(CONFIG_SYSTEM_TRUSTED_KEYRING),y)
+
+$(eval $(call config_filename,SYSTEM_TRUSTED_KEYS))
+
+SIGNING_X509-$(CONFIG_MODULE_SIG) += signing_key.x509
 
 kernel/system_certificates.o: $(obj)/x509_certificate_list
 
-quiet_cmd_x509certs  = CERTS   $@
-      cmd_x509certs  = cat $(X509_CERTIFICATES) /dev/null >$@ $(foreach X509,$(X509_CERTIFICATES),; $(kecho) "  - Including cert $(X509)")
+quiet_cmd_x509certs  = CERTS   $(SIGNING_X509-y) $(patsubst "%",%,$(2))
+      cmd_x509certs  = ( cat $(SIGNING_X509-y) /dev/null; \
+			 awk '/-----BEGIN CERTIFICATE-----/{flag=1;next}/-----END CERTIFICATE-----/{flag=0}flag' $(2) /dev/null | base64 -d ) > $@ || ( rm $@; exit 1)
 
 targets += $(obj)/x509_certificate_list
-$(obj)/x509_certificate_list: $(X509_CERTIFICATES) $(obj)/.x509.list
-	$(call if_changed,x509certs)
+$(obj)/x509_certificate_list: $(SIGNING_X509-y) include/config/system/trusted/keys.h include/config/module/sig.h $(SYSTEM_TRUSTED_KEYS_SRCPREFIX)$(SYSTEM_TRUSTED_KEYS_FILENAME)
+	$(call if_changed,x509certs,$(SYSTEM_TRUSTED_KEYS_SRCPREFIX)$(CONFIG_SYSTEM_TRUSTED_KEYS))
 
-targets += $(obj)/.x509.list
-$(obj)/.x509.list:
-	@echo $(X509_CERTIFICATES) >$@
 endif
 
 clean-files := x509_certificate_list .x509.list
@@ -212,40 +241,16 @@ x509.genkey:
 	@echo >>x509.genkey "authorityKeyIdentifier=keyid"
 endif
 
-# We need to obtain the certificate from CONFIG_MODULE_SIG_KEY.
-quiet_cmd_extract_der = CERT_DER $(2)
-      cmd_extract_der = scripts/extract-cert "$(2)" signing_key.x509
+$(eval $(call config_filename,MODULE_SIG_KEY))
 
-# CONFIG_MODULE_SIG_KEY is either a PKCS#11 URI or a filename. It is
-# surrounded by quotes, and may contain spaces. To strip the quotes
-# with $(patsubst) we need to turn the spaces into something else.
-# And if it's a filename, those spaces need to be escaped as '\ ' in
-# order to use it in dependencies or $(wildcard).
-space :=
-space +=
-space_escape := %%%SPACE%%%
-X509_SOURCE_temp := $(subst $(space),$(space_escape),$(CONFIG_MODULE_SIG_KEY))
-# We need this to check for absolute paths or PKCS#11 URIs.
-X509_SOURCE_ONEWORD := $(patsubst "%",%,$(X509_SOURCE_temp))
-# This is the actual source filename/URI without the quotes
-X509_SOURCE := $(subst $(space_escape),$(space),$(X509_SOURCE_ONEWORD))
-# This\ version\ with\ spaces\ escaped\ for\ $(wildcard)\ and\ dependencies
-X509_SOURCE_ESCAPED := $(subst $(space_escape),\$(space),$(X509_SOURCE_ONEWORD))
-
-ifeq ($(patsubst pkcs11:%,%,$(X509_SOURCE_ONEWORD)),$(X509_SOURCE_ONEWORD))
-# If it's a filename, depend on it.
-X509_DEP := $(X509_SOURCE_ESCAPED)
-ifeq ($(patsubst /%,%,$(X509_SOURCE_ONEWORD)),$(X509_SOURCE_ONEWORD))
-ifeq ($(wildcard $(X509_SOURCE_ESCAPED)),)
-ifneq ($(wildcard $(srctree)/$(X509_SOURCE_ESCAPED)),)
-# Non-absolute filename, found in source tree and not build tree
-X509_SOURCE := $(srctree)/$(X509_SOURCE)
-X509_DEP := $(srctree)/$(X509_SOURCE_ESCAPED)
-endif
-endif
-endif
+# If CONFIG_MODULE_SIG_KEY isn't a PKCS#11 URI, depend on it
+ifeq ($(patsubst pkcs11:%,%,$(firstword $(MODULE_SIG_KEY_FILENAME))),$(firstword $(MODULE_SIG_KEY_FILENAME)))
+X509_DEP := $(MODULE_SIG_KEY_SRCPREFIX)$(MODULE_SIG_KEY_FILENAME)
 endif
 
+quiet_cmd_extract_der = SIGNING_CERT $(patsubst "%",%,$(2))
+      cmd_extract_der = scripts/extract-cert $(2) signing_key.x509
+
 signing_key.x509: scripts/extract-cert include/config/module/sig/key.h $(X509_DEP)
-	$(call cmd,extract_der,$(X509_SOURCE))
+	$(call cmd,extract_der,$(MODULE_SIG_KEY_SRCPREFIX)$(CONFIG_MODULE_SIG_KEY))
 endif

