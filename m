Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP01.calltower.com ([69.4.184.248]:45850 "EHLO
	L01SLCSMTP01.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754691AbZFLVoG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 17:44:06 -0400
Subject: [RFC] CRDA Cross Compilation Makefile patch
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 16:43:28 -0500
Message-Id: <1244843008.18211.436.camel@jdl-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John and others,

Here is my proposed patch for re-working the CRDA Makefile
so that it better supports a cross compilation environment.

The primary aim of this patch is to distinguish the build
of regdbdump for use on the target and host so that it may
be used to verify the signed regulatory.bin file at build time.

Feedback welcome!

Thanks,
jdl



diff --git a/Makefile b/Makefile
index b93b735..9f9ae01 100644
--- a/Makefile
+++ b/Makefile
@@ -1,3 +1,5 @@
+-include .config
+
 # Modify as you see fit, note this is built into crda,
 # so if you change it here you will have to change crda.c
 REG_BIN?=/usr/lib/crda/regulatory.bin
@@ -22,101 +24,259 @@ UDEV_RULE_DIR?=/lib/udev/rules.d/
 # with make PUBKEY_DIR=/usr/lib/crda/pubkeys
 PUBKEY_DIR?=pubkeys
 
-CFLAGS += -Wall -g
 
-all: $(REG_BIN) crda intersect verify
+MKDIR ?= mkdir -p
+INSTALL ?= install
+
+
+ifeq ($(V),1)
+    Q=
+    NQ=@true
+else
+    Q=@
+    NQ=@echo
+endif
+
+#
+# Determine what target and host libraries and executables
+# need to be built as that will determine what libraries will
+# need to be found on the host or in the target environment.
+#
 
-ifeq ($(USE_OPENSSL),1)
-CFLAGS += -DUSE_OPENSSL `pkg-config --cflags openssl`
-LDLIBS += `pkg-config --libs openssl`
+BUILD		:= crda intersect regdbdump
 
-reglib.o: keys-ssl.c
+HOST_BUILD	:= $(patsubst %,host/%,$(BUILD))
+TARGET_BUILD	:= $(patsubst %,target/%,$(BUILD))
 
+ifeq ($(CROSS_COMPILE),)
+    # Host only
+    # Initially treat host and target the same using target.
+    TARGET_PKG_CONFIG_PATH := $(PKG_CONFIG_PATH)
+    TARGET_USE_OPENSSL := $(USE_OPENSSL)
+    BUILD_ALL := $(TARGET_BUILD)
+    INSTALL_EXECS := target/crda target/regdbdump
 else
-CFLAGS += -DUSE_GCRYPT
-LDLIBS += -lgcrypt
+    # Cross compile
+    BUILD_ALL := $(TARGET_BUILD)
+    ifeq ($(BUILD_FOR_HOST_TOO),1)
+	BUILD_ALL += $(HOST_BUILD)
+    endif
+    INSTALL_EXECS := target/crda target/regdbdump
+endif
+
+INSTALL_MAN	:= crda.8.gz regdbdump.8.gz 
+
 
-reglib.o: keys-gcrypt.c
 
+TARGET_CFLAGS += -Wall -g
+
+ifeq ($(TARGET_USE_OPENSSL),1)
+    TARGET_CFLAGS_KEYS	+= -DUSE_OPENSSL \
+			`PKG_CONFIG_PATH=$(TARGET_PKG_CONFIG_PATH) \
+			pkg-config --cflags openssl`
+    TARGET_LDLIBS_KEYS	+= `PKG_CONFIG_PATH=$(TARGET_PKG_CONFIG_PATH) \
+			pkg-config --libs openssl`
+    TARGET_KEYS_FILE	:= keys-ssl.c
+else
+    TARGET_CFLAGS_KEYS	+= -DUSE_GCRYPT
+    TARGET_LDLIBS_KEYS	+= -lgcrypt
+    TARGET_KEYS_FILE	:= keys-gcrypt.c
 endif
-MKDIR ?= mkdir -p
-INSTALL ?= install
 
-NL1FOUND := $(shell pkg-config --atleast-version=1 libnl-1 && echo Y)
-NL2FOUND := $(shell pkg-config --atleast-version=2 libnl-2.0 && echo Y)
+TARGET_NL1FOUND := $(shell PKG_CONFIG_PATH=$(TARGET_PKG_CONFIG_PATH) \
+			pkg-config --atleast-version=1 libnl-1 && echo Y)
+TARGET_NL2FOUND := $(shell PKG_CONFIG_PATH=$(TARGET_PKG_CONFIG_PATH) \
+			pkg-config --atleast-version=2 libnl-2.0 && echo Y)
 
-ifeq ($(NL1FOUND),Y)
-NLLIBNAME = libnl-1
+ifeq ($(TARGET_NL1FOUND),Y)
+    TARGET_NLLIBNAME	:= libnl-1
 endif
 
-ifeq ($(NL2FOUND),Y)
-CFLAGS += -DCONFIG_LIBNL20
-NLLIBS += -lnl-genl
-NLLIBNAME = libnl-2.0
+ifeq ($(TARGET_NL2FOUND),Y)
+    TARGET_CFLAGS_NL	+= -DCONFIG_LIBNL20
+    TARGET_LDLIBS_NL	+= -lnl-genl
+    TARGET_NLLIBNAME	:= libnl-2.0
 endif
 
-ifeq ($(NLLIBNAME),)
-$(error Cannot find development files for any supported version of libnl)
+ifneq ($(findstring clean,$(MAKECMDGOALS)),clean)
+ifeq ($(TARGET_NLLIBNAME),)
+$(error Cannot find development files for any supported version of target libnl)
+endif
 endif
 
-NLLIBS += `pkg-config --libs $(NLLIBNAME)`
-CFLAGS += `pkg-config --cflags $(NLLIBNAME)`
+TARGET_LDLIBS_NL += `PKG_CONFIG_PATH=$(TARGET_PKG_CONFIG_PATH) \
+			pkg-config --libs $(TARGET_NLLIBNAME)`
+TARGET_CFLAGS_NL += `PKG_CONFIG_PATH=$(TARGET_PKG_CONFIG_PATH) \
+			pkg-config --cflags $(TARGET_NLLIBNAME)`
+
+TARGET_CFLAGS += $(TARGET_CFLAGS_NL) $(TARGET_CFLAGS_KEYS)
+TARGET_LDLIBS += $(TARGET_LDLIBS_NL) $(TARGET_LDLIBS_KEYS)
+
+
+#
+# When not cross-compiling, treat target and host the same
+# by transferring target-values to the HOST_* names and then
+# only building the host targets.
+#
+# However when cross-compiling, build-up the real host-values
+# in HOST_*, leaving the generic names to be for the target.
+#
+ifeq ($(CROSS_COMPILE),)
+
+# Not cross compiling, the host is the target.
+HOST_CC		:= $(CC)
+HOST_CFLAGS	:= $(TARGET_CFLAGS)
+HOST_CPPFLAGS	:= $(TARGET_CPPFLAGS)
+HOST_LDFLAGS	:= $(TARGET_LDFLAGS)
+HOST_LDLIBS	:= $(TARGET_LDLIBS)
+HOST_USE_OPENSSL := $(TARGET_USE_OPENSSL)
+HOST_LDLIBS	:= $(TARGET_LDLIBS)
+HOST_KEYS_FILE	:= $(TARGET_KEYS_FILE)
+BUILD_ALL	:= $(subst target/,host/,$(BUILD_ALL))
+INSTALL_EXECS	:= $(subst target/,host/,$(INSTALL_EXECS))
 
-ifeq ($(V),1)
-Q=
-NQ=@true
 else
-Q=@
-NQ=@echo
+
+# Cross compiling, so trump up HOST definitions now.
+
+HOST_CFLAGS += -Wall -g
+
+ifeq ($(HOST_USE_OPENSSL),1)
+    HOST_CFLAGS_KEYS	+= -DUSE_OPENSSL -DFOO \
+			`PKG_CONFIG_PATH=$(HOST_PKG_CONFIG_PATH) \
+			pkg-config --cflags openssl`
+    HOST_LDLIBS_KEYS	+= `PKG_CONFIG_PATH=$(HOST_PKG_CONFIG_PATH) \
+			pkg-config --libs openssl`
+    HOST_KEYS_FILE	:= keys-ssl.c
+else
+    HOST_CFLAGS_KEYS	+= -DUSE_GCRYPT
+    HOST_LDLIBS_KEYS	+= -lgcrypt
+    HOST_KEYS_FILE	:= keys-gcrypt.c
 endif
 
-$(REG_BIN):
-	$(NQ) '  EXIST ' $(REG_BIN)
-	$(NQ)
-	$(NQ) ERROR: The file: $(REG_BIN) is missing. You need this in place in order
-	$(NQ) to build CRDA. You can get it from:
-	$(NQ)
-	$(NQ) $(REG_GIT)
-	$(NQ)
-	$(NQ) "Once cloned (no need to build) cp regulatory.bin to $(REG_BIN)"
-	$(NQ)
-	$(Q) exit 1
 
-keys-%.c: utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem)
-	$(NQ) '  GEN ' $@
-	$(NQ) '  Trusted pubkeys:' $(wildcard $(PUBKEY_DIR)/*.pem)
-	$(Q)./utils/key2pub.py --$* $(wildcard $(PUBKEY_DIR)/*.pem) $@
+ifeq ($(findstring host/crda,$(BUILD_ALL)),host/crda)
+HOST_NL1FOUND := $(shell PKG_CONFIG_PATH=$(HOST_PKG_CONFIG_PATH) \
+			pkg-config --atleast-version=1 libnl-1 && echo Y)
+HOST_NL2FOUND := $(shell PKG_CONFIG_PATH=$(HOST_PKG_CONFIG_PATH) \
+			pkg-config --atleast-version=2 libnl-2.0 && echo Y)
+
+ifeq ($(HOST_NL1FOUND),Y)
+    HOST_NLLIBNAME	:= libnl-1
+endif
+
+ifeq ($(HOST_NL2FOUND),Y)
+    HOST_CFLAGS_NL	+= -DCONFIG_LIBNL20
+    HOST_LDLIBS_NL	+= -lnl-genl
+    HOST_NLLIBNAME	:= libnl-2.0
+endif
+
+ifeq ($(HOST_NLLIBNAME),)
+$(error Cannot find development files for any supported version of host libnl)
+endif
 
-%.o: %.c regdb.h
+HOST_LDLIBS_NL	+= `PKG_CONFIG_PATH=$(HOST_PKG_CONFIG_PATH) \
+		pkg-config --libs $(HOST_NLLIBNAME)`
+HOST_CFLAGS_NL	+= `PKG_CONFIG_PATH=$(HOST_PKG_CONFIG_PATH) \
+		pkg-config --cflags $(HOST_NLLIBNAME)`
+endif
+
+endif
+
+HOST_CFLAGS += $(HOST_CFLAGS_KEYS) $(HOST_CFLAGS_NL)
+HOST_LDLIBS += $(HOST_LDLIBS_KEYS) $(HOST_LDLIBS_NL)
+
+
+CRDA_OBJS	:= reglib.o crda.o
+REGDBDUMP_OBJS	:= reglib.o regdbdump.o print-regdom.o
+INTERSECT_OBJS	:= reglib.o intersect.o print-regdom.o
+
+
+
+all: host target $(REG_BIN) $(BUILD_ALL) verify
+
+host target:
+	$(MKDIR) $@
+	@echo Building $(BUILD_ALL)
+
+
+target/crda: $(patsubst %,target/%,$(CRDA_OBJS))
+	$(NQ) '  LD  ' $@
+	$(Q)$(CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) -o $@ $^ $(TARGET_LDLIBS) $(NLLIBS)
+
+target/regdbdump: $(patsubst %,target/%,$(REGDBDUMP_OBJS))
+	$(NQ) '  LD  ' $@
+	$(Q)$(CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) -o $@ $^ $(TARGET_LDLIBS)
+
+target/intersect: $(patsubst %,target/%,$(INTERSECT_OBJS))
+	$(NQ) '  LD  ' $@
+	$(Q)$(CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) -o $@ $^ $(TARGET_LDLIBS)
+
+target/reglib.o: $(TARGET_KEYS_FILE)
+
+target/%.o: %.c regdb.h
 	$(NQ) '  CC  ' $@
-	$(Q)$(CC) -c $(CPPFLAGS) $(CFLAGS) -o $@ $<
+	$(Q)$(CC) -c $(TARGET_CPPFLAGS) $(TARGET_CFLAGS) -o $@ $<
+
 
-crda: reglib.o crda.o
+host/crda: $(patsubst %,host/%,$(CRDA_OBJS))
 	$(NQ) '  LD  ' $@
-	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS) $(NLLIBS)
+	$(Q)$(HOST_CC) $(HOST_CFLAGS) $(HOST_LDFLAGS) -o $@ $^ $(HOST_LDLIBS) $(HOST_LIBS_NL)
 
-regdbdump: reglib.o regdbdump.o print-regdom.o
+host/regdbdump: $(patsubst %,host/%,$(REGDBDUMP_OBJS))
 	$(NQ) '  LD  ' $@
-	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
+	$(Q)$(HOST_CC) $(HOST_CFLAGS) $(HOST_LDFLAGS) -o $@ $^ $(HOST_LDLIBS)
 
-intersect: reglib.o intersect.o print-regdom.o
+host/intersect: $(patsubst %,host/%,$(INTERSECT_OBJS))
 	$(NQ) '  LD  ' $@
-	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
+	$(Q)$(HOST_CC) $(HOST_CFLAGS) $(HOST_LDFLAGS) -o $@ $^ $(HOST_LDLIBS)
+
+host/reglib.o: $(HOST_KEYS_FILE)
+
+host/%.o: %.c regdb.h
+	$(NQ) '  HOST_CC  ' $@
+	$(Q)$(HOST_CC) -c $(HOST_CPPFLAGS) $(HOST_CFLAGS) -o $@ $<
+
 
-verify: $(REG_BIN) regdbdump
+keys-%.c: utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem)
+	$(NQ) '  GEN ' $@
+	$(NQ) '  Trusted pubkeys:' $(wildcard $(PUBKEY_DIR)/*.pem)
+	$(Q)./utils/key2pub.py --$* $(wildcard $(PUBKEY_DIR)/*.pem) $@
+
+verify: $(REG_BIN) host/regdbdump
 	$(NQ) '  CHK  $(REG_BIN)'
-	$(Q)./regdbdump $(REG_BIN) >/dev/null
+	$(Q)./host/regdbdump $(REG_BIN) >/dev/null
+
+
+$(REG_BIN):
+	$(NQ) '  EXIST ' $(REG_BIN)
+	$(NQ)
+	$(NQ) ERROR: The file: $(REG_BIN) is missing. You need this in place in order
+	$(NQ) to build CRDA. You can get it from:
+	$(NQ)
+	$(NQ) $(REG_GIT)
+	$(NQ)
+	$(NQ) "Once cloned (no need to build) cp regulatory.bin to $(REG_BIN)"
+	$(NQ)
+	$(Q) exit 1
 
 %.gz: %
 	@$(NQ) ' GZIP' $<
 	$(Q)gzip < $< > $@
 
-install: crda crda.8.gz regdbdump.8.gz
-	$(NQ) '  INSTALL  crda'
+
+install: install_execs install_udev install_man
+
+install_execs: $(INSTALL_EXECS)
 	$(Q)$(MKDIR) $(DESTDIR)/$(SBINDIR)
-	$(Q)$(INSTALL) -m 755 -t $(DESTDIR)/$(SBINDIR) crda
-	$(NQ) '  INSTALL  regdbdump'
-	$(Q)$(INSTALL) -m 755 -t $(DESTDIR)/$(SBINDIR) regdbdump
+	$(Q)for exec in $(INSTALL_EXECS) ; do \
+		echo "  INSTALL  $$exec" ; \
+		$(INSTALL) -m 755 -t $(DESTDIR)/$(SBINDIR) $$exec ; \
+		done
+
+.PHONY: install_udev
+install_udev:
+ifndef NO_INSTALL_UDEV
 	$(NQ) '  INSTALL  $(UDEV_LEVEL)regulatory.rules'
 	$(Q)$(MKDIR) $(DESTDIR)/$(UDEV_RULE_DIR)/
 	@# This removes the old rule you may have, we were not
@@ -127,6 +287,9 @@ install: crda crda.8.gz regdbdump.8.gz
 	$(Q)$(INSTALL) -m 644 -t \
 		$(DESTDIR)/$(UDEV_RULE_DIR)/ \
 		udev/$(UDEV_LEVEL)regulatory.rules
+endif
+
+install_man: $(INSTALL_MAN)
 	$(NQ) '  INSTALL  crda.8.gz'
 	$(Q)$(MKDIR) $(DESTDIR)$(MANDIR)/man8/
 	$(Q)$(INSTALL) -m 644 -t $(DESTDIR)/$(MANDIR)/man8/ crda.8.gz
@@ -134,5 +297,7 @@ install: crda crda.8.gz regdbdump.8.gz
 	$(Q)$(INSTALL) -m 644 -t $(DESTDIR)/$(MANDIR)/man8/ regdbdump.8.gz
 
 clean:
+	$(NQ) '    CLEAN'
 	$(Q)rm -f crda regdbdump intersect *.o *~ *.pyc keys-*.c *.gz \
 	udev/$(UDEV_LEVEL)regulatory.rules udev/regulatory.rules.parsed
+	$(Q)rm -rf host/ target/


