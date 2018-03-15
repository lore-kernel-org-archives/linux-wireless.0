Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:34048 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751770AbeCOGZq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 02:25:46 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH] mwifiex: remove warnings in mwifiex_cmd_append_11n_tlv()
Date: Thu, 15 Mar 2018 11:50:32 +0530
Message-ID: <1521094832-6311-1-git-send-email-gbhat@marvell.com> (sfid-20180315_072553_279100_14403DC3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the following sparse warning in mwifiex_cmd_append_11n_tlv:
drivers/net/wireless/marvell/mwifiex/11n.c:358:65: warning: invalid assignment: &=
drivers/net/wireless/marvell/mwifiex/11n.c:358:65:    left side has type restricted __le16
drivers/net/wireless/marvell/mwifiex/11n.c:358:65:    right side has type int
drivers/net/wireless/marvell/mwifiex/11n.c:360:65: warning: invalid assignment: &=
drivers/net/wireless/marvell/mwifiex/11n.c:360:65:    left side has type restricted __le16
drivers/net/wireless/marvell/mwifiex/11n.c:360:65:    right side has type int
drivers/net/wireless/marvell/mwifiex/11n.c:366:65: warning: invalid assignment: &=
drivers/net/wireless/marvell/mwifiex/11n.c:366:65:    left side has type restricted __le16
drivers/net/wireless/marvell/mwifiex/11n.c:366:65:    right side has type int
drivers/net/wireless/marvell/mwifiex/11n.c:368:65: warning: invalid assignment: &=
drivers/net/wireless/marvell/mwifiex/11n.c:368:65:    left side has type restricted __le16
drivers/net/wireless/marvell/mwifiex/11n.c:368:65:    right side has type int

This is a follow up to commit 77423fa73927
("mwifiex: fix incorrect ht capability problem")

Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/11n.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n.c b/drivers/net/wireless/marvell/mwifiex/11n.c
index feebfdc..5d75c97 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n.c
@@ -356,17 +356,19 @@ int mwifiex_cmd_11n_cfg(struct mwifiex_private *priv,
 			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
 				if (chan->flags & IEEE80211_CHAN_NO_HT40PLUS) {
 					ht_cap->ht_cap.cap_info &=
-					~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+					cpu_to_le16
+					(~IEEE80211_HT_CAP_SUP_WIDTH_20_40);
 					ht_cap->ht_cap.cap_info &=
-					~IEEE80211_HT_CAP_SGI_40;
+					cpu_to_le16(~IEEE80211_HT_CAP_SGI_40);
 				}
 				break;
 			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
 				if (chan->flags & IEEE80211_CHAN_NO_HT40MINUS) {
 					ht_cap->ht_cap.cap_info &=
-					~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+					cpu_to_le16
+					(~IEEE80211_HT_CAP_SUP_WIDTH_20_40);
 					ht_cap->ht_cap.cap_info &=
-					~IEEE80211_HT_CAP_SGI_40;
+					cpu_to_le16(~IEEE80211_HT_CAP_SGI_40);
 				}
 				break;
 			}
-- 
1.9.1
