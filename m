Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6919 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752871AbbLNMR2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 07:17:28 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tBECGeuk027459
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:27 -0800
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0b-0016f401.pphosted.com with ESMTP id 1yswmng02c-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:17:27 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 12/14] mwifiex: update region_code_index array
Date: Mon, 14 Dec 2015 04:15:13 -0800
Message-ID: <1450095315-19927-13-git-send-email-akarwar@marvell.com> (sfid-20151214_131736_646445_91FC6CF3)
In-Reply-To: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
References: <1450095315-19927-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This array contains list of supported region codes.
It is changed to make it aligned with region code
to country mapping table in driver.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfp.c  | 2 +-
 drivers/net/wireless/marvell/mwifiex/main.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfp.c b/drivers/net/wireless/marvell/mwifiex/cfp.c
index beb564f..09fae27 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfp.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfp.c
@@ -67,7 +67,7 @@ static u8 supported_rates_bg[BG_SUPPORTED_RATES] = { 0x02, 0x04, 0x0b, 0x0c,
 					0x60, 0x6c, 0 };
 
 u16 region_code_index[MWIFIEX_MAX_REGION_CODE] = { 0x00, 0x10, 0x20, 0x30,
-						0x32, 0x40, 0x41, 0xff };
+						0x31, 0x32, 0x40, 0x41, 0x50 };
 
 static u8 supported_rates_n[N_SUPPORTED_RATES] = { 0x02, 0x04, 0 };
 
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 10e614e..0fa1d8e 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -84,7 +84,7 @@ enum {
 
 #define MWIFIEX_KEY_BUFFER_SIZE			16
 #define MWIFIEX_DEFAULT_LISTEN_INTERVAL 10
-#define MWIFIEX_MAX_REGION_CODE         8
+#define MWIFIEX_MAX_REGION_CODE         9
 
 #define DEFAULT_BCN_AVG_FACTOR          8
 #define DEFAULT_DATA_AVG_FACTOR         8
-- 
1.8.1.4

