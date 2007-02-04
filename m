Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:42261 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbXBDSOJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Feb 2007 13:14:09 -0500
Date: Sun, 4 Feb 2007 10:07:24 -0800
From: Jouni Malinen <jkmaline@cc.hut.fi>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: SoftMAC vs FullMAC
Message-ID: <20070204180724.GB6632@jm.kir.nu>
References: <9e4733910702040922n63736d27h7ab027dc90ae8989@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9e4733910702040922n63736d27h7ab027dc90ae8989@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 04, 2007 at 12:22:15PM -0500, Jon Smirl wrote:
> Has it been considered to simply treat all wireless hardware as
> SoftMAC and to just ignore the FullMAC capabilities?

There are number of FullMAC designs that do not allow management
functionality to be moved to the host, so this consideration is not
going to go very far unless one were to drop support for all the FullMAC
designs that do not allow this..

> Dscape looks to have already started down this path with
> implementations for five vendors. Is the plan to do this for all
> vendors, including Intel and Atheros?

Atheros (well, assuming you don't mean the USB design here) does not
even use firmware, so it is not FullMAC card in any way.. There is
already work on supporting Intel ipw3945 with d80211. Other Intel
designs (ipw2100, ipw2200, ipw2915) are currently using more FullMAC
type design, but that depends on the firmware implementation.. I don't
know what the hardware would be capable of doing, but in theory, it
might be possible (for the vendor) to produce a firmware version that
could work soft MAC designs.

> My specific need is that I am working on an embedded design that
> really needs 802.11s, but 11s isn't available yet. I don't want to end
> up locked into a hardware vendor's FullMAC implementation with much
> more expensive hardware. Currently hardware can run 11s if there is a
> host implementation in software.

I hope you realize that 802.11s is in very early steps (the first draft
failed to get the needed approval rate in IEEE 802.11 working group) and
is subject to change.. Whether hardware can run 802.11s (the current
draft or whatever may end up in the end) is quite open question from my
view point.. 802.11 requires MAC changes and I'm sure there are hardware
designs that do not work with the current 802.11s draft no matter what
the host CPU is doing in the driver/802.11 stack.

-- 
Jouni Malinen                                            PGP id EFC895FA
