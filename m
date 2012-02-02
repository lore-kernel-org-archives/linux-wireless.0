Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:55038 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753802Ab2BBEnI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 23:43:08 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: enable HT operating mode
Date: Wed,  1 Feb 2012 20:41:45 -0800
Message-Id: <1328157705-21564-3-git-send-email-bzhao@marvell.com> (sfid-20120202_054313_892665_8E7D7377)
In-Reply-To: <1328157705-21564-1-git-send-email-bzhao@marvell.com>
References: <1328157705-21564-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This patch sets default adapter channel_type as HT. Hence the device
will opearate in HT mode.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index e13b6d9..83cc10f 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -280,6 +280,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->adhoc_awake_period = 0;
 	memset(&adapter->arp_filter, 0, sizeof(adapter->arp_filter));
 	adapter->arp_filter_size = 0;
+	adapter->channel_type = NL80211_CHAN_HT20;
 }
 
 /*
-- 
1.7.0.2

