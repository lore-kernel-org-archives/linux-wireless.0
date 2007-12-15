Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:53209 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbXLOBns (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2007 20:43:48 -0500
Date: Fri, 14 Dec 2007 17:42:44 -0800
From: Jouni Malinen <j@w1.fi>
To: Dan Williams <dcbw@redhat.com>
Cc: Masakazu Mokuno <mokuno@sm.sony.co.jp>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] PS3: gelic: Add wireless support for PS3
Message-ID: <20071215014244.GI5698@jm.kir.nu> (sfid-20071215_014354_626734_BE190CFE)
References: <20071213211626.BF8E.MOKUNO@sm.sony.co.jp> <1197580418.14270.6.camel@localhost.localdomain> <20071214134918.275E.MOKUNO@sm.sony.co.jp> <1197637127.16724.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1197637127.16724.1.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 14, 2007 at 07:58:47AM -0500, Dan Williams wrote:
> On Fri, 2007-12-14 at 14:03 +0900, Masakazu Mokuno wrote:
> > The PS3 wireless device does the association and 4way handshake in its
> > firmware/hypervisor.  No interventions between them are allowed to the guest
> > OSes.  

> That sort of sucks; but I guess there's not too much you can do about
> it.  That probably means that using wpa_supplicant + WPA is completely
> out of the picture, which unfortunately makes the PS3 wireless unlike
> any other card, which would require special-casing the PS3 in userspace
> tools.

The current wpa_supplicant development branch (0.6.x) supports drivers
that want to do 4-way handshake in the driver/firmware (e.g., OSX,
iPhone, this PS3 driver). In case of WPA-PSK, this doesn't really mean
more than just passing through the passphrase/PSK to the association
routine, but still, this allows the driver to be configured through
wpa_supplicant, if desired.

However, there is a part that you are not going to like.. This is likely
using a private ioctl for some parts of the association requests, i.e.,
no -Dwext.. I would assume that this could be cleaned up, though, if
WEXT would be extended a bit to allow one more enc_capa to notify
whether the driver wants to take care of 4-way handshake and to allow
the PSK to be configured with a new key type.


PS.

It would be interesting to see whether the driver/firmware/hypervisor
could be convinced to allow EAPOL frames to go through between
association and 4-way handshake (which would be completed by
driver/firmware). This is the way I can support WPA/WPA2-Enterprise with
OSX..

-- 
Jouni Malinen                                            PGP id EFC895FA
