Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C7EC43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 17:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0E1F2070B
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 17:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbfAHRmc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 12:42:32 -0500
Received: from gateway21.websitewelcome.com ([192.185.45.38]:40167 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728256AbfAHRmb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 12:42:31 -0500
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id AC5FC400C774D
        for <linux-wireless@vger.kernel.org>; Tue,  8 Jan 2019 11:17:41 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id gv0XgEHT24FKpgv0Xgfnzo; Tue, 08 Jan 2019 11:17:41 -0600
X-Authority-Reason: nr=8
Received: from [189.250.130.205] (port=54128 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1ggv0W-002Jvo-Jm; Tue, 08 Jan 2019 11:17:41 -0600
Date:   Tue, 8 Jan 2019 11:17:38 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] iwlwifi: eeprom-parse: use struct_size() in kzalloc()
Message-ID: <20190108171738.GA32297@embeddedor>
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
X-Source-IP: 189.250.130.205
X-Source-L: No
X-Exim-ID: 1ggv0W-002Jvo-Jm
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.130.205]:54128
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 7
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

One of the more common cases of allocation size calculations is finding the
size of a structure that has a zero-sized array at the end, along with memory
for some number of elements for that array. For example:

struct foo {
    int stuff;
    void *entry[];
};

instance = kzalloc(sizeof(struct foo) + sizeof(void *) * count, GFP_KERNEL);

Instead of leaving these open-coded and prone to type mistakes, we can now
use the new struct_size() helper:

instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL);

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
index 75940ac406b9..04338c3a6205 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
@@ -850,8 +850,7 @@ iwl_parse_eeprom_data(struct device *dev, const struct iwl_cfg *cfg,
 	if (WARN_ON(!cfg || !cfg->eeprom_params))
 		return NULL;
 
-	data = kzalloc(sizeof(*data) +
-		       sizeof(struct ieee80211_channel) * IWL_NUM_CHANNELS,
+	data = kzalloc(struct_size(data, channels, IWL_NUM_CHANNELS),
 		       GFP_KERNEL);
 	if (!data)
 		return NULL;
-- 
2.20.1

