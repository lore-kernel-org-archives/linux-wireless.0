Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:57033 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab2DJV3w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 17:29:52 -0400
Message-ID: <1334093378.16897.62.camel@aeonflux> (sfid-20120410_232958_771850_0130C64F)
Subject: Re: [RFCv1] mac80211: Adds Software / Virtual AMP 80211
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Tue, 10 Apr 2012 23:29:38 +0200
In-Reply-To: <4F84A422.3030900@sipsolutions.net>
References: <1334059909-20513-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	  <1334059909-20513-2-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	  (sfid-20120410_141120_556160_FD038CE7) <4F846257.1060807@sipsolutions.net>
	 <1334092668.16897.54.camel@aeonflux> <4F84A422.3030900@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> >> I don't get this patch at all. Why am I reviewing some very very basic
> >> skeleton code when we should be discussing userspace APIs (we have
> >> already discussed them with a few people years ago), how the AMP is
> >> going to be managed, how the security handshake is going to work, etc.
> >
> > adding AMP (meaning Bluetooth Alternate MAC/PHY in case anybody cares)
> > for SoftMac WiFi cards should be done solely in kernel space between
> > Bluetooth core and mac80211. All the FullMac cards will expose the HCI
> > AMP directly via the Bluetooth core. See Marvell solution for example.
> >
> > If we require a userspace interaction, I think we are doing something
> > wrong here. And as far as I can tell, the only tricky part is the WPA2
> > PSK 4-way handshake. We would need a kernel implementation for that.
> 
> You already know I disagree, I don't want this code re-implemented in 
> kernel space when adding a few tightly controlled APIs is all it needs 
> to use an existing implementation of the relevant mechanisms.

I know that, but I still think it is the right approach here. It might
take me a bit longer to convince you ;)

The whole AMP control goes via A2MP and L2CAP and both are fully
implemented inside the kernel. In theory we do not even need to expose
HCI AMP interfaces to userspace. We just do it for convince right now so
we can sniff the transfers, but even that is no longer needed with the
addition of the Bluetooth monitor socket.

Anyway, my real point is that we should not need any extra userspace API
to add support for Bluetooth HS in mac80211.

Regards

Marcel


