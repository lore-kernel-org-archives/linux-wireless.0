Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38142 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab2GaRga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 13:36:30 -0400
Received: by yhmm54 with SMTP id m54so6335714yhm.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2012 10:36:29 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 31 Jul 2012 11:36:29 -0600
Message-ID: <CAMLZHHQkv_fHzd89fP7bNow7eL3oX+Duzr5rS5NJfhffqwUv2g@mail.gmail.com> (sfid-20120731_193634_219462_EA1BBDB4)
Subject: cfg80211_disconnected memory leak
From: Daniel Drake <dsd@laptop.org>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

After doing insmod/rmmod of libertas, kmemleak found:

unreferenced object 0xe90f1398 (size 64):
  comm "rmmod", pid 836, jiffies 4294944467 (age 34.620s)
  hex dump (first 32 bytes):
    58 cd 24 e9 58 cd 24 e9 02 00 00 00 c0 13 0f e9  X.$.X.$.........
    00 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<b0747a00>] kmemleak_alloc+0x26/0x44
    [<b049eff1>] __kmalloc+0xf3/0x176
    [<b0740aae>] cfg80211_disconnected+0x3e/0xc8
    [<b06008c9>] lbs_disconnect+0x73/0x86
    [<b0600955>] lbs_cfg_disconnect+0x79/0x88
    [<b0741c20>] __cfg80211_disconnect+0xf5/0x148
    [<b072cd8f>] cfg80211_netdev_notifier_call+0x253/0x452
    [<b075781b>] notifier_call_chain+0x2a/0x4b
    [<b04344f6>] __raw_notifier_call_chain+0x13/0x15
    [<b0434509>] raw_notifier_call_chain+0x11/0x13
    [<b06a51ff>] call_netdevice_notifiers+0x41/0x48
    [<b06a5247>] __dev_close_many+0x41/0x8b
    [<b06a5323>] dev_close_many+0x58/0xa8
    [<b06a5401>] rollback_registered_many+0x8e/0x1f8
    [<b06a5593>] rollback_registered+0x28/0x34
    [<b06a66b0>] unregister_netdevice_queue+0x51/0x6e

By adding some printks I have found that cfg80211_disconnected() does
indeed queue an event to be processed in cfg80211_wq on the eth0
device, but by the time cfg80211_process_rdev_events() is called, eth0
is no longer present in the rdev's netdev_list, so the event never
gets processed (or freed).

Daniel
