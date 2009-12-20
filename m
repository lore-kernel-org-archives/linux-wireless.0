Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f211.google.com ([209.85.217.211]:36099 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbZLTWXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2009 17:23:53 -0500
Received: by gxk3 with SMTP id 3so3468084gxk.1
        for <linux-wireless@vger.kernel.org>; Sun, 20 Dec 2009 14:23:52 -0800 (PST)
Message-ID: <4B2EA3F4.8040108@lwfinger.net>
Date: Sun, 20 Dec 2009 16:23:48 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	bcm43xx-dev@lists.berlios.de,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] b43: Clear PCI configuration reg. 0x41 to avoid 	interference
 with C3 processor state
References: <4b2daf91.VB5IdAW/+fSDNPPV%Larry.Finger@lwfinger.net> 	<43e72e890912192251r4de4a3c3idb5e4c3723ef87aa@mail.gmail.com> <43e72e890912201353t491b7d97of1520e7995c0ef5b@mail.gmail.com>
In-Reply-To: <43e72e890912201353t491b7d97of1520e7995c0ef5b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/20/2009 03:53 PM, Luis R. Rodriguez wrote:
>> I should note 0x40 starts with vendor specific PCI config space so you
>> cannot guarantee different PCI devices use 0x41 will be used the same
>> for different devices. The documentation for the ath9k PCI-E devices
>> used that entry for something completely different but what I did not
>> do is try to very and ensure PCI devices do not use it it for the
>> same. I am told though that although this is PCI vendor space some
>> devices may still use similar private PCI config spaces on different
>> devices which just follows a practice. At this point we now have not
>> only b43, ipw and ath9k follow this but also prism54 and I think p54
>> uses this. I'll note I *highly* doubt this is used for the same thing
>> on all these devices and was just code copied from other Linux
>> drivers. In the case of Atheros Linux drivers I know it was copied
>> form Intel drivers, which is why I started questioning it all.
>>
>> Anyway, if it helps, that's great :) but it cannot be concluded its
>> all for the same thing unless you have proper documentation as this is
>> in PCI vendor space which *can* vary depending on device and vendor.
> 
> Larry, does this actually fix something or is this code purely speculative?

I got on this idea because I logged all PCI configuration read/write
values and discovered that the Broadcom wl driver did a read/write on
this location. A later examination of the open-source part of that
driver showed that they copied it from ipw2100. If anyone knows the
layout of the private area of the configuration space, they should;
however, they may be just propagating the code as you say.

This change does not fix the DMA error problem with Atom processors in
Netbooks. We have had one report of DMA errors in a Core Duo system -
AFAIK, the only non-Atom processor with the problem. That user has not
tested this patch.

Larry
