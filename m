Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37422 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751640AbbLaO0m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Dec 2015 09:26:42 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tBVEOxKk012993
	for <linux-wireless@vger.kernel.org>; Thu, 31 Dec 2015 06:26:41 -0800
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0b-0016f401.pphosted.com with ESMTP id 20327phmmb-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 31 Dec 2015 06:26:41 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 4/4] mwifiex: reduce cloned skb queue size
Date: Thu, 31 Dec 2015 06:24:15 -0800
Message-ID: <1451571855-29449-4-git-send-email-akarwar@marvell.com> (sfid-20151231_152712_236086_836AA3D7)
In-Reply-To: <1451571855-29449-1-git-send-email-akarwar@marvell.com>
References: <1451571855-29449-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver supports Tx status ack feature. When hostapd/
wpa_supplicant asks for ack status of an EAPOL/ACTION
frame, driver maintains a cloned skb for the packet
until TX_STATUS event is received from firmware.

Cloned skb queue gets flushed when connection is terminated
or driver is unloaded.

Let's reduce the queue size to avoid unnecessarily
keeping memory allocated when environment is busy.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 969ca1e..79c16de 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -763,7 +763,7 @@ mwifiex_clone_skb_for_tx_status(struct mwifiex_private *priv,
 
 		spin_lock_irqsave(&priv->ack_status_lock, flags);
 		id = idr_alloc(&priv->ack_status_frames, orig_skb,
-			       1, 0xff, GFP_ATOMIC);
+			       1, 0x10, GFP_ATOMIC);
 		spin_unlock_irqrestore(&priv->ack_status_lock, flags);
 
 		if (id >= 0) {
-- 
1.8.1.4

