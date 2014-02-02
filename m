Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ex6.cdburnerxp.se ([176.9.56.74]:46632 "EHLO ex6.cdburnerxp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbaBBFhJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Feb 2014 00:37:09 -0500
From: =?UTF-8?q?Cristian=20Rodr=C3=ADguez?= <crrodriguez@opensuse.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Cristian=20Rodr=C3=ADguez?= <crrodriguez@opensuse.org>
Subject: [PATCH] [iw] Make the build system automake based
Date: Sun,  2 Feb 2014 05:30:50 +0000
Message-Id: <1391319050-100614-1-git-send-email-crrodriguez@opensuse.org> (sfid-20140202_063742_854071_7B70685F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simply run autoreconf -fiv to use.

Should make libnl selection easier and in particular make
distribution packagers significantly less grumpy as "hand written"
makefiles are a permanent maintenance burden.
---
 .gitignore      |  13 ++++
 Android.mk      |   3 -
 Makefile        | 124 --------------------------------------
 Makefile.am     |  25 ++++++++
 configure.ac    |  33 +++++++++++
 git-version-gen | 181 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 iw.c            |   1 +
 iw.h            |   2 -
 version.sh      |  23 -------
 9 files changed, 253 insertions(+), 152 deletions(-)
 delete mode 100644 Makefile
 create mode 100644 Makefile.am
 create mode 100644 configure.ac
 create mode 100755 git-version-gen
 delete mode 100755 version.sh

diff --git a/.gitignore b/.gitignore
index 16bb88b..0eecca6 100644
--- a/.gitignore
+++ b/.gitignore
@@ -5,3 +5,16 @@ iw
 version.c
 iw.8.gz
 *-stamp
+Makefile.in
+/autom4te.cache
+/aclocal.m4
+/compile
+/configure
+/depcomp
+/install-sh
+/missing
+/stamp-h1
+/build-aux
+.version
+.tarball_version
+
diff --git a/Android.mk b/Android.mk
index 8afda1d..6f50b4f 100644
--- a/Android.mk
+++ b/Android.mk
@@ -19,7 +19,4 @@ LOCAL_MODULE_TAGS := eng
 LOCAL_SHARED_LIBRARIES := libnl_2
 LOCAL_MODULE := iw
 
-$(IW_SOURCE_DIR)/version.c:
-	$(IW_SOURCE_DIR)/version.sh $(IW_SOURCE_DIR)/version.c
-
 include $(BUILD_EXECUTABLE)
diff --git a/Makefile b/Makefile
deleted file mode 100644
index f042e30..0000000
--- a/Makefile
+++ /dev/null
@@ -1,124 +0,0 @@
-MAKEFLAGS += --no-print-directory
-
-PREFIX ?= /usr
-SBINDIR ?= $(PREFIX)/sbin
-MANDIR ?= $(PREFIX)/share/man
-PKG_CONFIG ?= pkg-config
-
-MKDIR ?= mkdir -p
-INSTALL ?= install
-CC ?= "gcc"
-
-CFLAGS ?= -O2 -g
-CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration
-
-OBJS = iw.o genl.o event.o info.o phy.o \
-	interface.o ibss.o station.o survey.o util.o \
-	mesh.o mpath.o scan.o reg.o version.o \
-	reason.o status.o connect.o link.o offch.o ps.o cqm.o \
-	bitrate.o wowlan.o coalesce.o roc.o p2p.o
-OBJS += sections.o
-
-OBJS-$(HWSIM) += hwsim.o
-
-OBJS += $(OBJS-y) $(OBJS-Y)
-
-ALL = iw
-
-ifeq ($(NO_PKG_CONFIG),)
-NL3xFOUND := $(shell $(PKG_CONFIG) --atleast-version=3.2 libnl-3.0 && echo Y)
-ifneq ($(NL3xFOUND),Y)
-NL31FOUND := $(shell $(PKG_CONFIG) --exact-version=3.1 libnl-3.1 && echo Y)
-ifneq ($(NL31FOUND),Y)
-NL3FOUND := $(shell $(PKG_CONFIG) --atleast-version=3 libnl-3.0 && echo Y)
-ifneq ($(NL3FOUND),Y)
-NL2FOUND := $(shell $(PKG_CONFIG) --atleast-version=2 libnl-2.0 && echo Y)
-ifneq ($(NL2FOUND),Y)
-NL1FOUND := $(shell $(PKG_CONFIG) --atleast-version=1 libnl-1 && echo Y)
-endif
-endif
-endif
-endif
-
-ifeq ($(NL1FOUND),Y)
-NLLIBNAME = libnl-1
-endif
-
-ifeq ($(NL2FOUND),Y)
-CFLAGS += -DCONFIG_LIBNL20
-LIBS += -lnl-genl
-NLLIBNAME = libnl-2.0
-endif
-
-ifeq ($(NL3xFOUND),Y)
-# libnl 3.2 might be found as 3.2 and 3.0
-NL3FOUND = N
-CFLAGS += -DCONFIG_LIBNL30
-LIBS += -lnl-genl-3
-NLLIBNAME = libnl-3.0
-endif
-
-ifeq ($(NL3FOUND),Y)
-CFLAGS += -DCONFIG_LIBNL30
-LIBS += -lnl-genl
-NLLIBNAME = libnl-3.0
-endif
-
-# nl-3.1 has a broken libnl-gnl-3.1.pc file
-# as show by pkg-config --debug --libs --cflags --exact-version=3.1 libnl-genl-3.1;echo $?
-ifeq ($(NL31FOUND),Y)
-CFLAGS += -DCONFIG_LIBNL30
-LIBS += -lnl-genl
-NLLIBNAME = libnl-3.1
-endif
-
-ifeq ($(NLLIBNAME),)
-$(error Cannot find development files for any supported version of libnl)
-endif
-
-LIBS += $(shell $(PKG_CONFIG) --libs $(NLLIBNAME))
-CFLAGS += $(shell $(PKG_CONFIG) --cflags $(NLLIBNAME))
-endif # NO_PKG_CONFIG
-
-ifeq ($(V),1)
-Q=
-NQ=true
-else
-Q=@
-NQ=echo
-endif
-
-all: $(ALL)
-
-VERSION_OBJS := $(filter-out version.o, $(OBJS))
-
-version.c: version.sh $(patsubst %.o,%.c,$(VERSION_OBJS)) nl80211.h iw.h Makefile \
-		$(wildcard .git/index .git/refs/tags)
-	@$(NQ) ' GEN ' $@
-	$(Q)./version.sh $@
-
-%.o: %.c iw.h nl80211.h
-	@$(NQ) ' CC  ' $@
-	$(Q)$(CC) $(CFLAGS) -c -o $@ $<
-
-iw:	$(OBJS)
-	@$(NQ) ' CC  ' iw
-	$(Q)$(CC) $(LDFLAGS) $(OBJS) $(LIBS) -o iw
-
-check:
-	$(Q)$(MAKE) all CC="REAL_CC=$(CC) CHECK=\"sparse -Wall\" cgcc"
-
-%.gz: %
-	@$(NQ) ' GZIP' $<
-	$(Q)gzip < $< > $@
-
-install: iw iw.8.gz
-	@$(NQ) ' INST iw'
-	$(Q)$(MKDIR) $(DESTDIR)$(SBINDIR)
-	$(Q)$(INSTALL) -m 755 iw $(DESTDIR)$(SBINDIR)
-	@$(NQ) ' INST iw.8'
-	$(Q)$(MKDIR) $(DESTDIR)$(MANDIR)/man8/
-	$(Q)$(INSTALL) -m 644 iw.8.gz $(DESTDIR)$(MANDIR)/man8/
-
-clean:
-	$(Q)rm -f iw *.o *~ *.gz version.c *-stamp
diff --git a/Makefile.am b/Makefile.am
new file mode 100644
index 0000000..5ce5f2b
--- /dev/null
+++ b/Makefile.am
@@ -0,0 +1,25 @@
+AM_CPPFLAGS = -include config.h
+AM_CFLAGS = $(LIBNL_CFLAGS) -fvisibility=hidden -ffunction-sections -fdata-sections \
+			-Wundef -Wno-trigraphs -Wall -Wmissing-declarations -Wmissing-prototypes \
+			-Wredundant-decls -Wshadow -Wstrict-prototypes -Wformat=2 -fno-common \
+			-Werror-implicit-function-declaration -ffast-math
+
+AM_LDFLAGS = -Wl,--gc-sections -Wl,--as-needed -Wl,--no-add-needed -Wl,-z,relro,-z,now
+
+sbin_PROGRAMS = iw
+dist_man8_MANS = iw.8
+
+iw_SOURCES = coalesce.c cqm.c genl.c ibss.c info.c iw.c link.c mpath.c offch.c phy.c reason.c roc.c sections.c status.c util.c \
+			 bitrate.c connect.c event.c hwsim.c ieee80211.h interface.c iw.h mesh.c nl80211.h p2p.c ps.c reg.c scan.c station.c survey.c wowlan.c
+
+iw_LDADD = $(LIBNL_LIBS)
+
+EXTRA_DIST = android-nl.c COPYING README Android.mk git-version-gen
+
+BUILT_SOURCES = $(top_srcdir)/.version
+
+$(top_srcdir)/.version:
+	echo $(VERSION) > $@-t && mv $@-t $@
+
+dist-hook:
+	echo $(VERSION) > $(distdir)/.tarball-version
diff --git a/configure.ac b/configure.ac
new file mode 100644
index 0000000..4394f4c
--- /dev/null
+++ b/configure.ac
@@ -0,0 +1,33 @@
+#                                               -*- Autoconf -*-
+# Process this file with autoconf to produce a configure script.
+
+AC_PREREQ([2.60])
+AC_LANG([C])
+AC_INIT([iw], m4_esyscmd([./git-version-gen .tarball_version]), [linux-wireless@vger.kernel.org])
+AC_CONFIG_SRCDIR([iw.c])
+AC_CONFIG_AUX_DIR([build-aux])
+AC_CONFIG_HEADERS([config.h])
+AM_INIT_AUTOMAKE([1.11 foreign -Wall -Wno-portability tar-pax no-dist-gzip dist-xz silent-rules])
+AM_SILENT_RULES([yes])
+
+# Checks for programs.
+AC_PROG_CC_STDC
+AC_USE_SYSTEM_EXTENSIONS
+AC_SYS_LARGEFILE
+AC_PROG_INSTALL
+
+# Checks for libraries.
+PKG_PROG_PKG_CONFIG
+
+PKG_CHECK_MODULES([LIBNL], [libnl-3.0 >= 3.0 libnl-genl-3.0 >= 3.0], [has_libnl_ver=3], [
+PKG_CHECK_MODULES([LIBNL], [libnl-2.0 >= 2.0], [has_libnl_ver=2], [
+PKG_CHECK_MODULES([LIBNL], [libnl-1], [has_libnl_ver=1], [has_libnl_ver=0])])])
+
+AS_CASE([$has_libnl_ver],
+        [0], [AC_MSG_ERROR([libnl and libnl-genl are required but were not found])],
+        [2], [AC_DEFINE([CONFIG_LIBNL20], [1], [Use libnl 2])],
+        [3], [AC_DEFINE([CONFIG_LIBNL30], [1], [Use libnl 3])]
+)
+
+AC_CONFIG_FILES([Makefile])
+AC_OUTPUT
diff --git a/git-version-gen b/git-version-gen
new file mode 100755
index 0000000..1df20c3
--- /dev/null
+++ b/git-version-gen
@@ -0,0 +1,181 @@
+#!/bin/sh
+# Print a version string.
+scriptversion=2011-02-19.19; # UTC
+
+# Copyright (C) 2007-2011 Free Software Foundation, Inc.
+#
+# This program is free software: you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 3 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program.  If not, see <http://www.gnu.org/licenses/>.
+
+# This script is derived from GIT-VERSION-GEN from GIT: http://git.or.cz/.
+# It may be run two ways:
+# - from a git repository in which the "git describe" command below
+#   produces useful output (thus requiring at least one signed tag)
+# - from a non-git-repo directory containing a .tarball-version file, which
+#   presumes this script is invoked like "./git-version-gen .tarball-version".
+
+# In order to use intra-version strings in your project, you will need two
+# separate generated version string files:
+#
+# .tarball-version - present only in a distribution tarball, and not in
+#   a checked-out repository.  Created with contents that were learned at
+#   the last time autoconf was run, and used by git-version-gen.  Must not
+#   be present in either $(srcdir) or $(builddir) for git-version-gen to
+#   give accurate answers during normal development with a checked out tree,
+#   but must be present in a tarball when there is no version control system.
+#   Therefore, it cannot be used in any dependencies.  GNUmakefile has
+#   hooks to force a reconfigure at distribution time to get the value
+#   correct, without penalizing normal development with extra reconfigures.
+#
+# .version - present in a checked-out repository and in a distribution
+#   tarball.  Usable in dependencies, particularly for files that don't
+#   want to depend on config.h but do want to track version changes.
+#   Delete this file prior to any autoconf run where you want to rebuild
+#   files to pick up a version string change; and leave it stale to
+#   minimize rebuild time after unrelated changes to configure sources.
+#
+# It is probably wise to add these two files to .gitignore, so that you
+# don't accidentally commit either generated file.
+#
+# Use the following line in your configure.ac, so that $(VERSION) will
+# automatically be up-to-date each time configure is run (and note that
+# since configure.ac no longer includes a version string, Makefile rules
+# should not depend on configure.ac for version updates).
+#
+# AC_INIT([GNU project],
+#         m4_esyscmd([build-aux/git-version-gen .tarball-version]),
+#         [bug-project@example])
+#
+# Then use the following lines in your Makefile.am, so that .version
+# will be present for dependencies, and so that .tarball-version will
+# exist in distribution tarballs.
+#
+# BUILT_SOURCES = $(top_srcdir)/.version
+# $(top_srcdir)/.version:
+#	echo $(VERSION) > $@-t && mv $@-t $@
+# dist-hook:
+#	echo $(VERSION) > $(distdir)/.tarball-version
+
+case $# in
+    1|2) ;;
+    *) echo 1>&2 "Usage: $0 \$srcdir/.tarball-version" \
+         '[TAG-NORMALIZATION-SED-SCRIPT]'
+       exit 1;;
+esac
+
+tarball_version_file=$1
+tag_sed_script="${2:-s/x/x/}"
+nl='
+'
+
+# Avoid meddling by environment variable of the same name.
+v=
+v_from_git=
+
+# First see if there is a tarball-only version file.
+# then try "git describe", then default.
+if test -f $tarball_version_file
+then
+    v=`cat $tarball_version_file` || v=
+    case $v in
+        *$nl*) v= ;; # reject multi-line output
+        [0-9]*) ;;
+        *) v= ;;
+    esac
+    test -z "$v" \
+        && echo "$0: WARNING: $tarball_version_file is missing or damaged" 1>&2
+fi
+
+if test -n "$v"
+then
+    : # use $v
+# Otherwise, if there is at least one git commit involving the working
+# directory, and "git describe" output looks sensible, use that to
+# derive a version string.
+elif test "`git log -1 --pretty=format:x . 2>&1`" = x \
+    && v=`git describe --abbrev=4 --match='v*' HEAD 2>/dev/null \
+          || git describe --abbrev=4 HEAD 2>/dev/null` \
+    && v=`printf '%s\n' "$v" | sed "$tag_sed_script"` \
+    && case $v in
+         v[0-9]*) ;;
+         *) (exit 1) ;;
+       esac
+then
+    # Is this a new git that lists number of commits since the last
+    # tag or the previous older version that did not?
+    #   Newer: v6.10-77-g0f8faeb
+    #   Older: v6.10-g0f8faeb
+    case $v in
+        *-rc[0-9]) ;; # release candidate
+        *-*-*) : git describe is okay three part flavor ;;
+        *-*)
+            : git describe is older two part flavor
+            # Recreate the number of commits and rewrite such that the
+            # result is the same as if we were using the newer version
+            # of git describe.
+            vtag=`echo "$v" | sed 's/-.*//'`
+            commit_list=`git rev-list "$vtag"..HEAD 2>/dev/null` \
+                || { commit_list=failed;
+                     echo "$0: WARNING: git rev-list failed" 1>&2; }
+            numcommits=`echo "$commit_list" | wc -l`
+            v=`echo "$v" | sed "s/\(.*\)-\(.*\)/\1-$numcommits-\2/"`;
+            test "$commit_list" = failed && v=UNKNOWN
+            ;;
+    esac
+
+    case $v in
+        *-rc[0-9])
+	    # Remove the "g" in git describe's output string, to save a byte.
+            v=`echo "$v" | sed 's/\(.*\)-g/\1-/'`;     
+	    ;;
+        *)
+	    # Change the first '-' to a '.', so version-comparing tools work properly.
+	    # Remove the "g" in git describe's output string, to save a byte.
+	    v=`echo "$v" | sed 's/-/./;s/\(.*\)-g/\1-/'`;
+	    ;;
+    esac
+    v_from_git=1
+else
+    v=UNKNOWN
+fi
+
+v=`echo "$v" |sed 's/^v//'`
+
+# Test whether to append the "-dirty" suffix only if the version
+# string we're using came from git.  I.e., skip the test if it's "UNKNOWN"
+# or if it came from .tarball-version.
+if test -n "$v_from_git"; then
+  # Don't declare a version "dirty" merely because a time stamp has changed.
+  git update-index --refresh > /dev/null 2>&1
+
+  dirty=`exec 2>/dev/null;git diff-index --name-only HEAD` || dirty=
+  case "$dirty" in
+      '') ;;
+      *) # Append the suffix only if there isn't one already.
+          case $v in
+            *-dirty) ;;
+            *) v="$v-dirty" ;;
+          esac ;;
+  esac
+fi
+
+# Omit the trailing newline, so that m4_esyscmd can use the result directly.
+echo "$v" | tr -d "$nl"
+
+# Local variables:
+# eval: (add-hook 'write-file-hooks 'time-stamp)
+# time-stamp-start: "scriptversion="
+# time-stamp-format: "%:y-%02m-%02d.%02H"
+# time-stamp-time-zone: "UTC"
+# time-stamp-end: "; # UTC"
+# End:
diff --git a/iw.c b/iw.c
index dc99566..5d82e62 100644
--- a/iw.c
+++ b/iw.c
@@ -43,6 +43,7 @@ static inline int nl_socket_set_buffer_size(struct nl_sock *sk,
 #endif /* CONFIG_LIBNL20 && CONFIG_LIBNL30 */
 
 int iw_debug = 0;
+static const char iw_version[] = VERSION;
 
 static int nl80211_init(struct nl80211_state *state)
 {
diff --git a/iw.h b/iw.h
index 317f0a6..45dc7c3 100644
--- a/iw.h
+++ b/iw.h
@@ -110,8 +110,6 @@ struct cmd {
 #define DECLARE_SECTION(_name)						\
 	extern struct cmd __section ## _ ## _name;
 
-extern const char iw_version[];
-
 extern int iw_debug;
 
 int handle_cmd(struct nl80211_state *state, enum id_input idby,
diff --git a/version.sh b/version.sh
deleted file mode 100755
index 8c55c77..0000000
--- a/version.sh
+++ /dev/null
@@ -1,23 +0,0 @@
-#!/bin/sh
-
-VERSION="3.14"
-OUT="$1"
-
-if [ -d .git ] && head=`git rev-parse --verify HEAD 2>/dev/null`; then
-	git update-index --refresh --unmerged > /dev/null
-	descr=$(git describe)
-
-	# on git builds check that the version number above
-	# is correct...
-	[ "${descr%%-*}" = "v$VERSION" ] || exit 2
-
-	v="${descr#v}"
-	if git diff-index --name-only HEAD | read dummy ; then
-		v="$v"-dirty
-	fi
-else
-	v="$VERSION"
-fi
-
-echo '#include "iw.h"' > "$OUT"
-echo "const char iw_version[] = \"$v\";" >> "$OUT"
-- 
1.8.4.5

