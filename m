Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:63173 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751866AbbLDOOo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2015 09:14:44 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tB4E9PW0029045
	for <linux-wireless@vger.kernel.org>; Fri, 4 Dec 2015 06:14:44 -0800
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0a-0016f401.pphosted.com with ESMTP id 1yk5tpa137-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 04 Dec 2015 06:14:43 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 4/6] mwifiex: don't follow AP if country code received from EEPROM
Date: Fri, 4 Dec 2015 06:13:05 -0800
Message-ID: <1449238387-27396-4-git-send-email-akarwar@marvell.com> (sfid-20151204_151451_925281_0BA1D5DB)
In-Reply-To: <1449238387-27396-1-git-send-email-akarwar@marvell.com>
References: <1449238387-27396-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If device has already received country information from
EEPROM, we won't parse AP's country IE and download it to
firmware. We will also set regulatory flags to disable beacon
hints and ignore country IE.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c  | 4 ++++
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 9b570e1..65dd85d 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3802,6 +3802,10 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	wiphy->cipher_suites = mwifiex_cipher_suites;
 	wiphy->n_cipher_suites = ARRAY_SIZE(mwifiex_cipher_suites);
 
+	if (adapter->region_code)
+		wiphy->regulatory_flags |= REGULATORY_DISABLE_BEACON_HINTS |
+					   REGULATORY_COUNTRY_IE_IGNORE;
+
 	ether_addr_copy(wiphy->perm_addr, adapter->perm_addr);
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 	wiphy->flags |= WIPHY_FLAG_HAVE_AP_SME |
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index a6c8a4f..78cb1d7 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -272,7 +272,8 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 	priv->scan_block = false;
 
 	if (bss) {
-		mwifiex_process_country_ie(priv, bss);
+		if (adapter->region_code == 0x00)
+			mwifiex_process_country_ie(priv, bss);
 
 		/* Allocate and fill new bss descriptor */
 		bss_desc = kzalloc(sizeof(struct mwifiex_bssdescriptor),
-- 
1.8.1.4

