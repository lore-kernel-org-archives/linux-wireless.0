Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f176.google.com ([209.85.223.176]:43907 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbZIBSqJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 14:46:09 -0400
Received: by iwn6 with SMTP id 6so465690iwn.5
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2009 11:46:11 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 2 Sep 2009 11:45:51 -0700
Message-ID: <43e72e890909021145q671b4e65qb685dd0015342e12@mail.gmail.com>
Subject: Reproducing sme __cfg80211_disconnected warning
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>, ic.felix@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I can now reproduce this, at least once, will try in a bit again, but
here is the recipe:

  * Connected to work AP with WPA2 with Network manager
  * Issued sudo iw dev wlan0 connect home-ap-ssid
  * sudo pm-suspend
  * NM will show trace once you come up

[  195.961614] wlan0: deauthenticating by local choice (reason=3)
[  195.961940] phy0: device now idle
[  196.083964] phy0: Removed STA <my-work-ap-mac>
[  196.102260] phy0: Destroyed STA <my-work-ap-mac>
[  196.102504] wlan0: deauthenticating by local choice (reason=3)
[  196.102516] ------------[ cut here ]------------
[  196.102550] WARNING: at net/wireless/sme.c:617
__cfg80211_disconnected+0x209/0x260 [cfg80211]()
[  196.102557] Hardware name: 7660A14
[  196.102563] deauth failed: -67
[  196.102567] Modules linked in: <bleh>
[  196.102713] Pid: 3340, comm: wpa_supplicant Not tainted 2.6.31-rc8-wl #4
[  196.102720] Call Trace:
[  196.102737]  [<ffffffff81058588>] warn_slowpath_common+0x78/0xb0
[  196.102746]  [<ffffffff8105861c>] warn_slowpath_fmt+0x3c/0x40
[  196.102774]  [<ffffffffa017e3f9>]
__cfg80211_disconnected+0x209/0x260 [cfg80211]
[  196.102802]  [<ffffffffa017c0d8>]
__cfg80211_send_deauth+0x228/0x2a0 [cfg80211]
[  196.102829]  [<ffffffffa017c191>] cfg80211_send_deauth+0x41/0x80 [cfg80211]
[  196.102864]  [<ffffffffa020bc1f>]
ieee80211_send_deauth_disassoc+0x14f/0x170 [mac80211]
[  196.102898]  [<ffffffffa020d318>] ieee80211_mgd_deauth+0xe8/0x110 [mac80211]
[  196.102931]  [<ffffffffa0212fb9>] ieee80211_deauth+0x19/0x20 [mac80211]
[  196.102960]  [<ffffffffa017aade>] __cfg80211_mlme_deauth+0xee/0x130
[cfg80211]
[  196.102986]  [<ffffffffa018218e>] ?
cfg80211_mgd_wext_siwfreq+0x9e/0x1b8 [cfg80211]
[  196.103013]  [<ffffffffa017e969>] __cfg80211_disconnect+0x159/0x1d0
[cfg80211]
[  196.103038]  [<ffffffffa01821c5>]
cfg80211_mgd_wext_siwfreq+0xd5/0x1b8 [cfg80211]
[  196.103052]  [<ffffffff81507920>] ? ioctl_standard_call+0x0/0xd0
[  196.103077]  [<ffffffffa018068d>] cfg80211_wext_siwfreq+0x4d/0xd0 [cfg80211]
[  196.103088]  [<ffffffff8150797b>] ioctl_standard_call+0x5b/0xd0
[  196.103099]  [<ffffffff81452320>] ? __dev_get_by_name+0xa0/0xc0
[  196.103109]  [<ffffffff815070c5>] wext_ioctl_dispatch+0x165/0x1d0
[  196.103118]  [<ffffffff81507510>] ? ioctl_private_call+0x0/0xa0
[  196.103128]  [<ffffffff81507261>] wext_handle_ioctl+0x41/0x90
[  196.103137]  [<ffffffff814535f6>] dev_ioctl+0x676/0x820
[  196.103148]  [<ffffffff81087c90>] ? __lock_acquire+0x270/0x1120
[  196.103160]  [<ffffffff8143dd55>] sock_ioctl+0x95/0x280
[  196.103171]  [<ffffffff8113349d>] vfs_ioctl+0x1d/0xa0
[  196.103181]  [<ffffffff8113363a>] do_vfs_ioctl+0x8a/0x5a0
[  196.103191]  [<ffffffff81526cbb>] ? thread_return+0x4e/0x733
[  196.103203]  [<ffffffff81011f3a>] ? sysret_check+0x2e/0x69
[  196.103213]  [<ffffffff81133bd1>] sys_ioctl+0x81/0xa0
[  196.103222]  [<ffffffff81011f02>] system_call_fastpath+0x16/0x1b
[  196.103230] ---[ end trace 219bc7170d2a18cd ]---
[  196.148637] phy0: device no longer idle - in use
