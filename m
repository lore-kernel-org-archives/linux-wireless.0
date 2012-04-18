Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50148 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab2DRMJ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 08:09:29 -0400
Date: Wed, 18 Apr 2012 15:10:16 +0300
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RFCv1] mac80211: Adds Software / Virtual AMP 80211
Message-ID: <20120418121014.GD19228@aemeltch-MOBL1> (sfid-20120418_140934_015080_82DCE219)
References: <1334059909-20513-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <1334059909-20513-2-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <4F846257.1060807@sipsolutions.net>
 <1334092668.16897.54.camel@aeonflux>
 <4F84A422.3030900@sipsolutions.net>
 <1334093378.16897.62.camel@aeonflux>
 <20120411070514.GB17779@aemeltch-MOBL1>
 <1334714841.3725.37.camel@jlt3.sipsolutions.net>
 <20120418112017.GC19228@aemeltch-MOBL1>
 <1334749879.16897.221.camel@aeonflux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1334749879.16897.221.camel@aeonflux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel,

On Wed, Apr 18, 2012 at 01:51:19PM +0200, Marcel Holtmann wrote:
> Hi Andrei,
> 
> > > > > > >> I don't get this patch at all. Why am I reviewing some very very basic
> > > > > > >> skeleton code when we should be discussing userspace APIs (we have
> > > > > > >> already discussed them with a few people years ago), how the AMP is
> > > > > > >> going to be managed, how the security handshake is going to work, etc.
> > > > 
> > > > Do we have some outcome from that discussion?
> > > 
> > > This API-defining patch is probably the best we have:
> > > http://johannes.sipsolutions.net/patches/kernel/all/2010-10-13-15%
> > > 3a24/035-bt3-amp.patch
> > 
> > Thanks for the link. After looking to the patches I think that there are
> > some similarities with respect to interface type. As I understood the
> > basic idea is the same: create virtual interface. But in your case the
> > implementation is really difficult.
> > 
> > Why do we need netlink commands like NL80211_CMD_HCI_AMP_ADD and
> > NL80211_CMD_HCI_AMP_DELETE if what we need is to create/delete virtual
> > interface which can be done with standard tools with a several lines
> > patch to iw:
> 
> if we put the crypto piece aside for a minute, then we need to decide
> who is creating the actual AMP virtual interface on mac80211.

I think we can start with creating softAMP in advance.

> 
> And here the problem starts. That part is actually not triggered from
> userspace via wpa_supplicant. It is triggered over the A2MP (AMP manager
> protocol) that runs inside the Bluetooth stack in the kernel.

A2MP might work without AMP present on the system. Do we need to create
AMP after "Discover AMP" requests? I believe we might be too smart here.
but this is possibly.

> Or is the idea to always keep the AMP virtual interface around? Meaning
> that as soon as we have a mac80211 card, we have an AMP virtual
> interface if the driver supports it?

IMO this shall be the case.

> This is also a little bit of confusing since FullMac cards will not
> create an AMP virtual interface. With them you just see the HCI AMP
> controller on the Bluetooth side. Can an AMP virtual interface be just
> virtual inside mac80211 or does it have to have a netdev attached to it?

If we create virtual interface then netdev is allocated and we can handle
it with common tools.

> <snip>
> 
> > > > > The whole AMP control goes via A2MP and L2CAP and both are fully
> > > > > implemented inside the kernel. In theory we do not even need to expose
> > > > > HCI AMP interfaces to userspace.
> > > > 
> > > > Johannes, you can think of SoftAMP as analog of SoftMAC (vs FullMAC).
> > > > SoftMAC is also possible to implement in user space but only
> > > > authentication is done this way.
> > > 
> > > Yeah, and we also implement roaming and crypto stuff in userspace, for
> > > softmac. Heck, we implement crypto in userspace even for fullmac, so
> > > really ...
> > 
> > Does crypto stuff mean getting symmetric key?
> > 
> > I see that all commands by default are sent via netlink to wpa_supplicant.
> > I think that we can send those command which cannot be handled by us
> > directly but I believe most command might be handled directly.
> 
> The crypto itself is done either in hardware or with the kernel crypto
> framework. Just the EAP part is done inside wpa_supplicant.
> 
> With the changes that we did for Bluetooth and its management interface,
> all the link keys are present in the kernel. And these are used as the
> WPA2 PSK. I don't think it is a good idea to push these around into
> userspace to wpa_supplicant one more time. And we would need to do that
> since bluetoothd has no option to hand them out.
> 
> I still think that WPA2 PSK only EAP implementation for Bluetooth AMP
> controllers would be a good idea in the kernel. It has nothing to do
> with policy or user input in this specific case. The roundtrip into
> userspace for doing EAP 4-way handshake and some HMAC-SHA1 where the PSK
> is already present in kernel space seems really pointless.

I do agree here with Marcel.

Best regards 
Andrei Emeltchenko 

