Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10959 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781AbcBWNU1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 08:20:27 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u1NDKGDx030316
	for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2016 05:20:27 -0800
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0a-0016f401.pphosted.com with ESMTP id 218m5mgrtd-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2016 05:20:27 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/4] mwifiex: fix corner case association failure
Date: Tue, 23 Feb 2016 05:16:17 -0800
Message-ID: <1456233379-12099-2-git-send-email-akarwar@marvell.com> (sfid-20160223_142031_349723_E4AD7A47)
In-Reply-To: <1456233379-12099-1-git-send-email-akarwar@marvell.com>
References: <1456233379-12099-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch corrects the error case in association path by returning
-1. Earlier "media_connected" used to remain on in this error case
causing failure for further association attempts.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Fixes: b887664d882ee4 ('mwifiex: channel switch handling for station')
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index 5cbee58..d5c56eb 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -314,6 +314,7 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 			mwifiex_dbg(adapter, ERROR,
 				    "Attempt to reconnect on csa closed chan(%d)\n",
 				    bss_desc->channel);
+			ret = -1;
 			goto done;
 		}
 
-- 
1.8.1.4

