Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32862 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab0G0RUX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 13:20:23 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 10:20:23 -0700
Date: Tue, 27 Jul 2010 10:20:20 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Simsek, Burak" <burak.simsek@fokus.fraunhofer.de>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH 4/5] mac80211: add WoW support
Message-ID: <20100727172020.GE8293@tux>
References: <804B13F8F3D94A4AB18B9B01ACB68FA1037B5158@EXCHSRV.fokus.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <804B13F8F3D94A4AB18B9B01ACB68FA1037B5158@EXCHSRV.fokus.fraunhofer.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 27, 2010 at 08:12:10AM -0700, Simsek, Burak wrote:
> Dear Luis,
>
> I have found out that you have worked on WoW for ath9k for a while. However,
> in the wiki page of wireless.kernel.org the current state is written as
> ongoing work. Can you please tell me whether you were successful while
> implementing WoW. Is there anything that we could use?

WoW worked for me but inconsistantly and at the time of writing
the patches I had to do quite a lot of coordination with Johannes
since he had a lot of API changes and his changes needed to get
merged first.

I also found quite a few issues in mac80211 back then but I believe
we have resolved all of them by now so I would expect that if the
same WoW-only patches to be rebased and tested we may get better
results.

I stopped working on the WoW stuff due to lack of time to keep
testing them but the last series can be edited to remove all
of the already merged stuff and test out the new stuff. The more
challenging thing for me was to actually get a WoW enabled
802.11 card, these are not as popular as you would hope. The
EEPROM would be modified when WoW is enabled but WoW requires
some actual hardware mucking to allow for the PCI Wake signal
which is typically blocked off. If the EEPROM has WoW enabled
then the hardware mucking would have been done.

To test WoW you also need to drop Network Manager and use
the supplicant directly so that during suspend you remain
associated. I should note that WoW will only work on
non-WPA networks with ath9k due to the lack of
hardware CPU, during suspend there is only power for the
802.11 hardware, the CPU on your box would be asleep but
would be required for group key changes. The way I was thinking
of doing this was to only enable WoW through cfg80211 for ath9k if
and only if you are associated and you are connected to a non
WPA network.

WoW would work with encryption on our USB devices where
there is a CPU though.

You can find my last series here:

http://www.mk.kernel.org/pub/linux/kernel/people/mcgrof/patches/wow-07-21.patch
http://www.mk.kernel.org/pub/linux/kernel/people/mcgrof/patches/iw-add-wow.patch

If you manage to do what I noted above, get an actual WoW enabled card,
and it works reliably I'd gladly welcome and ACK the patches :)

  Luis
