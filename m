Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li271-223.members.linode.com ([178.79.152.223]:48333 "EHLO
	mail.mleia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab2HDVjk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Aug 2012 17:39:40 -0400
From: Vladimir Zapolskiy <vz@mleia.com>
To: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Cc: Arend van Spriel <arend@broadcom.com>
Subject: [PATCH] brcm80211: smac: set interface down on reset
Date: Sun,  5 Aug 2012 00:29:07 +0300
Message-Id: <1344115747-25627-1-git-send-email-vz@mleia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change marks interface as down on reset, otherwise the driver can't
reinitialize itself properly.

Without the change a transient problem turns out to be critical and leads
to inavailability to reset the driver without brcmsmac module unload/load
cycle:

    ieee80211 phy0: wl0: PSM microcode watchdog fired at 5993 (seconds). Resetting.
    brcms_c_dpc : PSM Watchdog, chipid 0xa8d9, chiprev 0x1
    ieee80211 phy0: wl0: fatal error, reinitializing
    ieee80211 phy0: Hardware restart was requested
    ieee80211 phy0: brcms_ops_start: brcms_up() returned -19

Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
Cc: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 192ad5c..a5edebe 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -1233,6 +1233,9 @@ uint brcms_reset(struct brcms_info *wl)
 	/* dpc will not be rescheduled */
 	wl->resched = false;
 
+	/* inform publicly that interface is down */
+	wl->pub->up = false;
+
 	return 0;
 }
 
-- 
1.7.10

