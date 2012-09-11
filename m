Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:52412 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756918Ab2IKBbs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 21:31:48 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 04/10] mwifiex: have same priority for AP and station traffic
Date: Mon, 10 Sep 2012 18:30:43 -0700
Message-Id: <1347327049-13665-5-git-send-email-bzhao@marvell.com> (sfid-20120911_033151_304823_2A39531F)
In-Reply-To: <1347327049-13665-1-git-send-email-bzhao@marvell.com>
References: <1347327049-13665-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Currently AP interface has higher priority over station. Hence
separate entries are created in "adapter->bss_prio_tbl" for these
interfaces and station packet is dequeued only if there is not
packet in queue for AP. It is observed that ping for station
interface doesn't work if heavy traffic is running on AP.

The problem is fixed by having same priority for both the
interfaces. This patch also removes an extra initialisation
for "priv->bss_priority".

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    4 ++--
 drivers/net/wireless/mwifiex/main.c     |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index f7a06d2..7113086 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1641,7 +1641,7 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 
 		priv->bss_type = MWIFIEX_BSS_TYPE_STA;
 		priv->frame_type = MWIFIEX_DATA_FRAME_TYPE_ETH_II;
-		priv->bss_priority = MWIFIEX_BSS_ROLE_STA;
+		priv->bss_priority = 0;
 		priv->bss_role = MWIFIEX_BSS_ROLE_STA;
 		priv->bss_num = 0;
 
@@ -1664,7 +1664,7 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 
 		priv->bss_type = MWIFIEX_BSS_TYPE_UAP;
 		priv->frame_type = MWIFIEX_DATA_FRAME_TYPE_ETH_II;
-		priv->bss_priority = MWIFIEX_BSS_ROLE_UAP;
+		priv->bss_priority = 0;
 		priv->bss_role = MWIFIEX_BSS_ROLE_UAP;
 		priv->bss_started = 0;
 		priv->bss_num = 0;
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index cb11552..bfd6667 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -72,7 +72,6 @@ static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
 			goto error;
 
 		adapter->priv[i]->adapter = adapter;
-		adapter->priv[i]->bss_priority = i;
 		adapter->priv_num++;
 	}
 	mwifiex_init_lock_list(adapter);
-- 
1.7.0.2

