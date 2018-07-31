Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46557 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731639AbeGaNHt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 09:07:49 -0400
To: Haim Dreyfuss <haim.dreyfuss@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: Colin Ian King <colin.king@canonical.com>
Subject: re: [PATCH] cfg80211: read wmm rules from regulatory database
Message-ID: <9ff30f03-07f1-0abd-8c57-2601af546de0@canonical.com> (sfid-20180731_132912_355730_F6DCFA22)
Date: Tue, 31 Jul 2018 12:27:54 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Haim,

I think there may be an issue with the commit:

>From 230ebaa189af44d50dccb4a1846e39ca594e347b Mon Sep 17 00:00:00 2001
From: Haim Dreyfuss <haim.dreyfuss@intel.com>
Date: Wed, 28 Mar 2018 13:24:09 +0300
Subject: [PATCH] cfg80211: read wmm rules from regulatory database

specifically in function: reg_copy_regd()

+       for (i = 0; i < src_regd->n_reg_rules; i++) {
                memcpy(&regd->reg_rules[i], &src_regd->reg_rules[i],
                       sizeof(struct ieee80211_reg_rule));
+               if (!src_regd->reg_rules[i].wmm_rule)
+                       continue;

+               regd->reg_rules[i].wmm_rule = d_wmm +
+                       (src_regd->reg_rules[i].wmm_rule - s_wmm) /
+                       sizeof(struct ieee80211_wmm_rule);
+       }

The pointer arithmetic (src_regd->reg_rules[i].wmm_rule - s_wmm) is
performed in terms of the size of struct ieee80211_wmm_rule and not in
bytes and I believe that the division by sizeof(struct
ieee80211_wmm_rule) is not required.

This issue was detected by static analysis with Coverity Scan,
CID#1467451 ("Extra sizeof expression"), 'suspicious_division'

I'm not 100% sure that is this a false positive or not, but I think it
looks incorrect to me.

Colin
