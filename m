Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:47830 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751326Ab2GCW4v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 18:56:51 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.5] mwifiex: fix Coverity SCAN CID 709078: Resource leak (RESOURCE_LEAK)
Date: Tue,  3 Jul 2012 15:53:13 -0700
Message-Id: <1341355993-4060-1-git-send-email-bzhao@marvell.com> (sfid-20120704_005655_064765_39DDCA75)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> *. CID 709078: Resource leak (RESOURCE_LEAK)
> 	- drivers/net/wireless/mwifiex/cfg80211.c, line: 935
> Assigning: "bss_cfg" = storage returned from "kzalloc(132UL, 208U)"
> 	- but was not free
> drivers/net/wireless/mwifiex/cfg80211.c:935

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 3875b1a..6c57e83 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1039,6 +1039,7 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 	case NL80211_HIDDEN_SSID_ZERO_CONTENTS:
 		/* firmware doesn't support this type of hidden SSID */
 	default:
+		kfree(bss_cfg);
 		return -EINVAL;
 	}
 
-- 
1.7.0.2

