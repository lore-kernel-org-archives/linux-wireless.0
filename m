Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:46534 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab2DKHEh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 03:04:37 -0400
Date: Wed, 11 Apr 2012 10:05:16 +0300
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RFCv1] mac80211: Adds Software / Virtual AMP 80211
Message-ID: <20120411070514.GB17779@aemeltch-MOBL1> (sfid-20120411_090442_994683_C9FC4152)
References: <1334059909-20513-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <1334059909-20513-2-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <4F846257.1060807@sipsolutions.net>
 <1334092668.16897.54.camel@aeonflux>
 <4F84A422.3030900@sipsolutions.net>
 <1334093378.16897.62.camel@aeonflux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1334093378.16897.62.camel@aeonflux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes and Marcel,

On Tue, Apr 10, 2012 at 11:29:38PM +0200, Marcel Holtmann wrote:
> Hi Johannes,
> 
> > >> I don't get this patch at all. Why am I reviewing some very very basic
> > >> skeleton code when we should be discussing userspace APIs (we have
> > >> already discussed them with a few people years ago), how the AMP is
> > >> going to be managed, how the security handshake is going to work, etc.

Do we have some outcome from that discussion?

> > > adding AMP (meaning Bluetooth Alternate MAC/PHY in case anybody cares)
> > > for SoftMac WiFi cards should be done solely in kernel space between
> > > Bluetooth core and mac80211. All the FullMac cards will expose the HCI
> > > AMP directly via the Bluetooth core. See Marvell solution for example.

Also Qualcomm.

> > > If we require a userspace interaction, I think we are doing something
> > > wrong here. And as far as I can tell, the only tricky part is the WPA2
> > > PSK 4-way handshake. We would need a kernel implementation for that.
> > 
> > You already know I disagree, I don't want this code re-implemented in 
> > kernel space when adding a few tightly controlled APIs is all it needs 
> > to use an existing implementation of the relevant mechanisms.
> 
> I know that, but I still think it is the right approach here. It might
> take me a bit longer to convince you ;)
> 
> The whole AMP control goes via A2MP and L2CAP and both are fully
> implemented inside the kernel. In theory we do not even need to expose
> HCI AMP interfaces to userspace.

Johannes, you can think of SoftAMP as analog of SoftMAC (vs FullMAC).
SoftMAC is also possible to implement in user space but only
authentication is done this way.

Consider use case when user sends data over Bluetooth High Speed. Data
go from obex user space to kernel L2CAP. Then you just need to add
MAC header and send to wireless device. But you are proposing to copy data
to user space for processing; then user space needs to copy data again to 
kernel and then to wireless device.

I think that user does not need to know that it uses High Speed, it just
notice that speed is better :). Do you require any special API for
latest and greatest wireless standard? Why user shall care about it?

Best regards 
Andrei Emeltchenko 

> We just do it for convince right now so
> we can sniff the transfers, but even that is no longer needed with the
> addition of the Bluetooth monitor socket.
> 
> Anyway, my real point is that we should not need any extra userspace API
> to add support for Bluetooth HS in mac80211.
> 
> Regards
> 
> Marcel
> 
> 
