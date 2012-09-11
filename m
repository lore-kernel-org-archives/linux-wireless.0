Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:37892 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756958Ab2IKBcC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 21:32:02 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 07/10] mwifiex: do not hint regulatory domain with f/w country code
Date: Mon, 10 Sep 2012 18:30:46 -0700
Message-Id: <1347327049-13665-8-git-send-email-bzhao@marvell.com> (sfid-20120911_033206_827433_72AC11C7)
In-Reply-To: <1347327049-13665-1-git-send-email-bzhao@marvell.com>
References: <1347327049-13665-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We will use world regulatory domain (country 00) as default
when driver is loaded. Later after a successful association
cfg80211 will change the regulatory domain to a specific country
if the AP has advertised country IE.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 3a27554..797f978 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1862,8 +1862,9 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 		return ret;
 	}
 	country_code = mwifiex_11d_code_2_region(priv->adapter->region_code);
-	if (country_code && regulatory_hint(wiphy, country_code))
-		dev_err(adapter->dev, "regulatory_hint() failed\n");
+	if (country_code)
+		dev_info(adapter->dev,
+			 "ignoring F/W country code %2.2s\n", country_code);
 
 	adapter->wiphy = wiphy;
 	return ret;
-- 
1.7.0.2

