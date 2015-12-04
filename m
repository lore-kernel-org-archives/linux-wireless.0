Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45601 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644AbbLDOOv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2015 09:14:51 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tB4E9PW2029045
	for <linux-wireless@vger.kernel.org>; Fri, 4 Dec 2015 06:14:50 -0800
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0a-0016f401.pphosted.com with ESMTP id 1yk5tpa13p-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 04 Dec 2015 06:14:50 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 6/6] mwifiex: correction in region code to country mapping
Date: Fri, 4 Dec 2015 06:13:07 -0800
Message-ID: <1449238387-27396-6-git-send-email-akarwar@marvell.com> (sfid-20151204_151455_004550_414E071E)
In-Reply-To: <1449238387-27396-1-git-send-email-akarwar@marvell.com>
References: <1449238387-27396-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

EU is not a valid country in db.txt file. Hence regulatory_hint
returns failure if EEPROM provides region code as 0x30. Let's
use FR for 0x30.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfp.c b/drivers/net/wireless/marvell/mwifiex/cfp.c
index dd3adc5..beb564f 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfp.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfp.c
@@ -168,7 +168,7 @@ struct region_code_mapping {
 static struct region_code_mapping region_code_mapping_t[] = {
 	{ 0x10, "US " }, /* US FCC */
 	{ 0x20, "CA " }, /* IC Canada */
-	{ 0x30, "EU " }, /* ETSI */
+	{ 0x30, "FR " }, /* France */
 	{ 0x31, "ES " }, /* Spain */
 	{ 0x32, "FR " }, /* France */
 	{ 0x40, "JP " }, /* Japan */
-- 
1.8.1.4

