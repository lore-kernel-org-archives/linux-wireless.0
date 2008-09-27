Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:44996 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbYI0KyK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2008 06:54:10 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1431922rvb.1
        for <linux-wireless@vger.kernel.org>; Sat, 27 Sep 2008 03:54:10 -0700 (PDT)
Message-ID: <2da21fe50809270354i4d28335vfe166c166d33dc7@mail.gmail.com> (sfid-20080927_125417_122649_21F05B82)
Date: Sat, 27 Sep 2008 12:54:09 +0200
From: "Davide Pesavento" <davidepesa@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: wireless-testing modpost failure
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, YanBo <dreamfly281@gmail.com>
In-Reply-To: <1222507225.3798.45.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <2da21fe50809261104m3b7d99e3g8b56416b8182ca45@mail.gmail.com>
	 <20080926190007.GD3483@tuxdriver.com>
	 <1222457416.3798.25.camel@johannes.berg>
	 <2da21fe50809261325o62dea98dyf40b06e373f29f53@mail.gmail.com>
	 <1222504695.3798.38.camel@johannes.berg>
	 <1222507225.3798.45.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/9/27 Johannes Berg <johannes@sipsolutions.net>:
> On Sat, 2008-09-27 at 10:38 +0200, Johannes Berg wrote:
>
>> > >> >   Building modules, stage 2.
>> > >> >   MODPOST 216 modules
>> > >> > ERROR: "mpp_path_lookup" [net/mac80211/mac80211.ko] undefined!
>> > >> > ERROR: "mpp_path_add" [net/mac80211/mac80211.ko] undefined!
>> > >
>> > > Davide, can you tell me what file/line it fails in?
>> > >
>> >
>> > How can I tell you that?
>>
>> Good question. I was thinking the linker would complain at some earlier
>> point too, but I'll just try to reproduce it myself.
>
> Ok... I can't reproduce it. Can you turn off CONFIG_MAC80211_NOINLINE
> and see if that helps?
>

Yes, it works without CONFIG_MAC80211_NOINLINE.

I guess that it fails because gcc doesn't optimize out
CALL_RXH(ieee80211_rx_h_mesh_fwding) in
ieee80211_invoke_rx_handlers(), even if the comparison is always
false... (btw, there's an extra semicolon at the end of that line).

Regards,
Davide
