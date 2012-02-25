Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:35365 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750860Ab2BYFii (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Feb 2012 00:38:38 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.3] mwifiex: remove redundant scan operation
Date: Fri, 24 Feb 2012 21:35:36 -0800
Message-Id: <1330148136-28867-2-git-send-email-bzhao@marvell.com> (sfid-20120225_063841_454999_E1A76474)
In-Reply-To: <1330148136-28867-1-git-send-email-bzhao@marvell.com>
References: <1330148136-28867-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

It should have been removed by commit "mwifiex: use cfg80211 dynamic
scan..." (7c6fa2a843..) after adding code to avoid an extra scan
during association because scan entries are valid for 15 seconds in
cfg80211 stack.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index e4e6d7d..7b98ce0 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -924,12 +924,6 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len, u8 *ssid,
 		}
 	}
 done:
-	/* Do specific SSID scanning */
-	if (mwifiex_request_scan(priv, &req_ssid)) {
-		dev_err(priv->adapter->dev, "scan error\n");
-		return -EFAULT;
-	}
-
 	/*
 	 * Scan entries are valid for some time (15 sec). So we can save one
 	 * active scan time if we just try cfg80211_get_bss first. If it fails
-- 
1.7.0.2

