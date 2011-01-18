Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54320 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab1ARTYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 14:24:18 -0500
Received: by gwj20 with SMTP id 20so2417195gwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jan 2011 11:24:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295341531.3563.4.camel@jlt3.sipsolutions.net>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
 <1295156534-4178-7-git-send-email-arik@wizery.com> <1295167829.3574.10.camel@jlt3.sipsolutions.net>
 <AANLkTik=WDsehr0EgW7QemfdmokvaLzg1ugASwiuCOXt@mail.gmail.com>
 <AANLkTi=FRAjCxOBAtXFdzwSqG6DQ+oneoe-THQjsd_Wx@mail.gmail.com>
 <1295256929.3726.2.camel@jlt3.sipsolutions.net> <AANLkTiky+j6P9oibrWzDzfNugrADtb9p21TVn7WFAY6_@mail.gmail.com>
 <1295341531.3563.4.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 18 Jan 2011 21:17:32 +0200
Message-ID: <AANLkTi=1jnS789TSPW3xjORK+6zLhfEaj8aDaLanjmRq@mail.gmail.com>
Subject: Re: Fwd: [PATCH 06/10] mac80211: add HW flag for disabling auto
 link-PS in AP mode
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 18, 2011 at 11:05, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2011-01-18 at 00:47 +0200, Arik Nemtsov wrote:
>
>
> Well if for instance the station happens to send two frames with the PM
> bit set, meaning that it is in PS-poll mode but doesn't want to wake up
> even though it's transmitting a frame, mac80211 will only call
> sta_notify once for the first frame to tell the driver the station went
> to sleep -- the second frame just indicates that it's still asleep.
>
> The same might happen with this, but of course it depends on what the
> device does. If the driver will call the new API function twice, then
> mac80211 will be very confused. Therefore, I think the new API function
> should do some checks about whether the station is already asleep/awake
> before invoking ap_sta_ps_start/end so that the counters are correct.
>
> In this case, the driver might want to know if the station was already
> in the indicated state -- this might be indicated by the return value.
>

Yea i missed the double atomic_inc/dec in case the function is called
twice. I'll add a EINVAL return value in case the requested PM state
is already in effect.

Thanks,
Arik
