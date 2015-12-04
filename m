Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18072 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856AbbLDOOl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2015 09:14:41 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tB4E9UL2029053
	for <linux-wireless@vger.kernel.org>; Fri, 4 Dec 2015 06:14:41 -0800
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0a-0016f401.pphosted.com with ESMTP id 1yk5tpa135-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 04 Dec 2015 06:14:41 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/6] mwifiex: set regulatory info from EEPROM
Date: Fri, 4 Dec 2015 06:13:04 -0800
Message-ID: <1449238387-27396-3-git-send-email-akarwar@marvell.com> (sfid-20151204_151449_702583_6112EDE4)
In-Reply-To: <1449238387-27396-1-git-send-email-akarwar@marvell.com>
References: <1449238387-27396-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver gets country information from EEPROM during
initialization. We will call regulatory_hint to update
current regulatory domain.
As by default world regulatory domain is selected by
cfg80211, country '00' from EEPROM is ignored.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 14 +++++++++-----
 drivers/net/wireless/marvell/mwifiex/cfp.c      |  2 +-
 drivers/net/wireless/marvell/mwifiex/main.h     |  2 +-
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 4073116..9b570e1 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3862,11 +3862,15 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 			    "driver hint alpha2: %2.2s\n", reg_alpha2);
 		regulatory_hint(wiphy, reg_alpha2);
 	} else {
-		country_code = mwifiex_11d_code_2_region(adapter->region_code);
-		if (country_code)
-			mwifiex_dbg(adapter, WARN,
-				    "ignoring F/W country code %2.2s\n",
-				    country_code);
+		if (adapter->region_code == 0x00) {
+			mwifiex_dbg(adapter, WARN, "Ignore world regulatory domain\n");
+		} else {
+			country_code =
+				mwifiex_11d_code_2_region(adapter->region_code);
+			if (country_code &&
+			    regulatory_hint(wiphy, country_code))
+				mwifiex_dbg(priv->adapter, ERROR, "regulatory_hint() failed\n");
+		}
 	}
 
 	mwifiex_send_cmd(priv, HostCmd_CMD_802_11_SNMP_MIB,
diff --git a/drivers/net/wireless/marvell/mwifiex/cfp.c b/drivers/net/wireless/marvell/mwifiex/cfp.c
index 3ddb8ec..dd3adc5 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfp.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfp.c
@@ -66,7 +66,7 @@ static u8 supported_rates_bg[BG_SUPPORTED_RATES] = { 0x02, 0x04, 0x0b, 0x0c,
 					0x12, 0x16, 0x18, 0x24, 0x30, 0x48,
 					0x60, 0x6c, 0 };
 
-u16 region_code_index[MWIFIEX_MAX_REGION_CODE] = { 0x10, 0x20, 0x30,
+u16 region_code_index[MWIFIEX_MAX_REGION_CODE] = { 0x00, 0x10, 0x20, 0x30,
 						0x32, 0x40, 0x41, 0xff };
 
 static u8 supported_rates_n[N_SUPPORTED_RATES] = { 0x02, 0x04, 0 };
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 3959f1c..a86e2ae 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -84,7 +84,7 @@ enum {
 
 #define MWIFIEX_KEY_BUFFER_SIZE			16
 #define MWIFIEX_DEFAULT_LISTEN_INTERVAL 10
-#define MWIFIEX_MAX_REGION_CODE         7
+#define MWIFIEX_MAX_REGION_CODE         8
 
 #define DEFAULT_BCN_AVG_FACTOR          8
 #define DEFAULT_DATA_AVG_FACTOR         8
-- 
1.8.1.4

