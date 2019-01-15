Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43620C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 22:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 193F720883
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 22:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387794AbfAOWu0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 17:50:26 -0500
Received: from gateway20.websitewelcome.com ([192.185.53.25]:29544 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387714AbfAOWuZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 17:50:25 -0500
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2019 17:50:25 EST
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 2FDE1400C4EE6
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2019 16:02:53 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id jWnNglFea2qH7jWnNgOomo; Tue, 15 Jan 2019 16:02:53 -0600
X-Authority-Reason: nr=8
Received: from [189.250.130.205] (port=53938 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1gjWnK-002507-VI; Tue, 15 Jan 2019 16:02:52 -0600
Date:   Tue, 15 Jan 2019 16:02:46 -0600
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
Subject: [PATCH][next] iwlwifi: mvm: use struct_size() in kzalloc()
Message-ID: <20190115220246.GA23339@embeddedor>
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
X-Exim-ID: 1gjWnK-002507-VI
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.130.205]:53938
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
    struct boo entry[];
};

instance = kzalloc(sizeof(struct foo) + count * sizeof(struct boo), GFP_KERNEL);

Instead of leaving these open-coded and prone to type mistakes, we can now
use the new struct_size() helper:

instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL);

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index d9afedc3d1d9..a2b2bdc5cd09 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -947,14 +947,12 @@ iwl_parse_nvm_data(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	const __le16 *ch_section;
 
 	if (cfg->nvm_type != IWL_NVM_EXT)
-		data = kzalloc(sizeof(*data) +
-			       sizeof(struct ieee80211_channel) *
-			       IWL_NVM_NUM_CHANNELS,
+		data = kzalloc(struct_size(data, channels,
+			       IWL_NVM_NUM_CHANNELS),
 			       GFP_KERNEL);
 	else
-		data = kzalloc(sizeof(*data) +
-			       sizeof(struct ieee80211_channel) *
-			       IWL_NVM_NUM_CHANNELS_EXT,
+		data = kzalloc(struct_size(data, channels,
+			       IWL_NVM_NUM_CHANNELS_EXT),
 			       GFP_KERNEL);
 	if (!data)
 		return NULL;
@@ -1444,9 +1442,7 @@ struct iwl_nvm_data *iwl_get_nvm(struct iwl_trans *trans,
 	if (empty_otp)
 		IWL_INFO(trans, "OTP is empty\n");
 
-	nvm = kzalloc(sizeof(*nvm) +
-		      sizeof(struct ieee80211_channel) * IWL_NUM_CHANNELS,
-		      GFP_KERNEL);
+	nvm = kzalloc(struct_size(nvm, channels, IWL_NUM_CHANNELS), GFP_KERNEL);
 	if (!nvm) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.20.1

