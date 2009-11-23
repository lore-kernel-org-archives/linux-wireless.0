Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:58421 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226AbZKWVo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 16:44:59 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH v2 1/8] rt2x00: Only initialize HT on rt2800 devices that support it.
Date: Mon, 23 Nov 2009 22:44:47 +0100
Message-Id: <1259012694-14869-2-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1259012694-14869-1-git-send-email-gwingerde@gmail.com>
References: <1259012694-14869-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some RT28xx/RT30xx devices don't support 802.11n, when they are combined with
the RF2020 chipset. Ensure that HT is disabled for these devices.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index e94f1e1..fcd0c88 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2072,7 +2072,11 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize HT information.
 	 */
-	spec->ht.ht_supported = true;
+	if (!rt2x00_rf(chip, RF2020))
+		spec->ht.ht_supported = true;
+	else
+		spec->ht.ht_supported = false;
+
 	spec->ht.cap =
 	    IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
 	    IEEE80211_HT_CAP_GRN_FLD |
-- 
1.6.5.3

