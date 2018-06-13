Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57268 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934508AbeFMNnF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 09:43:05 -0400
Received: from DLANSKY (unknown [185.23.60.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: dlansky@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 826BE602FC
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2018 13:43:04 +0000 (UTC)
From: "Dedy Lansky" <dlansky@codeaurora.org>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: fix rcu in cfg80211_unregister_wdev
Date: Wed, 13 Jun 2018 16:43:01 +0300
Message-ID: <001501d4031c$74710ac0$5d532040$@codeaurora.org> (sfid-20180613_154309_869062_57D69970)
MIME-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

We are seeing intermittent crashes when calling cfg80211_unregister_wdev()
and then immediately free'ing the wdev object, like is done in wil6210 (see
[1]).
We believe this is due to cfg80211_unregister_wdev doing list_del_rcu()
without synchronize_cpu() afterwards.

====================================

From: Dedy Lansky <dlansky@codeaurora.org>
Subject: [PATCH] cfg80211: fix rcu in cfg80211_unregister_wdev

Callers of cfg80211_unregister_wdev can free the wdev object
immediately after this function returns. This may crash the kernel
because this wdev object is still in use by other threads.
Add synchronize_rcu() after list_del_rcu to make sure wdev object can
be safely freed.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
---
 net/wireless/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 5fe35aa..48e80973 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1012,6 +1012,7 @@ void cfg80211_unregister_wdev(struct wireless_dev
*wdev)
        nl80211_notify_iface(rdev, wdev, NL80211_CMD_DEL_INTERFACE);

        list_del_rcu(&wdev->list);
+       synchronize_rcu();
        rdev->devlist_generation++;

        switch (wdev->iftype) {
--
1.9.1

[1]
https://elixir.bootlin.com/linux/latest/source/drivers/net/wireless/ath/wil6
210/cfg80211.c#L2234
