Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:22582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbXHSSaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 14:30:35 -0400
Received: by ug-out-1314.google.com with SMTP id j3so446922ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 11:30:35 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 08/30] rt2x00: Fix width of filter field.
Date: Sun, 19 Aug 2007 20:24:01 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com>
In-Reply-To: <200708192018.30624.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192024.01210.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 47c06acef36889c67594dadb4a29879d28c8415b Mon Sep 17 00:00:00 2001
From: Mattias Nissler <mattias.nissler@gmx.de>
Date: Sat, 4 Aug 2007 19:18:44 +0200
Subject: [PATCH 08/30] rt2x00: Fix width of filter field.

The filter field needs to be declared unsigned short instead of char
in order to hold all relevant IFF_* flags.

Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00.h b/drivers/net/wireless/rt2x00.h
index 31f8a13..0db81eb 100644
--- a/drivers/net/wireless/rt2x00.h
+++ b/drivers/net/wireless/rt2x00.h
@@ -304,7 +304,7 @@ struct interface {
 	 * the monitor mode interfaces are removed, while a
 	 * non-monitor mode interface remains.
 	 */
-	char filter;
+	unsigned short filter;
 
 	/*
 	 * Monitor mode count, the number of interfaces
-- 
1.5.3.rc5

