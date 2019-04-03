Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C6C2C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 17:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E149B205C9
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 17:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfDCRB6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 13:01:58 -0400
Received: from gateway31.websitewelcome.com ([192.185.143.234]:49155 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726084AbfDCRB6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 13:01:58 -0400
X-Greylist: delayed 1263 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Apr 2019 13:01:58 EDT
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id AA3A1D53F5
        for <linux-wireless@vger.kernel.org>; Wed,  3 Apr 2019 11:40:54 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id BiwYhlwnJ4FKpBiwYhHjyt; Wed, 03 Apr 2019 11:40:54 -0500
X-Authority-Reason: nr=8
Received: from [189.250.114.183] (port=42224 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hBiwX-001ZIn-Lm; Wed, 03 Apr 2019 11:40:53 -0500
Date:   Wed, 3 Apr 2019 11:40:52 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] mwifiex: use struct_size() in kzalloc()
Message-ID: <20190403164052.GA26381@embeddedor>
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
X-Exim-ID: 1hBiwX-001ZIn-Lm
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.114.183]:42224
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 16
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct foo {
    int stuff;
    struct boo entry[];
};

size = sizeof(struct foo) + count * sizeof(struct boo);
instance = kzalloc(size, GFP_KERNEL)

Instead of leaving these open-coded and prone to type mistakes, we can
now use the new struct_size() helper:

instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL)

Notice that, in this case, variable regd_size is not necessary,
hence it is removed.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
index 69e3b624adbb..24b33e20e7a9 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
@@ -1025,17 +1025,14 @@ mwifiex_create_custom_regdomain(struct mwifiex_private *priv,
 	struct ieee80211_regdomain *regd;
 	struct ieee80211_reg_rule *rule;
 	bool new_rule;
-	int regd_size, idx, freq, prev_freq = 0;
+	int idx, freq, prev_freq = 0;
 	u32 bw, prev_bw = 0;
 	u8 chflags, prev_chflags = 0, valid_rules = 0;
 
 	if (WARN_ON_ONCE(num_chan > NL80211_MAX_SUPP_REG_RULES))
 		return ERR_PTR(-EINVAL);
 
-	regd_size = sizeof(struct ieee80211_regdomain) +
-		    num_chan * sizeof(struct ieee80211_reg_rule);
-
-	regd = kzalloc(regd_size, GFP_KERNEL);
+	regd = kzalloc(struct_size(regd, reg_rules, num_chan), GFP_KERNEL);
 	if (!regd)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.21.0

