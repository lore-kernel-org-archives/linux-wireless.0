Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:64730 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754421AbcDKOxf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 10:53:35 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u3BEpSDZ016293
	for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2016 07:53:20 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0a-0016f401.pphosted.com with ESMTP id 226y3kdqvs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2016 07:53:20 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 4/5] mwifiex: do not wait on semaphore during card removal
Date: Mon, 11 Apr 2016 07:52:40 -0700
Message-ID: <1460386361-29918-4-git-send-email-akarwar@marvell.com> (sfid-20160411_165402_502886_CF1AD830)
In-Reply-To: <1460386361-29918-1-git-send-email-akarwar@marvell.com>
References: <1460386361-29918-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Host hang is observed if card is removed before firmware download
gets completed. In this case, firmware will be failed to download and
adapter structure gets freed.

In other thread, mwifiex_remove_card() waits on semaphore until the
firmware download fails. This wait is not necessary and may result in
invalid adapter access.

This patch uses down_trylock to return immediately so that hang issue
won't occur.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 04b975c..b459c70 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1434,7 +1434,7 @@ int mwifiex_remove_card(struct mwifiex_adapter *adapter, struct semaphore *sem)
 	struct mwifiex_private *priv = NULL;
 	int i;
 
-	if (down_interruptible(sem))
+	if (down_trylock(sem))
 		goto exit_sem_err;
 
 	if (!adapter)
-- 
1.8.1.4

