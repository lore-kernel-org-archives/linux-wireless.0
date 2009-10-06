Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:28536 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226AbZJFMZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 08:25:38 -0400
Received: by ey-out-2122.google.com with SMTP id 4so783834eyf.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2009 05:24:29 -0700 (PDT)
Message-ID: <4ACB390A.9070002@gmail.com>
Date: Tue, 06 Oct 2009 14:33:14 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mac80211: fix ADM8211_SYNCTL_RFtype define
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A logical of shifts to the left doesn't make sense.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
I think this was intended? ADM8211_SYNCTL_RFtype is not used anywhere.

diff --git a/drivers/net/wireless/adm8211.h b/drivers/net/wireless/adm8211.h
index 4f6ab13..b07e4d3 100644
--- a/drivers/net/wireless/adm8211.h
+++ b/drivers/net/wireless/adm8211.h
@@ -266,7 +266,7 @@ do {								\
 #define ADM8211_SYNCTL_CS1	(1 << 28)
 #define ADM8211_SYNCTL_CAL	(1 << 27)
 #define ADM8211_SYNCTL_SELCAL	(1 << 26)
-#define ADM8211_SYNCTL_RFtype	((1 << 24) || (1 << 23) || (1 << 22))
+#define ADM8211_SYNCTL_RFtype	((1 << 24) | (1 << 23) | (1 << 22))
 #define ADM8211_SYNCTL_RFMD	(1 << 22)
 #define ADM8211_SYNCTL_GENERAL	(0x7 << 22)
 /* SYNCTL 21:0 Data (Si4126: 18-bit data, 4-bit address) */
