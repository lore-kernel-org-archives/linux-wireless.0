Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48541 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab0I2P2H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 11:28:07 -0400
Message-ID: <4CA35AFC.8050106@candelatech.com>
Date: Wed, 29 Sep 2010 08:27:56 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211:  Allow scanning single channel if other
 VIF is associated.
References: <1285632457-27539-1-git-send-email-greearb@candelatech.com> <1285632457-27539-2-git-send-email-greearb@candelatech.com> <1285658564.3885.1.camel@jlt3.sipsolutions.net> <4CA1F2A4.2090005@candelatech.com> <1285682224.3885.18.camel@jlt3.sipsolutions.net> <4CA206F0.40607@candelatech.com> <20100929054841.GB8382@jm.kir.nu>
In-Reply-To: <20100929054841.GB8382@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/28/2010 10:48 PM, Jouni Malinen wrote:
> On Tue, Sep 28, 2010 at 08:17:04AM -0700, Ben Greear wrote:
>> On 09/28/2010 06:57 AM, Johannes Berg wrote:
>>> You can run all networks in a single wpa_s instance, I believe, and then
>>> it'd know about all this, right?
>>
>> But then, if you want to add an additional interface, you have to restart
>> everything.
>
> We would you restart everything? You can add/remove interface
> dynamically..

I prefer to run one supplicant process per interface..just makes
everything easier in my environment.

>> I was thinking that maybe I could keep the logic in wpa_s, but instead of
>> all the special casing, just locate the current associated channel for the
>> phy in question and populate the scan-req with that single channel.
>
> wpa_supplicant already stores the operating channel: wpa_s->assoc_freq.
> You can iterate over the configured interfaces and fetch the current
> operating channel(s) using that without adding anything new to the
> kernel. With that, you could make some wpa_supplicant scans (e.g.,
> bgscan or scan for new networks if only a single network block is
> enabled) restrict the list of channels to scan. Still, some other scan
> requests (e.g., user initiated full scan or P2P Search) would need to be
> able to specify more channels even if one of the interfaces is
> associated.

Even if wpa_supplicant can work around this in user-space, the kernel
scanning logic for non-supplicant controlled interfaces still needs
the kernel portion.

That said, it looks like the patch is DOA as Johannes doesn't like
it at all, so I'll quite submitting it :)

> I would like to get rid of the one-channel-per-phy restriction, so I
> don't think I would like to see new code added for that.

If that ever happened, then the can_scan_one logic could simply indicate
you want to scan only on associated channels, not all of them.  It
would still help by not scanning on channels you have no intention
of using because other VIFs are already associated on channels you do
wish to use.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
