Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49088 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab2IJHWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 03:22:00 -0400
MIME-Version: 1.0
Date: Mon, 10 Sep 2012 15:21:59 +0800
Message-ID: <CAPgLHd8FG3pEz3FZ=1ux=h5sKGXwykXc=qafb=OzEQKXWU9uuw@mail.gmail.com> (sfid-20120910_092210_204402_61A95019)
Subject: [PATCH v2] rndis_wlan: remove pointless check from rndis_scan()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: jussi.kivilinna@mbnet.fi, linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In rndis_scan(), 'request' is actually always valid pointer and
the !request check is unneeded, so remove it.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/rndis_wlan.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 7a4ae9e..bd1f0cb 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1959,9 +1959,6 @@ static int rndis_scan(struct wiphy *wiphy,
 	 */
 	rndis_check_bssid_list(usbdev, NULL, NULL);
 
-	if (!request)
-		return -EINVAL;
-
 	if (priv->scan_request && priv->scan_request != request)
 		return -EBUSY;
 


