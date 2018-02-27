Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46815 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750997AbeB0Qyw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 11:54:52 -0500
Date: Tue, 27 Feb 2018 16:54:51 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: cantabile <cantabile.desu@gmail.com>
Cc: Jakub Kicinski <kubakici@wp.pl>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt7601u: Fix system freeze after resuming from
 hibernation
Message-ID: <20180227165451.GS14069@wotan.suse.de> (sfid-20180227_175456_938765_098CCC28)
References: <d9ca2742-7f85-afe3-2de6-6637eb56d9b3@gmail.com>
 <20180214164549.72ee26c3@cakuba.netronome.com>
 <f542e9c6-5106-c79c-6e38-7a2f50e6be2d@gmail.com>
 <20180215134738.722654a9@cakuba.netronome.com>
 <7cebda93-4b7a-e8b3-271f-0144c5e94248@gmail.com>
 <20180218215520.65c1e9fd@cakuba.netronome.com>
 <6783d9b9-3523-761f-a8b4-b87732006b3c@gmail.com>
 <20180225175425.GL14069@wotan.suse.de>
 <20180226182859.03184215@cakuba.netronome.com>
 <3382fa4d-c652-68eb-13c3-12dc84ba0dd5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3382fa4d-c652-68eb-13c3-12dc84ba0dd5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 27, 2018 at 02:25:55PM +0200, cantabile wrote:
> On 27/02/18 04:28, Jakub Kicinski wrote:
> > On Sun, 25 Feb 2018 17:54:25 +0000, Luis R. Rodriguez wrote:
> 
> > > I want to understand the case where the firmware is *not* available on resume?
> > > Why did that happen? I seem to have read that on a fresh reboot the firmware
> > > was not needed, and so on probe request_firmware() was not called? Why would
> > > firmware not be required on a reboot?
> > 
> > Yes, that is a good question..  John, do you have a theory?  My initial
> > thought was that the UEFI/BIOS loads it during pre-boot, but this is a
> > USB card, so it's a bit unlikely that UEFI will have a driver for it...
> > Does this happen when rebooting maybe?
> > 
> 
> Yes, it happens when rebooting:
> 1) Plug in the dongle. Message about firmware appears in dmesg:
> 
> mt7601u 2-3:1.0: ASIC revision: 76010001 MAC revision: 76010500
> mt7601u 2-3:1.0: Firmware Version: 0.1.00 Build: 7640 Build time:
> 201302052146____
> mt7601u 2-3:1.0: Warning: unsupported EEPROM version 0d
> 
> 2) `systemctl reboot`. Message about firmware does not appear in dmesg:
> 
> mt7601u 2-3:1.0: ASIC revision: 76010001 MAC revision: 76010500
> mt7601u 2-3:1.0: Warning: unsupported EEPROM version 0d
> 
> The dongle is nevertheless perfectly functional after rebooting.
> 
> I have no idea why it works like this.
> 
> This is an older laptop, no UEFI.

OK, this just confirms that firmware is not needed on reboot sometimes,
but it does not explain *why*. What driver and code lines are involved
so I can go read? Is the vendor involved or not really?

I could imagine a situation where on reboot we just reset a device but
since poweroff is never fully issued the firmware is not lost. So let me
ask, why not do a full reset / shutdown of the device when the interface
goes down?

If there is no gain from the behaviour observed, might as well make
the device work as much others rather than adding an API for a one-off
situation where there is no gain from it behaving in a unique way.

  Luis
