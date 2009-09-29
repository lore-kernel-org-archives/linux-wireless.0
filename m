Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:64723 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbZI2TZP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 15:25:15 -0400
Received: by iwn8 with SMTP id 8so3277285iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2009 12:25:19 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 29 Sep 2009 12:24:59 -0700
Message-ID: <43e72e890909291224t26b7e6cbmc78976165bd1bb88@mail.gmail.com>
Subject: SME warning on 2.6.32-rc<bleh>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I believe the problem comes from the assumption from cfg80211 that
previous deauthentications would have gone through before we run
__cfg80211_disconnected() and are using wext or nl80211
connec/disconnectt. Under certain conditions (clearly not known yet)
this is not true and we'll end up asking mac80211 to deauthenticate us
from a BSS we already deauthenticated to end end up with an -ENOLINK
on our mac80211 cfg80211 deauth ops. It seems this race was expected
all along on mac80211 ieee80211_mgd_deauth():

        /*
         * cfg80211 should catch this ... but it's racy since
         * we can receive a deauth frame, process it, hand it
         * to cfg80211 while that's in a locked section already
         * trying to tell us that the user wants to disconnect.
         */
        if (!bssid) {
                mutex_unlock(&ifmgd->mtx);
                return -ENOLINK;
        }

So it seems we do need to address that race but I'm not yet sure how.

Here is a warning from the latest wireless-testing. Unfortunately I
cannot reproduce in a systematic way, I've tried even different boot
configuration (mem=300M) and CPU pegged at 800 MHz thinking the race
occurs when mac80211 takes its sweet time deathenticating but that
wasn't the case.

    phy0: device now idle
    phy0: Removed STA <your-AP-bssid>
    phy0: Destroyed STA <your-AP-bssid>
    wlan0: deauthenticating from <your-AP-bssid> by local choice (reason=3)
    ------------[ cut here ]------------
    WARNING: at net/wireless/sme.c:620
__cfg80211_disconnected+0x209/0x260 [cfg80211]()
    Hardware name: 7660A14
    deauth failed: -67 (editorial note: -ENOLINK)
    Modules linked in: <etc>
    Pid: 1829, comm: wpa_supplicant Not tainted 2.6.32-rc2-wl #45
    Call Trace:
     [<ffffffff8105be78>] warn_slowpath_common+0x78/0xb0
     [<ffffffff8105bf0c>] warn_slowpath_fmt+0x3c/0x40
     [<ffffffffa00d5489>] __cfg80211_disconnected+0x209/0x260 [cfg80211]
     [<ffffffffa00d31a8>] __cfg80211_send_deauth+0x228/0x2a0 [cfg80211]
     [<ffffffffa00d3261>] cfg80211_send_deauth+0x41/0x80 [cfg80211]
     [<ffffffffa01c1c1f>] ieee80211_send_deauth_disassoc+0x14f/0x170 [mac80211]
     [<ffffffffa01c4945>] ieee80211_mgd_deauth+0xf5/0x120 [mac80211]
     [<ffffffffa01c8fa9>] ieee80211_deauth+0x19/0x20 [mac80211]
     [<ffffffffa00d1bae>] __cfg80211_mlme_deauth+0xee/0x130 [cfg80211]
     [<ffffffffa00d59f9>] __cfg80211_disconnect+0x159/0x1d0 [cfg80211]
     [<ffffffffa00d9245>] cfg80211_mgd_wext_siwfreq+0xd5/0x1b8 [cfg80211]
     [<ffffffff81516b30>] ? ioctl_standard_call+0x0/0xd0
     [<ffffffffa00d772d>] cfg80211_wext_siwfreq+0x4d/0xd0 [cfg80211]
     [<ffffffff81516b8b>] ioctl_standard_call+0x5b/0xd0
     [<ffffffff8144e040>] ? __dev_get_by_name+0xa0/0xc0
     [<ffffffff815162b5>] wext_ioctl_dispatch+0x165/0x1d0
     [<ffffffff81516700>] ? ioctl_private_call+0x0/0xa0
     [<ffffffff81516451>] wext_handle_ioctl+0x41/0x90
     [<ffffffff8144f316>] dev_ioctl+0x676/0x820
     [<ffffffff8107abf0>] ? autoremove_wake_function+0x0/0x40
     [<ffffffff8143aec5>] sock_ioctl+0x95/0x280
     [<ffffffff811445bd>] vfs_ioctl+0x1d/0xa0
     [<ffffffff8114475a>] do_vfs_ioctl+0x8a/0x5a0
     [<ffffffff815336eb>] ? thread_return+0x4e/0x733
     [<ffffffff81144cf1>] sys_ioctl+0x81/0xa0
     [<ffffffff81011ec2>] system_call_fastpath+0x16/0x1b
    ---[ end trace 7d678c5342bdca98 ]---
