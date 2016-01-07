Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35978 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751545AbcAGJee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 04:34:34 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u079YYmD018916
	for <linux-wireless@vger.kernel.org>; Thu, 7 Jan 2016 01:34:34 -0800
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0b-0016f401.pphosted.com with ESMTP id 208ynrkk5v-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2016 01:34:34 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 6/6] mwifiex: use SYNC flag for canceling host sleep
Date: Thu, 7 Jan 2016 01:31:31 -0800
Message-ID: <1452159091-30997-7-git-send-email-akarwar@marvell.com> (sfid-20160107_103445_495568_423D9CD2)
In-Reply-To: <1452159091-30997-1-git-send-email-akarwar@marvell.com>
References: <1452159091-30997-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Host sleep is cancelled in sdio resume() handler.
Cfg80211's resume handler is immediately called after
this. SYNC flag here ensures that host sleep handshake
gets completed and we have valid "adapter->nd_config"
before we report host wakeup reason in cfg80211's
resume handler.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index ec1e8c3..031c599 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -181,7 +181,7 @@ static int mwifiex_sdio_resume(struct device *dev)
 
 	/* Disable Host Sleep */
 	mwifiex_cancel_hs(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA),
-			  MWIFIEX_ASYNC_CMD);
+			  MWIFIEX_SYNC_CMD);
 
 	return 0;
 }
-- 
1.8.1.4

