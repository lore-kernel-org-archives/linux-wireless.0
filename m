Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:41341 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756011Ab2AKNNW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 08:13:22 -0500
Received: by obbup16 with SMTP id up16so832828obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2012 05:13:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F0D7F6B.5000601@broadcom.com>
References: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com>
	<CAC9WiBhVWvvN-yqoYvBoD1uUi0P5e2cBu68Mva99wVxr7W0ibg@mail.gmail.com>
	<4F0D7F6B.5000601@broadcom.com>
Date: Wed, 11 Jan 2012 14:13:21 +0100
Message-ID: <CAC9WiBgp02u90rJNC64kKU8GN7jcP_YOSRXSBbR83kHvf3CneQ@mail.gmail.com> (sfid-20120111_141325_793014_1C5C4BF9)
Subject: Re: About the patch: "staging: brcm80211: only enable brcmsmac if
 bcma is not set"
From: Francis Moreau <francis.moro@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"gregkh@suse.de" <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 11, 2012 at 1:24 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 01/11/2012 12:40 PM, Francis Moreau wrote:
>> Hi,
>>
>> This has finally been merged and is part of the 3.2 release.
>>
>> So now distros don't ship the brcmsmac driver anymore which is
>> basically the only driver which can handle my card.
>
> I am not sure why you come to that conclusion,

I checked on both OpenSuse and Mandriva, and they both have CONFIG_BCMA=m.

> For kernel v3.3 the brcmsmac driver will be using bcma.

Great.

But v3.2...

> I had a look and
> it turns out b43 is claiming the same bcma cores that brcmsmac claims.
> So there you probably need to blacklist b43.

That means that brcmsmac is still provided which is no more true with
this patch.

Why not having let brcmsmac handles the devices that are currently not
supported by b43 ? and why b43 claims some devices that it doesn't
drive correctly ?

-- 
Francis
