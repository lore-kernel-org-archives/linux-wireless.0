Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:13454 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753002AbbFDOCf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2015 10:02:35 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t54DxwNM016871
	for <linux-wireless@vger.kernel.org>; Thu, 4 Jun 2015 07:02:34 -0700
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0b-0016f401.pphosted.com with ESMTP id 1usqkvmuh4-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 04 Jun 2015 07:02:34 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	<liuzy@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 2/2] mwifiex: update current config_band info in start_ap
Date: Fri, 5 Jun 2015 01:01:54 +0530
Message-ID: <1433446314-13098-2-git-send-email-patila@marvell.com> (sfid-20150604_160237_973733_68EAFCD7)
In-Reply-To: <1433446314-13098-1-git-send-email-patila@marvell.com>
References: <1433446314-13098-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was observed that AP beacons would not reflect correct regulatory
information upon starting AP in A band. This was because of missing
AP config band update in set_channel of start_ap.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/uap_cmd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index a62b43e..b749300 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -832,6 +832,8 @@ void mwifiex_uap_set_channel(struct mwifiex_private *priv,
 		if (chandef.width > NL80211_CHAN_WIDTH_40)
 			config_bands |= BAND_AAC;
 	}
+
+	priv->adapter->config_bands = config_bands;
 }
 
 int mwifiex_config_start_uap(struct mwifiex_private *priv,
-- 
1.8.1.4

