Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:51765 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab2AXTgP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 14:36:15 -0500
Received: by qabg24 with SMTP id g24so2656923qab.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2012 11:36:14 -0800 (PST)
Message-ID: <4F1F0810.2000306@gmail.com> (sfid-20120124_203618_870540_464BB67C)
Date: Tue, 24 Jan 2012 14:35:44 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: [compat-wireless] modprobe -l is legacy compatibility mode and is
 being removed from some distros
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

module-init-tools has been deprecated in favor of kmod in Arch Linux, 
and kmod doesn't have the legacy --list option for modprobe.
This patch fixes the areas of the Makefile which actually needed the 
output of modprobe -l. The other 100's of uses are just to echo info to 
the screen which in this case will simply fail in an extremely noisy 
fashion yet non-fatal way.

Please apply to all branches.

Signed-of-By: Rick Farina <sidhayn@gmail.com>

diff -Naur compat-wireless-3.3-rc1-2/Makefile 
compat-wireless-3.3-rc1-2-modinfo-migration/Makefile
--- compat-wireless-3.3-rc1-2/Makefile    2012-01-21 02:00:21.000000000 
-0500
+++ compat-wireless-3.3-rc1-2-modinfo-migration/Makefile    2012-01-24 
14:27:20.000000000 -0500
@@ -9,11 +9,6 @@
  # Sometimes not available in the path
  MODPROBE := /sbin/modprobe

-ifneq ($(wildcard $(MODPROBE)),)
-MADWIFI=$(shell $(MODPROBE) -l ath_pci)
-OLD_IWL=$(shell $(MODPROBE) -l iwl4965)
-endif
-
  DESTDIR?=

  ifneq ($(KERNELRELEASE),)
@@ -188,7 +183,7 @@
      @install scripts/athload    $(DESTDIR)/usr/sbin/
      @install scripts/b43load    $(DESTDIR)/usr/sbin/
      @install scripts/iwl-load    $(DESTDIR)/usr/sbin/
-    @if [ ! -z "$(MADWIFI)" ] && [ -z "$(DESTDIR)" ]; then \
+    @if [ `modinfo ath_pci > /dev/null 2>&1` ] && [ -z "$(DESTDIR)" ]; 
then \
          echo ;\
          echo -n "Note: madwifi detected, we're going to disable it. "  ;\
          echo "If you would like to enable it later you can run:"  ;\
@@ -197,7 +192,7 @@
          echo Running athenable ath5k...;\
          /usr/sbin/athenable ath5k ;\
      fi
-    @if [ ! -z "$(OLD_IWL)" ] && [ -z "$(DESTDIR)" ]; then \
+    @if [ `modinfo iwl4965 > /dev/null 2>&1` ] && [ -z "$(DESTDIR)" ]; 
then \
          echo ;\
          echo -n "Note: iwl4965 detected, we're going to disable it. "  ;\
          echo "If you would like to enable it later you can run:"  ;\

