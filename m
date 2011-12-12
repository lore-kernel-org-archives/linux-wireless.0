Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:57950 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159Ab1LLMBL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 07:01:11 -0500
Received: from zeta.dmz-us.st.com (ns4.st.com [167.4.16.71])
	by beta.dmz-us.st.com (STMicroelectronics) with ESMTP id B3A153C
	for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2011 12:01:01 +0000 (GMT)
Received: from relay1.stm.gmessaging.net (unknown [10.230.100.17])
	by zeta.dmz-us.st.com (STMicroelectronics) with ESMTP id D98B64E
	for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2011 11:34:41 +0000 (GMT)
Received: from exdcvycastm003.EQ1STM.local (alteon-source-exch [10.230.100.61])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(Client CN "exdcvycastm003", Issuer "exdcvycastm003" (not verified))
	by relay1.stm.gmessaging.net (Postfix) with ESMTPS id E79D424C07C
	for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2011 13:00:57 +0100 (CET)
From: Dmitry TARNYAGIN <dmitry.tarnyagin@stericsson.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 12 Dec 2011 12:58:43 +0100
Subject: [PATCH v2] mac80211: Do not request FIF_BCN_PRBRESP_PROMISC for HW
 scan.
Message-ID: <2AC7D4AD8BA1C640B4C60C61C8E5201544BF514A78@EXDCVYMBSTM006.EQ1STM.local> (sfid-20111212_130115_366948_15AA13A2)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_configure_filter code used local->scanning as a boolean
value when it was a bit mask. Bits SCAN_COMPLETED, SCAN_ABORTED
should not set FIF_BCN_PRBRESP_PROMISC filter.

SCAN_HW_SCANNING should not set FIF_BCN_PRBRESP_PROMISC either,
as there is no explicit filter configuration request from
scan code. If a driver requires FIF_BCN_PRBRESP_PROMISC mode
during HW scanning, it's up to the driver to temporary enable it.

Similar mistake was fixed also in ieee80211_hw_config (power
configuration code).

Verified-by: Vitaly Wool <vitaly.wool@sonyericsson.com>
Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
---
 net/mac80211/main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 60198ac..1455836 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -47,7 +47,7 @@ void ieee80211_configure_filter(struct ieee80211_local *local)
 	if (atomic_read(&local->iff_allmultis))
 		new_flags |= FIF_ALLMULTI;
 
-	if (local->monitors || local->scanning)
+	if (local->monitors || test_bit(SCAN_SW_SCANNING, &local->scanning))
 		new_flags |= FIF_BCN_PRBRESP_PROMISC;
 
 	if (local->fif_probe_req || local->probe_req_reg)
@@ -150,8 +150,8 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
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
