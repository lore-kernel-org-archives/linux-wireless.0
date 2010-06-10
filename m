Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758838Ab0FJMIq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 08:08:46 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o5AC8jjp006956
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Thu, 10 Jun 2010 08:08:45 -0400
Date: Thu, 10 Jun 2010 08:08:42 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20100610120209.27952.91383.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH]: libertas_tf: Fix warning in lbtf_rx for stats struct
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes linux-2.6 warning:

drivers/net/wireless/libertas_tf/main.c: In function ‘lbtf_rx’:
drivers/net/wireless/libertas_tf/main.c:578: warning: ‘stats.antenna’ is used uninitialized in this function
drivers/net/wireless/libertas_tf/main.c:578: warning: ‘stats.mactime’ is used uninitialized in this function

stats struct needs to be set to 0 before use.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index 019431d..52d7c5c 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -488,7 +488,7 @@ int lbtf_rx(struct lbtf_private *priv, struct sk_buff *skb)
 
 	prxpd = (struct rxpd *) skb->data;
 
-	stats.flag = 0;
+	memset(&stats, 0, sizeof(stats));
 	if (!(prxpd->status & cpu_to_le16(MRVDRV_RXPD_STATUS_OK)))
 		stats.flag |= RX_FLAG_FAILED_FCS_CRC;
 	stats.freq = priv->cur_freq;


