Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:61621 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143AbaCFP0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 10:26:55 -0500
Date: Thu, 6 Mar 2014 20:42:43 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 1/2] mwl8k: le32_to_cpu cast to restricted
Message-ID: <cd9a117fcdd729fbdaa462219969ab25a0724327.1394107732.git.yogeshp@marvell.com> (sfid-20140306_162659_433969_7B575119)
References: <cover.1394107732.git.yogeshp@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <cover.1394107732.git.yogeshp@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It fixes couple of sparse check
>#make C=1 CF=-D__CHECK_ENDIAN__ drivers/net/wireless/mwl8k.o
>drivers/net/wireless/mwl8k.c:3104:19: warning: cast to restricted __le32
>drivers/net/wireless/mwl8k.c:3108:18: warning: cast to restricted __le32

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index b6d83f6..706a445 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3103,11 +3103,11 @@ void mwl8k_update_survey(struct mwl8k_priv *priv,
 
 	survey = &priv->survey[idx];
 
-	cca_cnt = le32_to_cpu(ioread32(priv->regs + NOK_CCA_CNT_REG));
+	cca_cnt = ioread32(priv->regs + NOK_CCA_CNT_REG);
 	cca_cnt /= 1000; /* uSecs to mSecs */
 	survey->channel_time_busy = (u64) cca_cnt;
 
-	rx_rdy = le32_to_cpu(ioread32(priv->regs + BBU_RXRDY_CNT_REG));
+	rx_rdy = ioread32(priv->regs + BBU_RXRDY_CNT_REG);
 	rx_rdy /= 1000; /* uSecs to mSecs */
 	survey->channel_time_rx = (u64) rx_rdy;
 
-- 
1.8.3.4

