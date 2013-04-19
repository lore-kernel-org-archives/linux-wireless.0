Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:60218 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab3DSQOi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 12:14:38 -0400
Received: by mail-bk0-f45.google.com with SMTP id j10so1773074bkw.4
        for <linux-wireless@vger.kernel.org>; Fri, 19 Apr 2013 09:14:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <773DB8A82AB6A046AE0195C68612A3190152C98B@sbs2003.acksys.local>
References: <773DB8A82AB6A046AE0195C68612A3190152C98B@sbs2003.acksys.local>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Fri, 19 Apr 2013 18:14:17 +0200
Message-ID: <CAG6hwVN5LRVgchuX7QQWKEioBxTz3WXO5JUVv7fE3_X5LKXayg@mail.gmail.com> (sfid-20130419_181442_827594_B491AB01)
Subject: Re: Mutli vif in mesh mode
To: Cedric VONCKEN <cedric.voncken@acksys.fr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 19, 2013 at 5:04 PM, Cedric VONCKEN
<cedric.voncken@acksys.fr> wrote:
> I try to setup 2 mesh node on the same wireless card.
> I am using the ath9k driver from Compat 2013-02-22 (openwrt package).
>
> The command line sequence is
> Create mesh node 1
>         iw phy0 interface add wlan0 type mp
>         iw wlan0 set channel 44 HT20
>         ifconfig wlan0 up
>         iw wlan0 mesh join test
>
> Create mesh node 2
> iw phy0 interface add wlan1 type mp
> iw wlan1 set channel 44 HT20
> ifconfig wlan1 hw ether 00:09:90:aa:11:22 up
> iw wlan1 mesh join test2
>
> With wireshark and air pcap adapter, I cannot see the beacon for the
> second mesh node.
> If I  execute each mesh node separately, it works correctly (I see the
> beacon on wireshark)
>
> Is it possible to execute 2 mesh node on one ath9k wireless card?

This is because ath9k currently uses the hardware's adhoc beaconing
mode for mesh. See ath9k_hw_beaconinit() in
drivers/net/wireless/ath/ath9k/hw.c. This is probably wrong, and we
have a patch to beacon with AP mode, but I'll have to dig it up.

--
Thomas
