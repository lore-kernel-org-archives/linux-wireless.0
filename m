Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:15919 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbbAFLGW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 06:06:22 -0500
Message-ID: <54ABC19C.3080600@broadcom.com> (sfid-20150106_120625_430369_05A9AC6C)
Date: Tue, 6 Jan 2015 12:06:04 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Thomas Vincent-Cross <me@tvc.id.au>
CC: "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BCM43602 support in brcm80211, is BCM4360 support possible?
References: <SNT150-W949AB8EED942D9FBB6CF968A500@phx.gbl>
In-Reply-To: <SNT150-W949AB8EED942D9FBB6CF968A500@phx.gbl>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-wireless

On 12/28/14 14:02, Thomas Vincent-Cross wrote:
> Hi Broadcom devs,
>
> I see that support for your new 3x3 802.11ac chip, the BCM43602, has
> been added to the brcm80211 driver. I understand this is an "updated"
> chip that is almost a drop in replacement for the original BCM4360. I'm
> wondering since the support has been added for the newer chip to the
> open source driver, does that mean it's possible for support to be added
> for the older one? The BCM4360 is already featured in a tonne of
> devices, and would open the door for firmwares like OpenWrt to support
> devices like the Netgear R7000 and the Asus RT-AC68U. Now I don't know
> if the reason support hasn't been added is because of licensing issues
> with all of these already available devices, if so let me know.

Hi Thomas,

Bit late response, but I play the holiday-excuse card ;-) . From 
hardware perspective they are pin compatible (if I am not mistaken). 
However, from a driver/firmware perspective they are totally different. 
4360 uses a softmac driver (802.11 stack running in kernel) whereas 
43602 uses a fullmac driver (802.11 stack running on device). We do not 
have ok to release 4360 driver upstream at the moment and we have not 
started working on that. The brcm80211 softmac driver (brcmsmac) does 
not support any 11ac chips so that is a big task.

> I'm unsure whether emailing directly like this is the best way to ask,
> but I thought it'd be more direct than posting to the linux-wireless
> mailing list.

No worries. You could have Cc'ed linux-wireless, which I added in this 
reply.

Regards,
Arend

> Cheers,
> Thomas

