Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57535 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378AbbE0S4K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2015 14:56:10 -0400
Message-ID: <55661349.50605@candelatech.com> (sfid-20150527_205626_234945_72A41CF9)
Date: Wed, 27 May 2015 11:56:09 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: ferran <ranker72@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: modify mac address with multiple interfaces on a device
References: <loom.20150527T185540-223@post.gmane.org>
In-Reply-To: <loom.20150527T185540-223@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/27/2015 11:44 AM, ferran wrote:
> Hi there,
> 
> I have noticed that having more than one interface pointing to the same
> physical device, modifying the address of any of these interfaces gets
> limited to the last 3 bits of the address, thus giving only 8 possible values.
> 
> Moreover, the mac address is set after the previous interface's one. Let's
> put it in a example (output copied by hand)

This does depend on the driver.  ath9k, for instance, has no limitations.

There are some subtitles relating to the ath9k BSSID mask that mean you often only
want to change only bytes 1 and 2 (leaving 0, 3, 4, 5 alone), but it is not
a hard requirement.

Thanks,
Ben

> 
> ---
> 
> $ iw dev
> phy#0
>      Interface wlan0
>             ifindex 7
>             type managed
> $ sudo ip link set wlan0 down
> $ sudo ip link set wlan0 address 00:11:22:33:44:55
> [ mac is changed ]
> $ sudo iw phy phy0 interface add mywlan type managed
> $ iw dev
> phy#0
>      Interface mywlan
>             ifindex 9
>             type managed
>      Interface wlan0
>             ifindex 7
>             type managed
> $ ip link
> [ ... ]
> 7: wlan0: [...]
>     link/ether 00:11:22:33:44:55 [...]
> 7: mywlan: [...]
>     link/ether 00:11:22:33:44:56 [...]
> 
> $ sudo ip link set wlan0 down
> $ sudo ip link set wlan0 address aa:bb:cc:dd:ee:ff
> RTNETLINK answers: Invalid argument
> 
> $ sudo ip link set wlan0 address 00:11:22:33:44:5f
> RTNETLINK answers: Invalid argument
> 
> $ sudo ip link set wlan0 address 00:11:22:33:44:57
> [ mac is changed ]
> 
> $ sudo iw mywlan del
> $ sudo ip link set wlan0 address aa:bb:cc:dd:ee:ff
> 
> $ ip link
> [ ... ]
> 7: wlan0: [...]
>     link/ether aa:bb:cc:dd:ee:ff [...]
> 
> ---
> 
> However, in another machine, using an iwlwifi card, I can change mac
> addresses disregarding other interfaces on same physical device. Another
> fact, when adding a new interface to a phy, the assigned mac address is
> derived from the factory immutable one, instead of from the other interface's.
> 
> ---
> 
> Where can I confirm this behaviour, is it docummented? Am I right saying
> that this depends on the actual driver? And how much difference is between
> one and another?
> 
> Thank you very much
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

