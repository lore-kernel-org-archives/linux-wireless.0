Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP01.calltower.com ([69.4.184.248]:3047 "EHLO
	L01SLCSMTP01.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754723AbZF3VT3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 17:19:29 -0400
Subject: [PATCH 4/5] Introduce separate HOST and TARGET compilation steps.
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 16:19:32 -0500
Message-Id: <1246396772.13176.264.camel@jdl-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The regdbdump tool is really a host executable that is used
during the build process.  It could also be installed and
used on the target, but two separate compilations are needed
to achieve that goal.

Currently, regdbdump is only built for the target, and thus
cross-compilation of the tool is really feasible without
this patch (or one like it).

Signed-off-by: Jon Loeliger <jdl@bigfootnetworks.com>
---
 Makefile |  250 +++++++++++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 199 insertions(+), 51 deletions(-)

diff --git a/Makefile b/Makefile
index 776b259..b755b67 100644
--- a/Makefile
+++ b/Makefile
@@ -24,45 +24,220 @@ UDEV_RULE_DIR?=/lib/udev/rules.d/
 # with make PUBKEY_DIR=/usr/lib/crda/pubkeys
 PUBKEY_DIR?=pubkeys
 
-CFLAGS += -Wall -g
 
-all: $(REG_BIN) crda intersect verify
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
+
+else
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
+endif
+
+
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
+
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
+	$(NQ) '  CC  ' $@
+	$(Q)$(CC) -c $(TARGET_CPPFLAGS) $(TARGET_CFLAGS) -o $@ $<
+
+
+host/crda: $(patsubst %,host/%,$(CRDA_OBJS))
+	$(NQ) '  LD  ' $@
+	$(Q)$(HOST_CC) $(HOST_CFLAGS) $(HOST_LDFLAGS) -o $@ $^ $(HOST_LDLIBS) $(HOST_LIBS_NL)
+
+host/regdbdump: $(patsubst %,host/%,$(REGDBDUMP_OBJS))
+	$(NQ) '  LD  ' $@
+	$(Q)$(HOST_CC) $(HOST_CFLAGS) $(HOST_LDFLAGS) -o $@ $^ $(HOST_LDLIBS)
+
+host/intersect: $(patsubst %,host/%,$(INTERSECT_OBJS))
+	$(NQ) '  LD  ' $@
+	$(Q)$(HOST_CC) $(HOST_CFLAGS) $(HOST_LDFLAGS) -o $@ $^ $(HOST_LDLIBS)
+
+host/reglib.o: $(HOST_KEYS_FILE)
+
+host/%.o: %.c regdb.h
+	$(NQ) '  HOST_CC  ' $@
+	$(Q)$(HOST_CC) -c $(HOST_CPPFLAGS) $(HOST_CFLAGS) -o $@ $<
+
+
+keys-%.c: utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem)
+	$(NQ) '  GEN ' $@
+	$(NQ) '  Trusted pubkeys:' $(wildcard $(PUBKEY_DIR)/*.pem)
+	$(Q)./utils/key2pub.py --$* $(wildcard $(PUBKEY_DIR)/*.pem) $@
+
+verify: $(REG_BIN) host/regdbdump
+	$(NQ) '  CHK  $(REG_BIN)'
+	$(Q)./host/regdbdump $(REG_BIN) >/dev/null
+
+
+MKDIR ?= mkdir -p
+INSTALL ?= install
 
 ifeq ($(V),1)
 Q=
@@ -72,9 +247,6 @@ Q=@
 NQ=@echo
 endif
 
-INSTALL_EXECS	:= crda
-INSTALL_MAN	:= crda.8.gz regdbdump.8.gz
-
 $(REG_BIN):
 	$(NQ) '  EXIST ' $(REG_BIN)
 	$(NQ)
@@ -87,31 +259,6 @@ $(REG_BIN):
 	$(NQ)
 	$(Q) exit 1
 
-keys-%.c: utils/key2pub.py $(wildcard $(PUBKEY_DIR)/*.pem)
-	$(NQ) '  GEN ' $@
-	$(NQ) '  Trusted pubkeys:' $(wildcard $(PUBKEY_DIR)/*.pem)
-	$(Q)./utils/key2pub.py --$* $(wildcard $(PUBKEY_DIR)/*.pem) $@
-
-%.o: %.c regdb.h
-	$(NQ) '  CC  ' $@
-	$(Q)$(CC) -c $(CPPFLAGS) $(CFLAGS) -o $@ $<
-
-crda: reglib.o crda.o
-	$(NQ) '  LD  ' $@
-	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS) $(NLLIBS)
-
-regdbdump: reglib.o regdbdump.o print-regdom.o
-	$(NQ) '  LD  ' $@
-	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
-
-intersect: reglib.o intersect.o print-regdom.o
-	$(NQ) '  LD  ' $@
-	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)
-
-verify: $(REG_BIN) regdbdump
-	$(NQ) '  CHK  $(REG_BIN)'
-	$(Q)./regdbdump $(REG_BIN) >/dev/null
-
 %.gz: %
 	@$(NQ) ' GZIP' $<
 	$(Q)gzip < $< > $@
@@ -152,3 +299,4 @@ clean:
 	$(NQ) '    CLEAN'
 	$(Q)rm -f crda regdbdump intersect *.o *~ *.pyc keys-*.c *.gz \
 	udev/$(UDEV_LEVEL)regulatory.rules udev/regulatory.rules.parsed
+	$(Q)rm -rf host/ target/
-- 
1.6.3.GIT



