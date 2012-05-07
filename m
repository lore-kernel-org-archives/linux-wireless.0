Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:60065 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756116Ab2EGKdI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:33:08 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 19/20] feature-removal: Remove pn544 raw driver
Date: Mon,  7 May 2012 12:31:30 +0200
Message-Id: <1336386691-24840-20-git-send-email-sameo@linux.intel.com> (sfid-20120507_123311_588750_A02F2739)
In-Reply-To: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
References: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The pn544_hci driver uses the kernel NFC APIs while pn544 does not.
Moreover pn544 is outdated and not maintained.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 Documentation/feature-removal-schedule.txt |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 709e08e..dfb8b50 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -531,3 +531,15 @@ Why:	There appear to be no production users of the get_robust_list syscall,
 	of ASLR. It was only ever intended for debugging, so it should be
 	removed.
 Who:	Kees Cook <keescook@chromium.org>
+
+----------------------------
+
+What:	Removing the pn544 raw driver.
+When:	3.6
+Why:	With the introduction of the NFC HCI and SHDL kernel layers, pn544.c
+	is being replaced by pn544_hci.c which is accessible through the netlink
+	and socket NFC APIs. Moreover, pn544.c is outdated and does not seem to
+	work properly with the latest Android stacks.
+	Having 2 drivers for the same hardware is confusing and as such we
+	should only keep the one following the kernel NFC APIs.
+Who:	Samuel Ortiz <sameo@linux.intel.com>
-- 
1.7.9.1

