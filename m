Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:50197 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbYI0Me7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2008 08:34:59 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1456429rvb.1
        for <linux-wireless@vger.kernel.org>; Sat, 27 Sep 2008 05:34:58 -0700 (PDT)
Message-ID: <2da21fe50809270534w71609ffdjd1177384547ee1b@mail.gmail.com> (sfid-20080927_143504_542001_1F2BCEF8)
Date: Sat, 27 Sep 2008 14:34:58 +0200
From: "Davide Pesavento" <davidepesa@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: wireless-testing modpost failure
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, YanBo <dreamfly281@gmail.com>
In-Reply-To: <1222516090.3798.62.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <2da21fe50809261104m3b7d99e3g8b56416b8182ca45@mail.gmail.com>
	 <20080926190007.GD3483@tuxdriver.com>
	 <1222457416.3798.25.camel@johannes.berg>
	 <2da21fe50809261325o62dea98dyf40b06e373f29f53@mail.gmail.com>
	 <1222504695.3798.38.camel@johannes.berg>
	 <1222507225.3798.45.camel@johannes.berg>
	 <2da21fe50809270354i4d28335vfe166c166d33dc7@mail.gmail.com>
	 <1222516090.3798.62.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/9/27 Johannes Berg <johannes@sipsolutions.net>:
> On Sat, 2008-09-27 at 12:54 +0200, Davide Pesavento wrote:
>
>> > Ok... I can't reproduce it. Can you turn off CONFIG_MAC80211_NOINLINE
>> > and see if that helps?
>> >
>>
>> Yes, it works without CONFIG_MAC80211_NOINLINE.
>>
>> I guess that it fails because gcc doesn't optimize out
>> CALL_RXH(ieee80211_rx_h_mesh_fwding) in
>> ieee80211_invoke_rx_handlers(), even if the comparison is always
>> false... (btw, there's an extra semicolon at the end of that line).
>
> Ok, strange. I suggest we simply remove the debug_noinline from
> ieee80211_rx_h_mesh_fwding then, want to do a patch?

Why not putting an #ifdef CONFIG_MAC80211_MESH at the beginning of
ieee80211_rx_h_mesh_fwding instead?

Thanks,
Davide
