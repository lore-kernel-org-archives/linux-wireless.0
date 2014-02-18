Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:52652 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbaBRBKn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 20:10:43 -0500
Received: by mail-ee0-f43.google.com with SMTP id c41so7393654eek.16
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 17:10:41 -0800 (PST)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	liuhq11@mails.tsinghua.edu.cn,
	andrea merello <andrea.merello@gmail.com>
Subject: [PATCH 5/7] rtl818x: add comments to explain few not obvious HW configs.
Date: Tue, 18 Feb 2014 02:10:44 +0100
Message-Id: <1392685846-10116-6-git-send-email-andrea.merello@gmail.com> (sfid-20140218_021047_966453_5E9348FB)
In-Reply-To: <1392685846-10116-1-git-send-email-andrea.merello@gmail.com>
References: <1392685846-10116-1-git-send-email-andrea.merello@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: andrea merello <andrea.merello@gmail.com>

Certain HW options (TX packet retry count, CW configuration and
TX power configuration) can be specified in both the TX packet
descriptor and also into HW "global" registers.

The HW is thus configured to honour the global register or the
TX descriptor field depending by the case.

This patch adds few comments that hopefully clarify in which cases
the driver uses one method and in which cases it uses the other.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index cb97380..be9a8a1 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -634,11 +634,23 @@ static int rtl8180_start(struct ieee80211_hw *dev)
 
 	if (priv->r8185) {
 		reg = rtl818x_ioread8(priv, &priv->map->CW_CONF);
+
+		/* CW is not on per-packet basis.
+		 * in rtl8185 the CW_VALUE reg is used.
+		 */
 		reg &= ~RTL818X_CW_CONF_PERPACKET_CW;
+		/* retry limit IS on per-packet basis.
+		 * the short and long retry limit in TX_CONF
+		 * reg are ignored
+		 */
 		reg |= RTL818X_CW_CONF_PERPACKET_RETRY;
 		rtl818x_iowrite8(priv, &priv->map->CW_CONF, reg);
 
 		reg = rtl818x_ioread8(priv, &priv->map->TX_AGC_CTL);
+		/* TX antenna and TX gain are not on per-packet basis.
+		 * TX Antenna is selected by ANTSEL reg (RX in BB regs).
+		 * TX gain is selected with CCK_TX_AGC and OFDM_TX_AGC regs
+		 */
 		reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_GAIN;
 		reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL;
 		reg |=  RTL818X_TX_AGC_CTL_FEEDBACK_ANT;
-- 
1.8.3.2

