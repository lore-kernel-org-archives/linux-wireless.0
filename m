Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53629 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935060Ab3FSVH0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 17:07:26 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH-WN 2/3] wireless: Check for dangling wdev->current_bss pointer.
Date: Wed, 19 Jun 2013 14:06:26 -0700
Message-Id: <1371675987-28732-2-git-send-email-greearb@candelatech.com> (sfid-20130619_230733_100493_E0020B12)
In-Reply-To: <1371675987-28732-1-git-send-email-greearb@candelatech.com>
References: <1371675987-28732-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

If it *is* still set when the netdev is being deleted,
then we are about to leak a pointer.  Warn and clean up
in that case.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

This is against wireless-next.  I've never seen this hit,
though possibly it would catch some future bugs.  If you
think it's not useful, I won't argue :)

 net/wireless/core.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 9143288..042d6a3 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -934,6 +934,12 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		 * freed.
 		 */
 		cfg80211_process_wdev_events(wdev);
+
+		if (WARN_ON(wdev->current_bss)) {
+			cfg80211_unhold_bss(wdev->current_bss);
+			cfg80211_put_bss(wdev->wiphy, &wdev->current_bss->pub);
+			wdev->current_bss = NULL;
+		}
 		break;
 	case NETDEV_PRE_UP:
 		if (!(wdev->wiphy->interface_modes & BIT(wdev->iftype)))
-- 
1.7.3.4

