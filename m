Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60770 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1CBQ0V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2011 11:26:21 -0500
Received: by iyb26 with SMTP id 26so73187iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Mar 2011 08:26:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201103020832.17550.bernhard.schmidt@saxnet.de>
References: <201102281740.37036.bernhard.schmidt@saxnet.de>
 <201102281748.50054.bernhard.schmidt@saxnet.de> <20110301215856.GF6835@tux> <201103020832.17550.bernhard.schmidt@saxnet.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 2 Mar 2011 08:26:00 -0800
Message-ID: <AANLkTinUou54oKDdk04LP3E=TVGE2CNMetrZuKhwgwcS@mail.gmail.com>
Subject: Re: [PATCH 4/9] [cfg80211] add preliminary radar processing code
To: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"nbd@openwrt.org" <nbd@openwrt.org>,
	"dubowoj@neratec.com" <dubowoj@neratec.com>,
	"zefir.kurtisi@neratec.com" <zefir.kurtisi@neratec.com>,
	"simon.wunderlich@saxnet.de" <simon.wunderlich@saxnet.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 1, 2011 at 11:32 PM, Bernhard Schmidt
<bernhard.schmidt@saxnet.de> wrote:
> On Tuesday, March 01, 2011 22:58:56 Luis R. Rodriguez wrote:
>> On Mon, Feb 28, 2011 at 08:48:49AM -0800, Bernhard Schmidt wrote:
>> > --- /dev/null
>> > +++ b/net/wireless/radar.c
>> > @@ -0,0 +1,86 @@
>> > +/*
>> > + * Radar handling
>> > + *
>> > + * Copyright 2011 Bernhard Schmidt <bernhard.schmidt@saxnet.de>
>> > + *
>> > + * This program is free software; you can redistribute it and/or modify
>> > + * it under the terms of the GNU General Public License version 2 as
>> > + * published by the Free Software Foundation.
>> > + */
>> > +
>> > +#include <linux/ieee80211.h>
>> > +#include <net/cfg80211.h>
>> > +#include "radar.h"
>> > +
>> > +static struct radar_parameters regdomain_params[] = {
>> > +   { 60, 1800, 1000 },     /* FCC, correct? */
>> > +   { 60, 1800, 1000 },     /* ETSI */
>> > +   { 60, 1800, 1000 },     /* JP, correct? */
>> > +};
>>
>> If FCC or JP are not supported, I rather code not be present for it, or some
>> sort of flag for now to allow the radar enablement thingy to fail all the
>> time. In fact if FCC / JP regions are not supported you should not even
>> be able to operate in the mode of operation desired if your target channel
>> is a DFS one. If you do enter into an allowed non-DFS channel for that region
>> and you later try to switch to a DFS chanel then we'd hit another failure.
>
> That just means that I hadn't yet looked up the correct values, those
> are not available on the wiki either.

Either way, disable them if not supported yet.

  Luis
