Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52218 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab0AGJYJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 04:24:09 -0500
Received: by ewy19 with SMTP id 19so10542595ewy.21
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2010 01:24:07 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20100107041018.GG1735@mail.wantstofly.org>
References: <1262710858.28653.5.camel@johannes.local>
	 <2d0a357f1001061431i7b306da7v2bf8717a3d3ab0cc@mail.gmail.com>
	 <20100107041018.GG1735@mail.wantstofly.org>
Date: Thu, 7 Jan 2010 10:24:07 +0100
Message-ID: <2d0a357f1001070124r1b8591adq3539ed53852eed3a@mail.gmail.com>
Subject: Re: [PATCH 2.6.33] mac80211: fix skb buffering issue
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The according patch in wireless-2.6 [1] has in net/mac80211/iface.c:

.ndo_set_mac_address    = eth_mac_addr
...
.ndo_set_mac_address    = eth_mac_addr

In the above mentionned, it is:

.ndo_set_mac_address    = ieee80211_change_mac,
...
.ndo_set_mac_address    = eth_mac_addr,

I guess in Johannes' patch this should be in both cases the same
(ieee80211_change_mac).

NOTE:
AFAICS, "mac80211: fix-up build breakage in 2.6.33" [2] is required in addition.

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/linville/wireless-2.6.git;a=blobdiff;f=net/mac80211/iface.c;h=c261cdb359ebbff176245430761512dc743b084c;hp=80c16f6e2af67e2798da4c417d69ce94dae86b71;hb=cf0277e714a0db302a8f80e1b85fd61c32cf00b3;hpb=301a8234ea81938f0f083ae4e274d9c9296f3c86
[2] http://git.kernel.org/?p=linux/kernel/git/linville/wireless-2.6.git;a=commit;h=debde9ea24d5512400456b1b64df361e422f078d

On Thu, Jan 7, 2010 at 5:10 AM, Lennert Buytenhek
<buytenh@wantstofly.org> wrote:
> On Wed, Jan 06, 2010 at 11:31:10PM +0100, Sedat Dilek wrote:
>
>> Why are there two different ".ndo_set_mac_address" in [1]?
>>
>>  static const struct net_device_ops ieee80211_dataif_ops = {
>> ...
>>       .ndo_set_mac_address    = ieee80211_change_mac,
>> +     .ndo_select_queue       = ieee80211_netdev_select_queue,
>>  };
>>
>>  static const struct net_device_ops ieee80211_monitorif_ops = {
>> ...
>>       .ndo_set_mac_address    = eth_mac_addr,
>> +     .ndo_select_queue       = ieee80211_monitor_select_queue,
>>  };
>
> Because a different queue selection algorithm is needed for
> monitor (ieee80211_monitor_select_queue) and non-monitor
> (ieee80211_netdev_select_queue) interfaces.  The commit message
> mentions this.
>
