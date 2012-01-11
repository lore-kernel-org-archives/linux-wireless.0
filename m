Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3835 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab2AKMYZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 07:24:25 -0500
Message-ID: <4F0D7F6B.5000601@broadcom.com> (sfid-20120111_132429_189387_3C9759DD)
Date: Wed, 11 Jan 2012 13:24:11 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Francis Moreau" <francis.moro@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"gregkh@suse.de" <gregkh@suse.de>
Subject: Re: About the patch:
 "staging: brcm80211: only enable brcmsmac if bcma is not set"
References: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com>
 <CAC9WiBhVWvvN-yqoYvBoD1uUi0P5e2cBu68Mva99wVxr7W0ibg@mail.gmail.com>
In-Reply-To: <CAC9WiBhVWvvN-yqoYvBoD1uUi0P5e2cBu68Mva99wVxr7W0ibg@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/11/2012 12:40 PM, Francis Moreau wrote:
> Hi,
> 
> This has finally been merged and is part of the 3.2 release.
> 
> So now distros don't ship the brcmsmac driver anymore which is
> basically the only driver which can handle my card.

I am not sure why you come to that conclusion, but I don't know the
criteria that distros use. In hindsight maybe this patch was not needed
because you could use module blacklist instead.

> did you really intend to do that ?
> 
> Thanks

For kernel v3.3 the brcmsmac driver will be using bcma. I had a look and
it turns out b43 is claiming the same bcma cores that brcmsmac claims.
So there you probably need to blacklist b43.

Gr. AvS

