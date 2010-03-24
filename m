Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:52739 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756822Ab0CXUmx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 16:42:53 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 1/2] rt2x00: Fix typo in RF register programming of rt2800.
Date: Wed, 24 Mar 2010 21:42:36 +0100
Message-Id: <1269463357-32563-2-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1269463357-32563-1-git-send-email-gwingerde@gmail.com>
References: <1269463357-32563-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 18d4d8e..326fce7 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -812,9 +812,9 @@ static void rt2800_config_channel_rt3x(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, 24,
 			      rt2x00dev->calibration[conf_is_ht40(conf)]);
 
-	rt2800_rfcsr_read(rt2x00dev, 23, &rfcsr);
+	rt2800_rfcsr_read(rt2x00dev, 7, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR7_RF_TUNING, 1);
-	rt2800_rfcsr_write(rt2x00dev, 23, rfcsr);
+	rt2800_rfcsr_write(rt2x00dev, 7, rfcsr);
 }
 
 static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
-- 
1.7.0.1

