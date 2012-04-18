Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50005 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab2DRCH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 22:07:57 -0400
Message-ID: <1334714841.3725.37.camel@jlt3.sipsolutions.net> (sfid-20120418_040802_015818_EC344263)
Subject: Re: [RFCv1] mac80211: Adds Software / Virtual AMP 80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Tue, 17 Apr 2012 19:07:21 -0700
In-Reply-To: <20120411070514.GB17779@aemeltch-MOBL1>
References: <1334059909-20513-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	 <1334059909-20513-2-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	 <4F846257.1060807@sipsolutions.net> <1334092668.16897.54.camel@aeonflux>
	 <4F84A422.3030900@sipsolutions.net> <1334093378.16897.62.camel@aeonflux>
	 <20120411070514.GB17779@aemeltch-MOBL1>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > > >> I don't get this patch at all. Why am I reviewing some very very basic
> > > >> skeleton code when we should be discussing userspace APIs (we have
> > > >> already discussed them with a few people years ago), how the AMP is
> > > >> going to be managed, how the security handshake is going to work, etc.
> 
> Do we have some outcome from that discussion?

This API-defining patch is probably the best we have:
http://johannes.sipsolutions.net/patches/kernel/all/2010-10-13-15%
3a24/035-bt3-amp.patch

> > The whole AMP control goes via A2MP and L2CAP and both are fully
> > implemented inside the kernel. In theory we do not even need to expose
> > HCI AMP interfaces to userspace.
> 
> Johannes, you can think of SoftAMP as analog of SoftMAC (vs FullMAC).
> SoftMAC is also possible to implement in user space but only
> authentication is done this way.

Yeah, and we also implement roaming and crypto stuff in userspace, for
softmac. Heck, we implement crypto in userspace even for fullmac, so
really ...

> Consider use case when user sends data over Bluetooth High Speed. Data
> go from obex user space to kernel L2CAP. Then you just need to add
> MAC header and send to wireless device. But you are proposing to copy data
> to user space for processing; then user space needs to copy data again to 
> kernel and then to wireless device.

I never said data should be copied. If you thought I did, you
misunderstood me.

> I think that user does not need to know that it uses High Speed, it just
> notice that speed is better :). Do you require any special API for
> latest and greatest wireless standard? Why user shall care about it?

Well, actually, yes, most new wireless standards do require new API for
the supplicant to be able to use them. The *user* never needs to know
about it of course -- consider the supplicant part of the wireless
stack.

johannes

