Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:56464 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab1IVFxU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 01:53:20 -0400
Received: from localhost.localdomain (unknown [193.140.74.51])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: ozan)
	by lider.pardus.org.tr (Postfix) with ESMTPSA id E5E7EA7AB17
	for <linux-wireless@vger.kernel.org>; Thu, 22 Sep 2011 08:48:21 +0300 (EEST)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] compat: add pm_runtime_enabled() for kver < 2.6.38
Date: Thu, 22 Sep 2011 08:50:59 +0300
Message-Id: <1316670659-4785-1-git-send-email-ozan@pardus.org.tr> (sfid-20110922_075326_939443_7ED9E545)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without this, the build of wl12xx/sdio.c fails.

Signed-off-by: Ozan Çağlayan <ozan@pardus.org.tr>
---
 include/linux/compat-2.6.38.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.38.h b/include/linux/compat-2.6.38.h
index 1f9ab52..d6da16e 100644
--- a/include/linux/compat-2.6.38.h
+++ b/include/linux/compat-2.6.38.h
@@ -11,6 +11,10 @@
 /* rename member in struct mmc_host in include/linux/mmc/host.h */
 #define max_segs	max_hw_segs
 
+static inline bool pm_runtime_enabled(struct device *dev)
+{
+	return !dev->power.disable_depth;
+}
 
 /* Exponentially weighted moving average (EWMA) */
 
-- 
1.7.6

