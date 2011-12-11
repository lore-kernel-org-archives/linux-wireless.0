Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59920 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab1LKVxZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Dec 2011 16:53:25 -0500
Received: by dajs34 with SMTP id s34so1224918daj.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Dec 2011 13:53:24 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 11 Dec 2011 22:47:46 +0100
Message-ID: <CAMG6FYgGB12s+vTGRuKb1E8qzwMa3=kV2pm5ZFQ=BO4WqqZSRQ@mail.gmail.com> (sfid-20111211_225335_668297_3861F175)
Subject: [PATCH] mac80211: Do not request FIF_BCN_PRBRESP_PROMISC for HW scan.
From: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
To: linux-wireless@vger.kernel.org, Bartosz.Markowski@tieto.com,
	Janusz.Dziedzic@tieto.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_configure_filter code used local->scanning as a boolean value
when it was a bit mask. Bits SCAN_HW_SCANNING, SCAN_COMPLETED, SCAN_ABORTED
should not set FIF_BCN_PRBRESP_PROMISC filter.

Similar mistake was fixed also in ieee80211_hw_config (power
configuration code).

Verified-by: Vitaly Wool <vitaly.wool@sonyeric­sson.com>
Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
---
 net/mac80211/main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index cae4435..54f78ab 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -47,7 +47,7 @@ void ieee80211_configure_filter(struct ieee80211_local *local)
 	if (atomic_read(&local->iff_allmultis))
 		new_flags |= FIF_ALLMULTI;

-	if (local->monitors || local->scanning)
+	if (local->monitors || test_bit(SCAN_SW_SCANNING, &local->scanning))
 		new_flags |= FIF_BCN_PRBRESP_PROMISC;

 	if (local->fif_probe_req || local->probe_req_reg)
@@ -193,8 +193,8 @@ int ieee80211_hw_config(struct ieee80211_local
*local, u32 changed)
 		changed |= IEEE80211_CONF_CHANGE_SMPS;
 	}

-	if ((local->scanning & SCAN_SW_SCANNING) ||
-	    (local->scanning & SCAN_HW_SCANNING))
+	if (test_bit(SCAN_SW_SCANNING, &local->scanning) ||
+	    test_bit(SCAN_HW_SCANNING, &local->scanning))
 		power = chan->max_power;
 	else
 		power = local->power_constr_level ?
-- 
1.7.1
