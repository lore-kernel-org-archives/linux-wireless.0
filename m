Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53548 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab0LPOko (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 09:40:44 -0500
Subject: Re: [RFC 0/2] remain-on-channel HW offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Chuck Crisler <ccrisler@vgocom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <14A60364A8914B6FA548CF6DCEDDBD06@ChuckPC>
References: <20101216141518.879668720@sipsolutions.net>
	 <14A60364A8914B6FA548CF6DCEDDBD06@ChuckPC>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 15:40:43 +0100
Message-ID: <1292510443.3612.25.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chuck,

Allow me to respond on the list, this might be useful for more people.

On Thu, 2010-12-16 at 09:33 -0500, Chuck Crisler wrote:
> Johannes, I missed the discussion about this new capability. Would you 
> either give me a pointer to a doc or send me something that would allow me 
> to better understand what this is intended for? We are currently beginning a 
> re-design of our system and this might be very useful to us. At the least I 
> need to understand what it means.

I haven't really discussed this new functionality with anyone yet. So
you didn't really miss any discussion -- there was none. I just posted
the patchset out of the blue after having tried various approaches to
implementing P2P with Intel hardware.

The problem, it turns out, is that the device will refuse to receive
probe request frames unless put into a "P2P mode". Additionally, the
device implements (periodic) off-channel times for this.

Initially, I tried more involved approaches where we offload the entire
"P2P search" functionality to the device/driver. It turns out, however,
that this requires massive changes in wpa_supplicant, and after poring
over it for a couple of weeks I've come to the conclusion that I can't
make those changes in the short to medium term.

Instead, therefore, I've come up with this approach. When the supplicant
requests an off-channel period for P2P, I will hand it off to the driver
(patch 1). And when it requests an off-channel TX, I'll synthesise that
in mac80211 using the offload (patch 2) -- this I will also need to
extend later.

That's about it. Does that answer your question?

johannes

