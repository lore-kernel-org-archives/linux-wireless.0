Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38275 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933015AbbENI5x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2015 04:57:53 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t4E8nhG2032214
	for <linux-wireless@vger.kernel.org>; Thu, 14 May 2015 01:57:52 -0700
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0b-0016f401.pphosted.com with ESMTP id 1ucq1br9uj-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 14 May 2015 01:57:51 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <liuzy@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH] mwifiex: reduce severity of debug messages for mgmt rx
Date: Thu, 14 May 2015 19:57:31 +0530
Message-ID: <1431613651-9049-1-git-send-email-patila@marvell.com> (sfid-20150514_105800_297676_AE9A94F3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This would ensure dmesg logs are not spammed with "unknown mgmt frame
subtype" messages.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 3c0b3c1..fd8ef3c 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -350,7 +350,7 @@ mwifiex_parse_mgmt_packet(struct mwifiex_private *priv, u8 *payload, u16 len,
 		}
 		break;
 	default:
-		mwifiex_dbg(priv->adapter, ERROR,
+		mwifiex_dbg(priv->adapter, INFO,
 			    "unknown mgmt frame subytpe %#x\n", stype);
 	}
 
-- 
1.8.1.4

