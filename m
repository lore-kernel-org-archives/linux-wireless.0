Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43618 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331Ab3FRWEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 18:04:49 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 4/6] wireless:  Check for dangling wdev->current_bss pointer.
Date: Tue, 18 Jun 2013 15:03:35 -0700
Message-Id: <1371593017-10985-4-git-send-email-greearb@candelatech.com> (sfid-20130619_000452_119639_C1105703)
In-Reply-To: <1371593017-10985-1-git-send-email-greearb@candelatech.com>
References: <1371593017-10985-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

If it *is* still set when the netdev is being deleted,
then we are about to leak a pointer.  Warn and clean up
in that case.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/wireless/core.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index eb3e1de..9e05da9 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1063,6 +1063,12 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		 * freed.
 		 */
 		cfg80211_process_wdev_events(wdev);
+
+		if (WARN_ON(wdev->current_bss)) {
+			cfg80211_unhold_bss(wdev->current_bss);
+			cfg80211_put_bss(wdev->wiphy, &wdev->current_bss->pub);
+			SET_BSS(wdev, NULL);
+		}
 		break;
 	case NETDEV_PRE_UP:
 		if (!(wdev->wiphy->interface_modes & BIT(wdev->iftype)))
-- 
1.7.3.4

