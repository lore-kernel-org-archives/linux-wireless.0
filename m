Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway36.websitewelcome.com ([192.185.200.11]:18661 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751707AbeFANq3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Jun 2018 09:46:29 -0400
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id 88162405001B8
        for <linux-wireless@vger.kernel.org>; Fri,  1 Jun 2018 08:24:09 -0500 (CDT)
Date: Fri, 1 Jun 2018 08:24:08 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] qtnfmac: fix NULL pointer dereference
Message-ID: <20180601132408.GA2572@embeddedor.com> (sfid-20180601_154635_287812_732819FE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case *vif* is NULL at 655: if (!vif), the execution path jumps to
label out, where *vif* is dereferenced at 679:

if (vif->sta_state == QTNF_STA_CONNECTING)

Fix this by immediately returning when *vif* is NULL instead of
jumping to label out.

Addresses-Coverity-ID: 1469567 ("Dereference after null check")
Fixes: 480daa9cb62c ("qtnfmac: fix invalid STA state on EAPOL failure")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 220e2b7..ae0ca80 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -654,8 +654,7 @@ qtnf_disconnect(struct wiphy *wiphy, struct net_device *dev,
 	vif = qtnf_mac_get_base_vif(mac);
 	if (!vif) {
 		pr_err("MAC%u: primary VIF is not configured\n", mac->macid);
-		ret = -EFAULT;
-		goto out;
+		return -EFAULT;
 	}
 
 	if (vif->wdev.iftype != NL80211_IFTYPE_STATION) {
-- 
2.7.4
