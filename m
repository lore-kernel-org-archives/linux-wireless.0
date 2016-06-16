Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51579 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752339AbcFPN1V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 09:27:21 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u5GDRKjl022497
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2016 06:27:20 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0b-0016f401.pphosted.com with ESMTP id 23gj5fs098-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2016 06:27:19 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Cathy Luo <cluo@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 4/6] mwifiex: fix system hang problem after resume
Date: Thu, 16 Jun 2016 18:52:24 +0530
Message-ID: <1466083346-18607-4-git-send-email-akarwar@marvell.com> (sfid-20160616_152724_220273_25B77F98)
In-Reply-To: <1466083346-18607-1-git-send-email-akarwar@marvell.com>
References: <1466083346-18607-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On some platforms, driver is unable to wakeup firmware after system resume
due to a problem at MMC subsystem. Triggering card reset in this case has
a race with card removal from MMC which causes system hang. This patch
resolves the problem by not triggering card reset.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index fbaf490..d39f72a3 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -60,7 +60,7 @@ static void wakeup_timer_fn(unsigned long data)
 	adapter->hw_status = MWIFIEX_HW_STATUS_RESET;
 	mwifiex_cancel_all_pending_cmd(adapter);
 
-	if (adapter->if_ops.card_reset)
+	if (adapter->if_ops.card_reset && !adapter->hs_activated)
 		adapter->if_ops.card_reset(adapter);
 }
 
-- 
1.9.1

