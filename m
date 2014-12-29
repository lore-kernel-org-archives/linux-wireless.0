Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:64881 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaL2GYi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2014 01:24:38 -0500
Received: by mail-wi0-f169.google.com with SMTP id r20so22878843wiv.0
        for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2014 22:24:37 -0800 (PST)
Received: from muse.ger.corp.intel.com (85-250-108-142.bb.netvision.net.il. [85.250.108.142])
        by mx.google.com with ESMTPSA id gb10sm23488030wjb.21.2014.12.28.22.24.36
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 28 Dec 2014 22:24:37 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 13/13] wl18xx: declare radar_detect_widths support for ap interfaces
Date: Mon, 29 Dec 2014 08:24:13 +0200
Message-Id: <1419834253-18331-13-git-send-email-eliad@wizery.com> (sfid-20141229_074347_189276_93DD230F)
In-Reply-To: <1419834253-18331-1-git-send-email-eliad@wizery.com>
References: <1419834253-18331-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After having all the dfs infrastructure in place, declare
radar_detect_widths support for the ap interfaces combination.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 604de24..e5bc557 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1799,6 +1799,10 @@ wl18xx_iface_combinations[] = {
 		.limits = wl18xx_iface_ap_limits,
 		.n_limits = ARRAY_SIZE(wl18xx_iface_ap_limits),
 		.num_different_channels = 1,
+		.radar_detect_widths =	BIT(NL80211_CHAN_NO_HT) |
+					BIT(NL80211_CHAN_HT20) |
+					BIT(NL80211_CHAN_HT40MINUS) |
+					BIT(NL80211_CHAN_HT40PLUS),
 	}
 };
 
-- 
1.8.5.2.229.g4448466.dirty

