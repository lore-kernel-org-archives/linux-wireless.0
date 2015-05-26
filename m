Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62789 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754912AbbEZNf1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 09:35:27 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t4QDYpH7003451
	for <linux-wireless@vger.kernel.org>; Tue, 26 May 2015 06:35:23 -0700
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0b-0016f401.pphosted.com with ESMTP id 1umqg00bpw-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 26 May 2015 06:35:23 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/6] mwifiex: fix a possible double free issue
Date: Tue, 26 May 2015 06:34:28 -0700
Message-ID: <1432647272-5734-3-git-send-email-akarwar@marvell.com> (sfid-20150526_153540_749116_6E347080)
In-Reply-To: <1432647272-5734-1-git-send-email-akarwar@marvell.com>
References: <1432647272-5734-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As drv_info_dump pointer doesn't get reset, we may end up
freeing the allocated memory twice.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c | 1 +
 drivers/net/wireless/mwifiex/main.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index fdf38d0..df7fdc0 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -435,6 +435,7 @@ mwifiex_adapter_cleanup(struct mwifiex_adapter *adapter)
 
 	if (adapter->drv_info_dump) {
 		vfree(adapter->drv_info_dump);
+		adapter->drv_info_dump = NULL;
 		adapter->drv_info_size = 0;
 	}
 
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 138c1cc..cb009789 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -886,6 +886,7 @@ void mwifiex_dump_drv_info(struct mwifiex_adapter *adapter)
 
 	if (adapter->drv_info_dump) {
 		vfree(adapter->drv_info_dump);
+		adapter->drv_info_dump = NULL;
 		adapter->drv_info_size = 0;
 	}
 
-- 
1.8.1.4

