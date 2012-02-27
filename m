Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59998 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab2B0PyN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 10:54:13 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com
Subject: [PATCH] compat-wireless: use portable #! for bash scripts
Date: Mon, 27 Feb 2012 15:35:46 +0100
Message-Id: <1330353346-62125-1-git-send-email-nbd@openwrt.org> (sfid-20120227_165416_830989_79CB407A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some systems (e.g. FreeBSD) do not have bash in /bin
Based on a patch by Jo-Philipp Wich

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 scripts/admin-clean.sh         |    2 +-
 scripts/admin-refresh.sh       |    2 +-
 scripts/admin-update.sh        |    2 +-
 scripts/check_config.sh        |    2 +-
 scripts/driver-select          |    2 +-
 scripts/gen-compat-autoconf.sh |    2 +-
 scripts/gen-stable-release.sh  |    2 +-
 scripts/skip-colors            |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/scripts/admin-clean.sh b/scripts/admin-clean.sh
index 86d5460..81398f2 100755
--- a/scripts/admin-clean.sh
+++ b/scripts/admin-clean.sh
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/usr/bin/env bash
 if [ -d net ] ; then
 	make clean
 fi
diff --git a/scripts/admin-refresh.sh b/scripts/admin-refresh.sh
index 5848b1e..caf63e0 100755
--- a/scripts/admin-refresh.sh
+++ b/scripts/admin-refresh.sh
@@ -1,3 +1,3 @@
-#!/bin/bash
+#!/usr/bin/env bash
 ./scripts/admin-clean.sh $@
 ./scripts/admin-update.sh $@
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index 9c1c5a4..369cc96 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/usr/bin/env bash
 # 
 # Copyright 2007, 2008, 2010	Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
 #
diff --git a/scripts/check_config.sh b/scripts/check_config.sh
index 1804976..1a08442 100755
--- a/scripts/check_config.sh
+++ b/scripts/check_config.sh
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/usr/bin/env bash
 # This script checks the compat-wireless configuration file and if changes were made
 # regenerates the compat_autoconf header.
 
diff --git a/scripts/driver-select b/scripts/driver-select
index 3855bc5..db07ee5 100755
--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/usr/bin/env bash
 # Copyright 2009        Luis R. Rodriguez <mcgrof@gmail.com>
 #
 # This script allows you to select your compat-wireless driver and
diff --git a/scripts/gen-compat-autoconf.sh b/scripts/gen-compat-autoconf.sh
index 58a1c51..87257c6 100755
--- a/scripts/gen-compat-autoconf.sh
+++ b/scripts/gen-compat-autoconf.sh
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/usr/bin/env bash
 # 
 # Copyright 2007	Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
 #
diff --git a/scripts/gen-stable-release.sh b/scripts/gen-stable-release.sh
index a271074..9764730 100755
--- a/scripts/gen-stable-release.sh
+++ b/scripts/gen-stable-release.sh
@@ -1,4 +1,4 @@
-#!/bin/bash
+#!/usr/bin/env bash
 # Copyright 2009  Luis R. Rodriguez <mcgrof@gmail.com>
 #
 # You can use this to make stable compat-wireless releases
diff --git a/scripts/skip-colors b/scripts/skip-colors
index 121626f..7123808 100755
--- a/scripts/skip-colors
+++ b/scripts/skip-colors
@@ -1,2 +1,2 @@
-#!/bin/bash
+#!/usr/bin/env bash
 perl -pe 's|(\e)\[(\d+)(;*)(\d*)(\w)||g'
-- 
1.7.3.2

