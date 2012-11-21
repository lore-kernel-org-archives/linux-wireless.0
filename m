Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2347 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455Ab2KUJiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 04:38:17 -0500
Message-ID: <50ACA0B0.6090700@broadcom.com> (sfid-20121121_103827_171568_0D06B078)
Date: Wed, 21 Nov 2012 10:36:48 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "George Nychis" <gnychis@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: what dictates p2p0 address?
References: <CA+7oygeWvsbrNz3k8ypqK=J6LMg1Zx0dN8S+ee-ywGEgtvQxqQ@mail.gmail.com>
In-Reply-To: <CA+7oygeWvsbrNz3k8ypqK=J6LMg1Zx0dN8S+ee-ywGEgtvQxqQ@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/21/2012 09:40 AM, George Nychis wrote:
> For an ad-hoc or Wifi-Direct interface, which usually seems to be
> named p2p0, I'm finding that the MAC address mirrors the Wifi card's
> MAC address for octets 2-6, but it seems as though octet 1 is dynamic.
>   So, for example:
>
> Wifi: 7c:d1:c3:e0:a6:81
> p2p0: 0e:d1:c3:e0:a6:81
>
> This is true across a bunch of devices that I own, but I can't seem to
> find a definitive answer to how octet 1 is mutated to choose the p2p0
> address.

First dealing with your opening sentence. Not sure if you truly mean 
ad-hoc here. Do not use that term if you are actually talking about 
wifi-direct because it is a totally different beast.

The definitive, but unambiguous, answer is in the WFA spec:

"The P2P Device shall assign a P2P Interface Address, corresponding to 
the format as described in §7.1.3.3.1 of IEEE Std 802.11‑2007 [1], which 
is used to communicate with the P2P Group Owner or Clients within a P2P 
Group. A P2P Interface Address is not required to be globally unique and 
may be locally administered. A P2P Interface Address may be the same as 
the P2P Device Address provided the requirements for P2P Interface 
Address in this clause are satisfied."

Actually, the MAC address details are in 802 spec (free IEEE download) 
in paragraph 9.2. Your p2p0 address has locally administered bit set and 
fiddle some more bits.

> Is this something chosen randomly, or is it a function of some other
> part of the address?

Most likely, as you can see from the example, it is derived. This is 
done in the device (or the driver) so there is no single rule or 
implementation except the guidelines/requirements from the spec.

Gr. AvS

