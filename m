Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:47043 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbZHXTn7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 15:43:59 -0400
Received: by iwn42 with SMTP id 42so1059951iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2009 12:44:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1251142659.12661.0.camel@johannes.local>
References: <43e72e890908171804t2279c750j7baeaf37ad4ff205@mail.gmail.com>
	<1250847779.17888.5.camel@johannes.local> <43e72e890908241121j43683b75x38ef7c2ef3a71463@mail.gmail.com>
	<1251142659.12661.0.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 24 Aug 2009 12:43:40 -0700
Message-ID: <43e72e890908241243w6b6de4d9o6e2fc22e5c814f5e@mail.gmail.com>
Subject: Re: Few warnings from master-2009-08-17
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 24, 2009 at 12:37 PM, Johannes
Berg<johannes@sipsolutions.net> wrote:
> On Mon, 2009-08-24 at 11:21 -0700, Luis R. Rodriguez wrote:
>
>> [ 1058.261102] No probe response from AP <AP-mac-address> after 500ms, try 1
>> [ 1058.761100] No probe response from AP <AP-mac-address> after 500ms, try 2
>> [ 1059.261122] No probe response from AP <AP-mac-address> after 500ms, try 3
>> [ 1059.761105] No probe response from AP <AP-mac-address> after 500ms, try 4
>> [ 1060.261105] No probe response from AP <AP-mac-address> after 500ms,
>> disconnecting.
>> [ 1060.264257] phy1: device now idle
>> [ 1060.268293] phy1: Removed STA <AP-mac-address>
>> [ 1060.290788] phy1: Destroyed STA <AP-mac-address>
>> [ 1060.290961] wlan6: deauthenticating by local choice (reason=3)
>
> Ok, but I don't see the warning after that.

Well it was in the e-mail. Here is some log, not sure if it was the
exact same one from that day but it does seem the capture the entire
thing:

[ 1058.261102] No probe response from AP  <AP-mac-address> after 500ms, try 1
[ 1058.761100] No probe response from AP  <AP-mac-address> after 500ms, try 2
[ 1059.261122] No probe response from AP  <AP-mac-address> after 500ms, try 3
[ 1059.761105] No probe response from AP  <AP-mac-address> after 500ms, try 4
[ 1060.261105] No probe response from AP  <AP-mac-address> after
500ms, disconnecting.
[ 1060.264257] phy1: device now idle
[ 1060.268293] phy1: Removed STA  <AP-mac-address>
[ 1060.290788] phy1: Destroyed STA  <AP-mac-address>
[ 1060.290961] wlan6: deauthenticating by local choice (reason=3)
[ 1060.291025] ------------[ cut here ]------------
[ 1060.291057] WARNING: at net/wireless/sme.c:610
__cfg80211_disconnected+0x1fb/0x260 [cfg80211]()
[ 1060.291064] Hardware name: 7660A14
[ 1060.291069] deauth failed: -67
[ 1060.291073] Modules linked in: ar9170usb mac80211 ath cfg80211
<bleh> [last unloaded: ar9170usb]
[ 1060.291230] Pid: 5525, comm: phy1 Tainted: G        W  2.6.31-rc6-wl #139
[ 1060.291237] Call Trace:
[ 1060.291252]  [<ffffffff810585a8>] warn_slowpath_common+0x78/0xb0
[ 1060.291262]  [<ffffffff8105863c>] warn_slowpath_fmt+0x3c/0x40
[ 1060.291287]  [<ffffffffa018682b>]
__cfg80211_disconnected+0x1fb/0x260 [cfg80211]
[ 1060.291312]  [<ffffffffa01849f2>] ? cfg80211_send_deauth+0x62/0x80 [cfg80211]
[ 1060.291336]  [<ffffffffa0184918>]
__cfg80211_send_deauth+0x228/0x2a0 [cfg80211]
[ 1060.291359]  [<ffffffffa0184a01>] cfg80211_send_deauth+0x71/0x80 [cfg80211]
[ 1060.291394]  [<ffffffffa03d9c1f>]
ieee80211_send_deauth_disassoc+0x14f/0x170 [mac80211]
[ 1060.291425]  [<ffffffffa03dd52b>] ieee80211_sta_work+0xceb/0x1100 [mac80211]
[ 1060.291456]  [<ffffffffa03dc840>] ? ieee80211_sta_work+0x0/0x1100 [mac80211]
[ 1060.291466]  [<ffffffff8106de80>] worker_thread+0x1d0/0x380
[ 1060.291475]  [<ffffffff8106de2e>] ? worker_thread+0x17e/0x380
[ 1060.291487]  [<ffffffff8152977b>] ? _spin_unlock_irqrestore+0x3b/0x70
[ 1060.291499]  [<ffffffff81073630>] ? autoremove_wake_function+0x0/0x40
[ 1060.291509]  [<ffffffff8106dcb0>] ? worker_thread+0x0/0x380
[ 1060.291518]  [<ffffffff81073266>] kthread+0xa6/0xb0
[ 1060.291529]  [<ffffffff810130ca>] child_rip+0xa/0x20

[ 1060.291540]  [<ffffffff81012a50>] ? restore_args+0x0/0x30
[ 1060.291549]  [<ffffffff810731c0>] ? kthread+0x0/0xb0
[ 1060.291557]  [<ffffffff810130c0>] ? child_rip+0x0/0x20
[ 1060.291564] ---[ end trace 7ef91a8a6ee731a3 ]---
[ 1060.428931] phy1: device no longer idle - scanning
[ 1068.424002] phy1: device now idle
[ 1073.259516] phy1: device no longer idle - scanning
[ 1081.234199] phy1: device now idle
[ 1086.357427] phy1: device no longer idle - scanning
[ 1094.366167] phy1: device now idle

Let me know if this helps or if you need something more recent.

  Luis
