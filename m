Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33717 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903AbbCRTSo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 15:18:44 -0400
Message-ID: <1426706320.3001.21.camel@sipsolutions.net> (sfid-20150318_201852_997698_CC73CED4)
Subject: Re: wiphy band information
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 18 Mar 2015 20:18:40 +0100
In-Reply-To: <550952B4.4050400@broadcom.com>
References: <550952B4.4050400@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

> Is it ok to update the wiphy band information after registration. 

I believe this will cause issues.

> In 
> brcmfmac the firmware is queried to obtain the supported channels. 
> However, it returns the channels for the current country set in 
> firmware. So after probe/registration iw shows:

> Looks fine apart from the power levels so it made me wonder if what I am 
> doing is allowed. Any opinion on this?

I think the regulatory flags will also break, since some are
pre-processed during wiphy registration.

> I assume the supported band info is intended to show what hardware can 
> do regardless of the configured country, but I have no way to pull that 
> info from the device.

I'd recommend finding (and hard-coding) a superset of all the channels
that the hardware could supported, and then dynamically setting the
disabled flag on those channels that the (current) regulatory
information cannot do.

This is something that needs to be handled throughout the code since
regulatory information can already change, but adding/removing channels
is something I'd really recommend against.

johannes

