Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA915C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 18:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A4CA20700
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 18:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfDCSXh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 14:23:37 -0400
Received: from gateway33.websitewelcome.com ([192.185.146.97]:32635 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726709AbfDCSXh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 14:23:37 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id CF91673D8C
        for <linux-wireless@vger.kernel.org>; Wed,  3 Apr 2019 13:23:36 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id BkXwhOs9idnCeBkXwhEFTs; Wed, 03 Apr 2019 13:23:36 -0500
X-Authority-Reason: nr=8
Received: from [189.250.114.183] (port=45402 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hBkXv-002dnW-HT; Wed, 03 Apr 2019 13:23:36 -0500
Date:   Wed, 3 Apr 2019 13:23:34 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] cfg80211: use struct_size() helper
Message-ID: <20190403182334.GA3986@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.250.114.183
X-Source-L: No
X-Exim-ID: 1hBkXv-002dnW-HT
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.114.183]:45402
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes, in particular in the
context in which this code is being used.

So, replace code of the following form:

sizeof(*pmkids) + max_pmkids * sizeof(pmkids->bssid_info[0])

with:

struct_size(pmkids, bssid_info, num_pmkids)

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/rndis_wlan.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 51e4e92d95a0..e07a1152cec1 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1707,7 +1707,7 @@ static struct ndis_80211_pmkid *get_device_pmkids(struct usbnet *usbdev)
 	int len, ret, max_pmkids;
 
 	max_pmkids = priv->wdev.wiphy->max_num_pmkids;
-	len = sizeof(*pmkids) + max_pmkids * sizeof(pmkids->bssid_info[0]);
+	len = struct_size(pmkids, bssid_info, max_pmkids);
 
 	pmkids = kzalloc(len, GFP_KERNEL);
 	if (!pmkids)
@@ -1740,7 +1740,7 @@ static int set_device_pmkids(struct usbnet *usbdev,
 	int ret, len, num_pmkids;
 
 	num_pmkids = le32_to_cpu(pmkids->bssid_info_count);
-	len = sizeof(*pmkids) + num_pmkids * sizeof(pmkids->bssid_info[0]);
+	len = struct_size(pmkids, bssid_info, num_pmkids);
 	pmkids->length = cpu_to_le32(len);
 
 	debug_print_pmkids(usbdev, pmkids, __func__);
@@ -1761,7 +1761,7 @@ static struct ndis_80211_pmkid *remove_pmkid(struct usbnet *usbdev,
 						struct cfg80211_pmksa *pmksa,
 						int max_pmkids)
 {
-	int i, newlen, err;
+	int i, err;
 	unsigned int count;
 
 	count = le32_to_cpu(pmkids->bssid_info_count);
@@ -1786,9 +1786,7 @@ static struct ndis_80211_pmkid *remove_pmkid(struct usbnet *usbdev,
 		pmkids->bssid_info[i] = pmkids->bssid_info[i + 1];
 
 	count--;
-	newlen = sizeof(*pmkids) + count * sizeof(pmkids->bssid_info[0]);
-
-	pmkids->length = cpu_to_le32(newlen);
+	pmkids->length = cpu_to_le32(struct_size(pmkids, bssid_info, count));
 	pmkids->bssid_info_count = cpu_to_le32(count);
 
 	return pmkids;
@@ -1831,7 +1829,7 @@ static struct ndis_80211_pmkid *update_pmkid(struct usbnet *usbdev,
 	}
 
 	/* add new pmkid */
-	newlen = sizeof(*pmkids) + (count + 1) * sizeof(pmkids->bssid_info[0]);
+	newlen = struct_size(pmkids, bssid_info, count + 1);
 
 	new_pmkids = krealloc(pmkids, newlen, GFP_KERNEL);
 	if (!new_pmkids) {
-- 
2.21.0

