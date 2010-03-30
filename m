Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:54952 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750902Ab0C3Vuf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 17:50:35 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, <users@rt2x00.serialmonkey.com>,
	<linux-wireless@vger.kernel.org>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 2/4] rt2x00: Enable powersaving by default again on rt2500usb.
Date: Tue, 30 Mar 2010 23:50:24 +0200
Message-Id: <1269985826-17438-3-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1269985826-17438-1-git-send-email-gwingerde@gmail.com>
References: <1269985826-17438-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that the powersave issues on rt2500usb have been tackled, powersave
can be enabled by default again.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 54d2716..c1eec17 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1647,11 +1647,6 @@ static int rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	unsigned int i;
 
 	/*
-	 * Disable powersaving as default.
-	 */
-	rt2x00dev->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
-
-	/*
 	 * Initialize all hw fields.
 	 */
 	rt2x00dev->hw->flags =
-- 
1.7.0.3

