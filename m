Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31919 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753399AbbGPNa1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2015 09:30:27 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t6GDTSiF000974
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2015 06:30:26 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0a-0016f401.pphosted.com with ESMTP id 1vnb4adar6-3
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2015 06:30:26 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Aniket Nagarnaik <aniketn@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/3] UPSTREAM: mwifiex: use maximum ssid length as 0xfe for p2p
Date: Thu, 16 Jul 2015 06:27:28 -0700
Message-ID: <1437053249-18440-3-git-send-email-akarwar@marvell.com> (sfid-20150716_153030_249345_10B46635)
In-Reply-To: <1437053249-18440-1-git-send-email-akarwar@marvell.com>
References: <1437053249-18440-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aniket Nagarnaik <aniketn@marvell.com>

0xfe is basically a magic number used to ask firmware match
provided string in a SSID. In this case, firmware will
return scan results containing"DIRECT-" string.

Signed-off-by: Aniket Nagarnaik <aniketn@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index ef2bef8..ef8da8e 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -909,6 +909,10 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 				wildcard_ssid_tlv->max_ssid_length =
 							IEEE80211_MAX_SSID_LEN;
 
+			if (!memcmp(user_scan_in->ssid_list[i].ssid,
+				    "DIRECT-", 7))
+				wildcard_ssid_tlv->max_ssid_length = 0xfe;
+
 			memcpy(wildcard_ssid_tlv->ssid,
 			       user_scan_in->ssid_list[i].ssid, ssid_len);
 
-- 
1.8.1.4

