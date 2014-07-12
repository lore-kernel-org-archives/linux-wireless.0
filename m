Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52906 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754004AbaGLDy6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jul 2014 23:54:58 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	David Binderman <dcb314@hotmail.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/7] mwifiex: fix a cut-n-paste error in adhoc-start
Date: Fri, 11 Jul 2014 20:54:32 -0700
Message-ID: <1405137272-13872-1-git-send-email-bzhao@marvell.com> (sfid-20140712_055506_872411_C42AD13F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 'else if' branch never gets the chance as its condition
matches 'if' branch's.

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/join.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index fc13564..0b977ea 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -949,7 +949,7 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 				chan_tlv->chan_scan_param[0].radio_type |=
 					(IEEE80211_HT_PARAM_CHA_SEC_ABOVE << 4);
 			else if (adapter->sec_chan_offset ==
-					    IEEE80211_HT_PARAM_CHA_SEC_ABOVE)
+					    IEEE80211_HT_PARAM_CHA_SEC_BELOW)
 				chan_tlv->chan_scan_param[0].radio_type |=
 					(IEEE80211_HT_PARAM_CHA_SEC_BELOW << 4);
 		}
-- 
1.8.2.3

