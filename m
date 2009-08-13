Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:6319 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbZHMUVB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 16:21:01 -0400
Received: by an-out-0708.google.com with SMTP id d40so853076and.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 13:21:02 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 13 Aug 2009 13:12:38 -0700
Message-ID: <43e72e890908131312p305e09e5tc25d6124af7b0a31@mail.gmail.com>
Subject: cfg80211 sme warning __cfg80211_disconnected
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After a while of being connected (hours) with ath9k as of
wireless-testing from yesterday, I got today this warning repeating in
a loop. The associated message would come up, and then after a few
minutes of ping'ing with no response from the default gw I hit the
warning. This repeats over and over. If I unload ath9k and load it it
gets cured.

This is against a Cisco AP at the office at ATHR in very busy
environment, the AP is a legacy AP (no 802.11n).

[ 1950.199432] wlan3: deauthenticated from <foo-access-point> (Reason: 7)
[ 1950.209187] wlan3: deauthenticating by local choice (reason=3)
[ 1950.209194] ------------[ cut here ]------------
[ 1950.209232] WARNING: at net/wireless/sme.c:620
__cfg80211_disconnected+0x1e3/0x240 [cfg80211]()
[ 1950.209238] Hardware name: 7660A14
[ 1950.209242] deauth failed: -67
[ 1950.209246] Modules linked in: ath9k <bleh> Not tainted 2.6.31-rc5-wl #133
[ 1950.209357] Call Trace:
[ 1950.209372]  [<ffffffff81057398>] warn_slowpath_common+0x78/0xb0
[ 1950.209381]  [<ffffffff8105742c>] warn_slowpath_fmt+0x3c/0x40
[ 1950.209405]  [<ffffffffa0189573>]
__cfg80211_disconnected+0x1e3/0x240 [cfg80211]
[ 1950.209430]  [<ffffffffa01876e8>]
__cfg80211_send_deauth+0x228/0x2a0 [cfg80211]
[ 1950.209461]  [<ffffffffa020c219>] ?
ieee80211_set_disassoc+0x1b9/0x220 [mac80211]
[ 1950.209485]  [<ffffffffa01877c4>] cfg80211_send_deauth+0x64/0x80 [cfg80211]
[ 1950.209512]  [<ffffffffa020dc58>] ieee80211_sta_work+0x368/0x10f0 [mac80211]
[ 1950.209523]  [<ffffffff814ebf8f>] ? thread_return+0x4e/0x6ff
[ 1950.209533]  [<ffffffff8104c1f0>] ? wake_up_process+0x10/0x20
[ 1950.209543]  [<ffffffff8105d615>] ? wakeup_softirqd+0x35/0x40
[ 1950.209568]  [<ffffffffa020d8f0>] ? ieee80211_sta_work+0x0/0x10f0 [mac80211]
[ 1950.209578]  [<ffffffff8106bcb5>] worker_thread+0x165/0x290
[ 1950.209588]  [<ffffffff81070ec0>] ? autoremove_wake_function+0x0/0x40
[ 1950.209596]  [<ffffffff8106bb50>] ? worker_thread+0x0/0x290
[ 1950.209604]  [<ffffffff81070ad6>] kthread+0x96/0xa0
[ 1950.209613]  [<ffffffff81012f8a>] child_rip+0xa/0x20
[ 1950.209622]  [<ffffffff81070a40>] ? kthread+0x0/0xa0
[ 1950.209629]  [<ffffffff81012f80>] ? child_rip+0x0/0x20
[ 1950.209635] ---[ end trace e935bef6f1bff088 ]---
[ 1952.087009] wlan3: direct probe to AP <foo-access-point> (try 1)
[ 1952.088061] wlan3 direct probe responded
[ 1952.088065] wlan3: authenticate with AP  <foo-access-point> (try 1)
[ 1952.089553] wlan3: authenticated
[ 1952.089574] wlan3: associate with AP  <foo-access-point> (try 1)
[ 1952.094079] wlan3: RX ReassocResp from  <foo-access-point>
(capab=0x11 status=0 aid=17)
[ 1952.094083] wlan3: associated
[ 3763.900056] wlan3: deauthenticated from  <foo-access-point> (Reason: 1)
[ 3763.909498] wlan3: deauthenticating by local choice (reason=3)
[ 3763.909505] ------------[ cut here ]------------

And here I hit the warning again.

The warning comes from this chunk:

                for (i = 0; i < MAX_AUTH_BSSES; i++) {
                        if (!wdev->auth_bsses[i])
                                continue;
                        bssid = wdev->auth_bsses[i]->pub.bssid;
                        ret = __cfg80211_mlme_deauth(rdev, dev, bssid, NULL, 0,
                                                WLAN_REASON_DEAUTH_LEAVING);
                        WARN(ret, "deauth failed: %d\n", ret);
                }

I'm using the distro Network Manager but git wpa_supplicant as of a
few weeks ago.

  Luis
