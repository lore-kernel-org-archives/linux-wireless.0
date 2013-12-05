Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:49993 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943Ab3LESaj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 13:30:39 -0500
Received: by mail-ie0-f176.google.com with SMTP id at1so29666380iec.21
        for <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 10:30:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52A09324.6050706@rempel-privat.de>
References: <CANq1E4Td-uDE7fR-5PkJEBZkMRQODs+i-jgytt4O2YewxT9yrA@mail.gmail.com>
	<52A09324.6050706@rempel-privat.de>
Date: Thu, 5 Dec 2013 19:30:38 +0100
Message-ID: <CANq1E4SUYppAB8fAOAvuva4npQ4PA8ngAJesMsDb6LGLeVn-3A@mail.gmail.com> (sfid-20131205_193042_909118_98BC4911)
Subject: Re: [BUG] Atheros AR9280: NULL-deref during P2P setup
From: David Herrmann <dh.herrmann@gmail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Thu, Dec 5, 2013 at 3:52 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Hi David,
>
> currently i work on other ath9k_htc related issue. If you or some body
> else can work on this one it will be great.

It's weird, now I cannot reproduce the issue. I am actually trying to
make my Nexus-4 and my linux host connect via wifi-p2p. If I initiate
the connection via standard Android Wifi-Direct menu, it all works.
However, doing that via the Wifi-Display menu hasn't worked, yet. I
correctly set the WFD IE subelements and can see the device, but
initiating the connection from the Android device just sends an
P2P_INVITATION. If I follow up via P2P_CONNECT, nothing happens. Just
nothing..

All I get is this:
<3>P2P-DEVICE-FOUND 12:68:3f:4e:39:f2 p2p_dev_addr=12:68:3f:4e:39:f2
pri_dev_type=10-0050F204-5 name='dvdhrm-nx' config_methods=0x188
dev_capab=0x25 group_capab=0x0
<3>P2P-INVITATION-RECEIVED sa=12:68:3f:4e:39:f2
go_dev_addr=12:68:3f:4e:39:f2 bssid=12:68:3f:4e:b9:f2 unknown-network

I tried all available pin-methods.. I will check the wpa_supplicant
log later, but it's usually overly verbose that I cannot find anything
useful in it.

Note that after the android device timed-out, it gets the incoming
p2p-connection from my linux host. But it gets it as standard
P2P-connection, not as WFD connection. So somehow it ignores all
incoming requests.

Weird thing is, earlier today I got a P2P-PROV-DISC-REQ instead of the
P2P-INVITATION-RECEIVED. cannot figure out why.. same kernel, same
config. Tried it like 20 times each..

Any hints welcome! Especially if someone knows more about Android wifi
debugging.

Thanks
David
