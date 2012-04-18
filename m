Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45969 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab2DROee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 10:34:34 -0400
Message-ID: <4F8ED0FC.3070704@sipsolutions.net> (sfid-20120418_163442_188056_0B5BBE77)
Date: Wed, 18 Apr 2012 07:34:36 -0700
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RFCv1] mac80211: Adds Software / Virtual AMP 80211
References: <1334059909-20513-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>  <1334059909-20513-2-git-send-email-Andrei.Emeltchenko.news@gmail.com>  <4F846257.1060807@sipsolutions.net> <1334092668.16897.54.camel@aeonflux>  <4F84A422.3030900@sipsolutions.net> <1334093378.16897.62.camel@aeonflux>  <20120411070514.GB17779@aemeltch-MOBL1>  <1334714841.3725.37.camel@jlt3.sipsolutions.net>  <20120418112017.GC19228@aemeltch-MOBL1> <1334749879.16897.221.camel@aeonflux>
In-Reply-To: <1334749879.16897.221.camel@aeonflux>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/18/2012 4:51 AM, Marcel Holtmann wrote:
>> Why do we need netlink commands like NL80211_CMD_HCI_AMP_ADD and
>> NL80211_CMD_HCI_AMP_DELETE if what we need is to create/delete virtual
>> interface which can be done with standard tools with a several lines
>> patch to iw:
>
> if we put the crypto piece aside for a minute, then we need to decide
> who is creating the actual AMP virtual interface on mac80211.
>
> And here the problem starts. That part is actually not triggered from
> userspace via wpa_supplicant. It is triggered over the A2MP (AMP manager
> protocol) that runs inside the Bluetooth stack in the kernel.
>
> Or is the idea to always keep the AMP virtual interface around? Meaning
> that as soon as we have a mac80211 card, we have an AMP virtual
> interface if the driver supports it?
>
> This is also a little bit of confusing since FullMac cards will not
> create an AMP virtual interface. With them you just see the HCI AMP
> controller on the Bluetooth side. Can an AMP virtual interface be just
> virtual inside mac80211 or does it have to have a netdev attached to it?

It shouldn't have a netdev, hence the separate commands (though I'll 
admit it's also possible to use the same commands, if a bit confusing). 
However, wpa_s would probably keep it around for use by BT whenever it 
didn't conflict with other wifi usage, e.g. when a device like ours has 
a limited number of MAC contexts you can create and use.

>> I see that all commands by default are sent via netlink to wpa_supplicant.
>> I think that we can send those command which cannot be handled by us
>> directly but I believe most command might be handled directly.
>
> The crypto itself is done either in hardware or with the kernel crypto
> framework. Just the EAP part is done inside wpa_supplicant.
>
> With the changes that we did for Bluetooth and its management interface,
> all the link keys are present in the kernel. And these are used as the
> WPA2 PSK. I don't think it is a good idea to push these around into
> userspace to wpa_supplicant one more time. And we would need to do that
> since bluetoothd has no option to hand them out.

I don't see that as a problem, since they're just HCI commands and the 
kernel just has to sort them into "for management" and "for data path", 
the former going to userspace.

> I still think that WPA2 PSK only EAP implementation for Bluetooth AMP
> controllers would be a good idea in the kernel. It has nothing to do
> with policy or user input in this specific case. The roundtrip into
> userspace for doing EAP 4-way handshake and some HMAC-SHA1 where the PSK
> is already present in kernel space seems really pointless.

I disagree -- I think rewriting crypto code is almost always a bad idea, 
and code reuse is good.

Beside this though, we need wpa_s managing the concurrency aspect 
anyway, so even if we had it in the kernel it wouldn't really change much.

johannes
