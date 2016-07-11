Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56350 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933665AbcGKO5k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 10:57:40 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u6BEpUlC032456
	for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2016 07:57:40 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0b-0016f401.pphosted.com with ESMTP id 2430sge4y2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2016 07:57:39 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Karthik D A <karthida@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/9] mwifiex: add region code information in debugfs
Date: Mon, 11 Jul 2016 20:23:45 +0530
Message-ID: <1468248832-21969-3-git-send-email-akarwar@marvell.com> (sfid-20160711_165743_674866_FE8103C7)
In-Reply-To: <1468248832-21969-1-git-send-email-akarwar@marvell.com>
References: <1468248832-21969-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karthik D A <karthida@marvell.com>

region code is an EEPROM setting received from firmware. Let's display
this in debugfs along with other information.

Signed-off-by: Karthik D A <karthida@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/debugfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/debugfs.c b/drivers/net/wireless/marvell/mwifiex/debugfs.c
index bccf17a..b9284b5 100644
--- a/drivers/net/wireless/marvell/mwifiex/debugfs.c
+++ b/drivers/net/wireless/marvell/mwifiex/debugfs.c
@@ -118,6 +118,8 @@ mwifiex_info_read(struct file *file, char __user *ubuf,
 		p += sprintf(p, "bssid=\"%pM\"\n", info.bssid);
 		p += sprintf(p, "channel=\"%d\"\n", (int) info.bss_chan);
 		p += sprintf(p, "country_code = \"%s\"\n", info.country_code);
+		p += sprintf(p, "region_code=\"0x%x\"\n",
+			     priv->adapter->region_code);
 
 		netdev_for_each_mc_addr(ha, netdev)
 			p += sprintf(p, "multicast_address[%d]=\"%pM\"\n",
-- 
1.9.1

