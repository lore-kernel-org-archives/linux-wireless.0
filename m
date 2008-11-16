Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:44138 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753016AbYKPWGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2008 17:06:06 -0500
Message-ID: <4920994B.3090600@lwfinger.net> (sfid-20081116_230612_181960_511F97B4)
Date: Sun, 16 Nov 2008 16:06:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Rate setting problem with pid algorithm for (at least) p54usb and
 b43
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

In testing today, I discovered that p54usb and b43 never advance beyond 1 Mb/s
when using the pid algorithm. When I monitored rc_pid_events in
/sys/kernel/debug/.../, I discovered the rate-setting details as follows:

3547 4302748627 pf_sample 12800 -9216 -9216 0

IIRC from debugging b43legacy in the past, this indicates that the pid code is
never seeing any successful transmissions. I debugged the code in
rate_control_pid_tx_status() and found that p54usb is passing 1 in
status.rates[0].count, thus the following fragment is handling each frame as
though it had retries, even though there were none:

        /* We count frames that totally failed to be transmitted as two bad
         * frames, those that made it out but had some retries as one good and
         * one bad frame. */
        if (!(info->flags & IEEE80211_TX_STAT_ACK)) {
                spinfo->tx_num_failed += 2;
                spinfo->tx_num_xmit++;
        } else if (info->status.rates[0].count) {
                spinfo->tx_num_failed++;
                spinfo->tx_num_xmit++;
        }

This is a regression introduced in commit 9ea2c74 "mac80211/drivers: rewrite the
rate control API".

The following patch fixes the problem. Is it right?

Index: wireless-testing/net/mac80211/rc80211_pid_algo.c
===================================================================
--- wireless-testing.orig/net/mac80211/rc80211_pid_algo.c
+++ wireless-testing/net/mac80211/rc80211_pid_algo.c
@@ -256,7 +256,7 @@ static void rate_control_pid_tx_status(v
        if (!(info->flags & IEEE80211_TX_STAT_ACK)) {
                spinfo->tx_num_failed += 2;
                spinfo->tx_num_xmit++;
-       } else if (info->status.rates[0].count) {
+       } else if (info->status.rates[0].count > 1) {
                spinfo->tx_num_failed++;
                spinfo->tx_num_xmit++;
        }

Larry
