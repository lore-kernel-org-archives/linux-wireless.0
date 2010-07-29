Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40988 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352Ab0G2PbV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 11:31:21 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 29 Jul 2010 08:31:21 -0700
Date: Thu, 29 Jul 2010 08:31:17 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Simsek, Burak" <burak.simsek@fokus.fraunhofer.de>,
	David Quan <David.Quan@atheros.com>,
	Amod Bodas <Amod.Bodas@atheros.com>,
	Stephen Chen <Stephen.Chen@atheros.com>,
	Christian Lamparter <chunkeey@googlemail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH 4/5] mac80211: add WoW support
Message-ID: <20100729153117.GB4925@tux>
References: <804B13F8F3D94A4AB18B9B01ACB68FA1037B5158@EXCHSRV.fokus.fraunhofer.de>
 <20100727172020.GE8293@tux>
 <804B13F8F3D94A4AB18B9B01ACB68FA1037B526B@EXCHSRV.fokus.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <804B13F8F3D94A4AB18B9B01ACB68FA1037B526B@EXCHSRV.fokus.fraunhofer.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 29, 2010 at 06:31:02AM -0700, Simsek, Burak wrote:
> Hi Luis,
> 
> we tried your patches on the old version as described in your patch file. 
> 
> As you wrote the first issue was about the getting the right hardware. We
> first wanted to use RS71-USB from ubiquity and it has AR9280. However, we
> then realized that the implementation was for pci. We had assumed that RS71
> would use ath9k but it used AR9170 driver. First question: do you think that
> we can do similar patch for usb without much effort?

Well, ar9170 uses Atheros radios but uses an old Zydas MAC so the programming
would be different and I am not sure if ar9170 ever supported WoW. Stephen
and Christian would know best at this point, whom I have CC'd.

> Then we tried it with DWA-547 from DLink (phy0: Atheros AR9280 MAC/BB Rev:2
> AR5133 RF Rev:d0: mem=0xf8720000, irq=16), which also has AR9280. This is
> the output we got:
> [    9.411217] ath9k: WoW capabler device: yes

Neat.

> [    9.411226] ath9k: EEPROM indicates WoW hw changes in place: no

Without this you won't get anywhere IIRC. This indicates that the card
was actually modified to enable the PCIE WAKE signal, by default all
Atheros devices have this wedged off.

> [    9.411234] ath9k: WoW exact match pattern support: no
> [    9.411241] ath9k: WoW match pattern first dword requirement: no
> 
> Now, regarding those EEPROM problems we will have difficulties. Were you
> able to get it running with a specific device? Can you recommend us
> something? 

Well I can see if we can get docs out to let developers enable WoW on
their own. This may take me some time to get and release.

I should note enabling WoW requires some hw mods and then an EEPROM change.
We cannot support allowing users to mod their EEPROMs at this point
but if you do mod the hardware it would be simple enough to just modify
the patch to not check for the EEPROM to enable WoW, as a starter.

Your other best bet is to purchase a laptop that has WoW enabled but
I unfortunately do not have a list of laptops/devices that have this
enabled.

> Our next step will be carrying the patch to the last version. Is there any
> kind of documentation which could help us dealing with EEPROM issues? 

The EEPROM will be informative for the patch, that's all, now you can
at least tell which cards have been moded or not, so now you just have
to either get a WoW card or mode your card for it. If you mod it yourself
you can then just disable the EEPROM check for testsing purposes (ie, patch
won't be accepted upstream without the EEPROM check, but you can keep
whatever you want on your end).

  Luis
> 
> Best regards
> 
> Burak Simsek
> 
> 
> 
> 
> 
> -----Original Message-----
> From: Luis R. Rodriguez [mailto:lrodriguez@atheros.com] 
> Sent: Dienstag, 27. Juli 2010 19:20
> To: Simsek, Burak
> Cc: Luis Rodriguez; linux-wireless@vger.kernel.org
> Subject: Re: [ath9k-devel] [PATCH 4/5] mac80211: add WoW support
> 
> On Tue, Jul 27, 2010 at 08:12:10AM -0700, Simsek, Burak wrote:
> > Dear Luis,
> >
> > I have found out that you have worked on WoW for ath9k for a while.
> However,
> > in the wiki page of wireless.kernel.org the current state is written as
> > ongoing work. Can you please tell me whether you were successful while
> > implementing WoW. Is there anything that we could use?
> 
> WoW worked for me but inconsistantly and at the time of writing
> the patches I had to do quite a lot of coordination with Johannes
> since he had a lot of API changes and his changes needed to get
> merged first.
> 
> I also found quite a few issues in mac80211 back then but I believe
> we have resolved all of them by now so I would expect that if the
> same WoW-only patches to be rebased and tested we may get better
> results.
> 
> I stopped working on the WoW stuff due to lack of time to keep
> testing them but the last series can be edited to remove all
> of the already merged stuff and test out the new stuff. The more
> challenging thing for me was to actually get a WoW enabled
> 802.11 card, these are not as popular as you would hope. The
> EEPROM would be modified when WoW is enabled but WoW requires
> some actual hardware mucking to allow for the PCI Wake signal
> which is typically blocked off. If the EEPROM has WoW enabled
> then the hardware mucking would have been done.
> 
> To test WoW you also need to drop Network Manager and use
> the supplicant directly so that during suspend you remain
> associated. I should note that WoW will only work on
> non-WPA networks with ath9k due to the lack of
> hardware CPU, during suspend there is only power for the
> 802.11 hardware, the CPU on your box would be asleep but
> would be required for group key changes. The way I was thinking
> of doing this was to only enable WoW through cfg80211 for ath9k if
> and only if you are associated and you are connected to a non
> WPA network.
> 
> WoW would work with encryption on our USB devices where
> there is a CPU though.
> 
> You can find my last series here:
> 
> http://www.mk.kernel.org/pub/linux/kernel/people/mcgrof/patches/wow-07-21.pa
> tch
> http://www.mk.kernel.org/pub/linux/kernel/people/mcgrof/patches/iw-add-wow.p
> atch
> 
> If you manage to do what I noted above, get an actual WoW enabled card,
> and it works reliably I'd gladly welcome and ACK the patches :)
> 
>   Luis


