Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:4326 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757009AbZJLPDW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 11:03:22 -0400
Message-ID: <4AD34515.5080008@canonical.com>
Date: Mon, 12 Oct 2009 09:02:45 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] crda: Cosmetic fix for udev path
Content-Type: multipart/mixed;
 boundary="------------080202090204090304090202"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080202090204090304090202
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Luis,

This patch is against
git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/crda.git. It fixes
some complaints about an extra '/'.

rtg
-- 
Tim Gardner tim.gardner@canonical.com

--------------080202090204090304090202
Content-Type: text/x-patch;
 name="0001-Cosmetic-fix-for-udev-path.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-Cosmetic-fix-for-udev-path.patch"

>From 31a08704192dee87ee592f70988ee7806c37523a Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Mon, 12 Oct 2009 08:53:31 -0600
Subject: [PATCH] crda: Cosmetic fix for udev path

BugLink: http://bugs.launchpad.net/bugs/340995

SBINDIR already has a trailing '/', so its not needed
in the udev rule.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 udev/regulatory.rules |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/udev/regulatory.rules b/udev/regulatory.rules
index 5588ed7..3d6add8 100644
--- a/udev/regulatory.rules
+++ b/udev/regulatory.rules
@@ -2,4 +2,4 @@
 # For more information see:
 # http://wireless.kernel.org/en/developers/Regulatory/CRDA
 
-KERNEL=="regulatory*", ACTION=="change", SUBSYSTEM=="platform", RUN+="$(SBINDIR)/crda"
+KERNEL=="regulatory*", ACTION=="change", SUBSYSTEM=="platform", RUN+="$(SBINDIR)crda"
-- 
1.6.2.4


--------------080202090204090304090202--
