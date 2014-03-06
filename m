Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37760 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143AbaCFP1L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 10:27:11 -0500
Date: Thu, 6 Mar 2014 20:42:58 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 2/2] mwl8k: mwl8k_update_survey can be static
Message-ID: <5578b27253e21c67722b3250a7975dac2be81775.1394107732.git.yogeshp@marvell.com> (sfid-20140306_162715_173455_CD4CB83B)
References: <cover.1394107732.git.yogeshp@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <cover.1394107732.git.yogeshp@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It fixes following sparse check warning
>#make C=1 CF=-D__CHECK_ENDIAN__ drivers/net/wireless/mwl8k.o
>drivers/net/wireless/mwl8k.c:3089:6: warning: symbol 'mwl8k_update_survey' was not declared. Should it be static?

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 706a445..3c0a0a8 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3088,8 +3088,8 @@ exit:
 	return idx;
 }
 
-void mwl8k_update_survey(struct mwl8k_priv *priv,
-			 struct ieee80211_channel *channel)
+static void mwl8k_update_survey(struct mwl8k_priv *priv,
+				struct ieee80211_channel *channel)
 {
 	u32 cca_cnt, rx_rdy;
 	s8 nf = 0, idx;
-- 
1.8.3.4

