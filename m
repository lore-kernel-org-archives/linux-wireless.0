Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49546 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030656AbcGKO7X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 10:59:23 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u6BEpXml032464
	for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2016 07:59:17 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0b-0016f401.pphosted.com with ESMTP id 2430sge52d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2016 07:59:17 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/9] mwifiex: fix failed to reconnect after interface disabled/enabled
Date: Mon, 11 Jul 2016 20:23:46 +0530
Message-ID: <1468248832-21969-4-git-send-email-akarwar@marvell.com> (sfid-20160711_165927_400405_614087FA)
In-Reply-To: <1468248832-21969-1-git-send-email-akarwar@marvell.com>
References: <1468248832-21969-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent patch "mwifiex: fix NULL pointer" skips extended scan event
handling when suspend is in progress. It created a problem for scan
after interface disabled/enabled case.

This patch solves the problem by checking netif_running() status.

Fixes:16d25da94f3d654 ("mwifiex: fix NULL pointer dereference during suspend")
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_event.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index a422f33..7e394d4 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -708,7 +708,11 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 	case EVENT_EXT_SCAN_REPORT:
 		mwifiex_dbg(adapter, EVENT, "event: EXT_SCAN Report\n");
-		if (adapter->ext_scan && !priv->scan_aborting)
+		/* We intend to skip this event during suspend, but handle
+		 * it in interface disabled case
+		 */
+		if (adapter->ext_scan && (!priv->scan_aborting ||
+					  !netif_running(priv->netdev)))
 			ret = mwifiex_handle_event_ext_scan_report(priv,
 						adapter->event_skb->data);
 
-- 
1.9.1

