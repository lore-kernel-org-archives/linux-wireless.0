Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:39015 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbcAGQYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 11:24:30 -0500
Subject: Re: lost connectivity until "wpa_cli reassociate" is issued
To: David Mosberger <davidm@egauge.net>, linux-wireless@vger.kernel.org
References: <CALnQHM3C=DVaTf58XDyh+rttVs-FSpc4ghozg9HJktEonq7w-g@mail.gmail.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <568E913D.7050301@candelatech.com> (sfid-20160107_172433_989369_294134D0)
Date: Thu, 7 Jan 2016 08:24:29 -0800
MIME-Version: 1.0
In-Reply-To: <CALnQHM3C=DVaTf58XDyh+rttVs-FSpc4ghozg9HJktEonq7w-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/07/2016 08:19 AM, David Mosberger wrote:
> We are seeing a curious issue where WLAN connectivity sometimes
> gets stuck until a "wpa_cli reassociate" command is issued.
>
> At the WPA level, everything appears to be working fine)
> (see thread starting at
> http://lists.infradead.org/pipermail/hostap/2016-January/034454.html).

I don't remember seeing you mention the driver and NIC you are using.

I think this is likely a driver bug, so please provide that info.

Thanks,
Ben

>
> What's truly odd is when connectivity is stuck, you can often "ping" the
> network's gateway exactly once and then you either get no response anymore
> or, after a long time (like 40-60 seconds), the floodgate opens and
> (almost) all previously sent ping responses arrive all at the same time
> (in the latter case, connectivity is fine afterwards again).
>
> This makes me wonder if there may be a packet queue that somehow gets
> stuck.
>
> I have turned on mac80211 debugging but have not found anything
> that seems to correlate with the loss of connectivity.  All I know is that
> wpa_cli reassociate so far is the least intrusive workaround that seems
> to reliably bring back connectivity.
>
> We are based on kernel 3.7.0 but have back-ported the mac80211 fixes
> from the linux-3.7.y stable branch.
>
> I'm not very familiar with the wireless stack, so any tips or hints on how to
> further debug this would be greatly appreciated.
>
> Thanks and best regards,
>
>    --david
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

