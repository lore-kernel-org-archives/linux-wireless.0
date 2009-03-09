Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:52015 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbZCIRii (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 13:38:38 -0400
Received: by fxm24 with SMTP id 24so1339103fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2009 10:38:35 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: Another "scan handling in mac80211" bug
Date: Mon, 9 Mar 2009 18:38:16 +0100
Cc: johannes@sipsolutions.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903091838.16365.helmut.schaa@gmail.com> (sfid-20090309_183843_259857_EACCC2C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I was just unable to scan again after waking up from s2disk. Luckily I
still had some debug output in mac80211 from my previous patch:

[66796.154861] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[66796.164133] ieee80211_sta_work
[66796.164142] ieee80211_sta_work 2
[66796.178069] wlan0: direct probe to AP XX:XX:XX:XX:XX:XX try 1
[66796.375058] cfg80211_wext_siwscan

Ok, someone (I guess wpa_supplicant) triggered a scan.

[66796.375065] ieee80211_scan
[66796.375067] ieee80211_scan: request_scan
[66796.375070] ieee80211_request_scan
[66796.375073] ieee80211_request_scan queue_work

The scan is not started immediately due to mode == STA.

[66796.375116] ieee80211_sta_work
[66796.375120] ieee80211_sta_work 2

Good, the sta_work is executed but does not start the scan (I also had
a debug printk in ieee80211_start_scan).

Here's the according part of the code:

1759   if (ifmgd->state != IEEE80211_STA_MLME_DIRECT_PROBE &&
1760       ifmgd->state != IEEE80211_STA_MLME_AUTHENTICATE &&
1761       ifmgd->state != IEEE80211_STA_MLME_ASSOCIATE &&
1762       test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request)) {
1763     /*
1764      * The call to ieee80211_start_scan can fail but ieee80211_request_scan
1765      * (which queued ieee80211_sta_work) did not return an error. Thus, call
1766      * ieee80211_scan_failed here if ieee80211_start_scan fails in order to
1767      * notify the scan requester.
1768      */
1769     if (ieee80211_start_scan(sdata, local->scan_req))
1770       ieee80211_scan_failed(local);
1771     return;
1772   }

Ok, we are currently in state IEEE80211_STA_MLME_DIRECT_PROBE and as such
do not trigger the scan right away. IEEE80211_STA_REQ_SCAN should still be
set. Seems still fine to me.

[66796.375329] cfg80211_wext_siwscan EBUSY
[66796.376170] ieee80211_sta_work
[66796.376174] ieee80211_sta_work 2
[66796.376179] wlan0: direct probe to AP XX:XX:XX:XX:XX:XX try 2
[66796.576063] ieee80211_sta_work
[66796.576072] ieee80211_sta_work 2
[66796.576079] wlan0: direct probe to AP XX:XX:XX:XX:XX:XX try 3
[66796.776061] ieee80211_sta_work
[66796.776069] ieee80211_sta_work 2
[66796.776076] wlan0: direct probe to AP XX:XX:XX:XX:XX:XX timed out

Hmm, the direct probe timed out, thus the state moves to
IEEE80211_STA_MLME_DISABLED but sta_work will only run again when the
next association attempt is being made. However, we still have
IEEE80211_STA_REQ_SCAN set.

[66816.374308] cfg80211_wext_siwscan EBUSY
[66823.901663] cfg80211_wext_siwscan EBUSY

All subsequent scan requests will fail in cfg80211_wext_siwscan as mac80211
did not notify cfg80211 about the scan result.

I guess it should be sufficient to queue one more sta_work after the MLME
moves to IEEE80211_STA_MLME_DISABLED state. In case IEEE80211_STA_REQ_SCAN
is still set the scan will get started and cfg80211 gets notified about the
result.

Does that seem correct?

Thanks,
Helmut
