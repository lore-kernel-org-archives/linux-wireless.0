Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:58556 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2DRO4m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 10:56:42 -0400
Message-ID: <1334760977.16897.239.camel@aeonflux> (sfid-20120418_165647_159993_EEA06025)
Subject: Re: [RFCv1] mac80211: Adds Software / Virtual AMP 80211
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Wed, 18 Apr 2012 16:56:17 +0200
In-Reply-To: <4F8ED0FC.3070704@sipsolutions.net>
References: <1334059909-20513-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	  <1334059909-20513-2-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	  <4F846257.1060807@sipsolutions.net> <1334092668.16897.54.camel@aeonflux>
	  <4F84A422.3030900@sipsolutions.net> <1334093378.16897.62.camel@aeonflux>
	  <20120411070514.GB17779@aemeltch-MOBL1>
	  <1334714841.3725.37.camel@jlt3.sipsolutions.net>
	  <20120418112017.GC19228@aemeltch-MOBL1>
	 <1334749879.16897.221.camel@aeonflux> <4F8ED0FC.3070704@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> >> Why do we need netlink commands like NL80211_CMD_HCI_AMP_ADD and
> >> NL80211_CMD_HCI_AMP_DELETE if what we need is to create/delete virtual
> >> interface which can be done with standard tools with a several lines
> >> patch to iw:
> >
> > if we put the crypto piece aside for a minute, then we need to decide
> > who is creating the actual AMP virtual interface on mac80211.
> >
> > And here the problem starts. That part is actually not triggered from
> > userspace via wpa_supplicant. It is triggered over the A2MP (AMP manager
> > protocol) that runs inside the Bluetooth stack in the kernel.
> >
> > Or is the idea to always keep the AMP virtual interface around? Meaning
> > that as soon as we have a mac80211 card, we have an AMP virtual
> > interface if the driver supports it?
> >
> > This is also a little bit of confusing since FullMac cards will not
> > create an AMP virtual interface. With them you just see the HCI AMP
> > controller on the Bluetooth side. Can an AMP virtual interface be just
> > virtual inside mac80211 or does it have to have a netdev attached to it?
> 
> It shouldn't have a netdev, hence the separate commands (though I'll 
> admit it's also possible to use the same commands, if a bit confusing). 
> However, wpa_s would probably keep it around for use by BT whenever it 
> didn't conflict with other wifi usage, e.g. when a device like ours has 
> a limited number of MAC contexts you can create and use.

actually we can keep it around all the time. With A2MP we can signal
availability of the AMP controller or not. So Bluetooth can have
multiple AMP controllers available, but they can signal the other side
(over Bluetooth BR/EDR) that they don't have resources right now.

So I don't know why wpa_supplicant should create the AMP controller in
the first place. We can just always create it. And then have a command
for wpa_supplicant to signal if one has free resources or not.

> >> I see that all commands by default are sent via netlink to wpa_supplicant.
> >> I think that we can send those command which cannot be handled by us
> >> directly but I believe most command might be handled directly.
> >
> > The crypto itself is done either in hardware or with the kernel crypto
> > framework. Just the EAP part is done inside wpa_supplicant.
> >
> > With the changes that we did for Bluetooth and its management interface,
> > all the link keys are present in the kernel. And these are used as the
> > WPA2 PSK. I don't think it is a good idea to push these around into
> > userspace to wpa_supplicant one more time. And we would need to do that
> > since bluetoothd has no option to hand them out.
> 
> I don't see that as a problem, since they're just HCI commands and the 
> kernel just has to sort them into "for management" and "for data path", 
> the former going to userspace.

We do not wanna do HCI emulation inside wpa_supplicant. That sounds like
a pretty bad idea. We wanna do that inside the kernel. And if we end up
creating an LMP layer (SoftMAC for Bluetooth) inside the kernel, I wanna
share the code there.

> > I still think that WPA2 PSK only EAP implementation for Bluetooth AMP
> > controllers would be a good idea in the kernel. It has nothing to do
> > with policy or user input in this specific case. The roundtrip into
> > userspace for doing EAP 4-way handshake and some HMAC-SHA1 where the PSK
> > is already present in kernel space seems really pointless.
> 
> I disagree -- I think rewriting crypto code is almost always a bad idea, 
> and code reuse is good.

It is an EAP 4-way handshake. That is not even a handful of messages and
it is not really crypto code.

Anyhow for the sake of argument, say we would push the link key via
netlink into wpa_supplicant. How do we secure it?

> Beside this though, we need wpa_s managing the concurrency aspect 
> anyway, so even if we had it in the kernel it wouldn't really change much.

See above. That can be easily done with an extra nl80211 command that
wpa_supplicant gives to mac80211 and then handles A2MP to manage this.

In the worst case we can always be drastic and just move the Bluetooth
link back onto BR/EDR. AMP logical links can come and go as we please.

Regards

Marcel


