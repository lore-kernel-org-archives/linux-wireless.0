Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36532 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751837AbeBYRy1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Feb 2018 12:54:27 -0500
Date: Sun, 25 Feb 2018 17:54:25 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: cantabile <cantabile.desu@gmail.com>
Cc: Jakub Kicinski <kubakici@wp.pl>, mcgrof@kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt7601u: Fix system freeze after resuming from
 hibernation
Message-ID: <20180225175425.GL14069@wotan.suse.de> (sfid-20180225_185431_606436_CD485A47)
References: <d9ca2742-7f85-afe3-2de6-6637eb56d9b3@gmail.com>
 <20180214164549.72ee26c3@cakuba.netronome.com>
 <f542e9c6-5106-c79c-6e38-7a2f50e6be2d@gmail.com>
 <20180215134738.722654a9@cakuba.netronome.com>
 <7cebda93-4b7a-e8b3-271f-0144c5e94248@gmail.com>
 <20180218215520.65c1e9fd@cakuba.netronome.com>
 <6783d9b9-3523-761f-a8b4-b87732006b3c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6783d9b9-3523-761f-a8b4-b87732006b3c@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 19, 2018 at 05:01:27PM +0200, cantabile wrote:
> On 19/02/18 07:55, Jakub Kicinski wrote:
> > On Sat, 17 Feb 2018 13:23:29 +0200, cantabile wrote:
> > > > Thanks for the info.  Would it be cleaner to EXPORT fw_add_devm_name()
> > > > and just call that in case driver sees FW is already loaded?  That
> > > > should inform the fw subsystem that we want the image around in case of
> > > > hibernation, but there is no need to load it immediately?
> > > 
> > > No, I don't believe it's cleaner to expose a private function that you
> > > don't even really need. Remember that calling request_firmware every
> > > time your driver's probe and resume functions are called is normal. It's
> > > the expected behaviour.
> > 
> > I'm asking you the extend functionality of a subsystem to be able to
> > cleanly communicate the intent.  Not export internal functions.
> > 
> > Requesting firmware you don't need and risking failing probe even if FW
> > is already pre-loaded is not correct.  Reordering you suggest is
> > brittle and makes little logical sense unless someone guesses your use
> > case.
> > 
> > Please at least try to do as advised.  Otherwise:
> > 
> > Nacked-by: Jakub Kicinski <kubakici@wp.pl>
> > 
> 
> You're right about the reordering not making sense to someone unfamiliar
> with the problem. I can fix that with a comment.
> 
> I can change the patch so that request_firmware will only make the probe
> function fail if the firmware is not already running.

Note that using request_firmware() on probe typically is also not an
outstanding idea given it delays boot. Not because looking for the firmware
takes time, but instead because processing firmware typically does on
the device. For instance cxgb4 is an example device where processing
firmware takes a long time.

Delays on probe may mean the "feel good" immediate desktop coming up is delyed.

Specially if its networking... I see no reason why to process firmware on probe.

If one can use a workqueue to process verifying if it needs firmware and loading
later, that's more advisable.

Now, that's all a side topic.

I will for now agree that it seems pointless to request for firmware always
even if you don't need to, and all you want is to just cache the firmware
on suspend. So I welcome a patch but the justification for it really needs to
be documented very well, and the documentation extended as such. In fact
maybe rename the function to something more sensible.

Another use case for the firmware cache (which we need to add the documentation)
is that for hibernation we suspend all devices first, get a snapshot, and then
resume devices so we can then write the snapshot to disk. On that resume step
I don't think devices have access to the hard drive for firmware, so cache is
all we have. This may need some confirmation but I suspect this is the case.
Drivers needing firmware on resume for hibernation may need to cache their
firmware.

I want to understand the case where the firmware is *not* available on resume?
Why did that happen? I seem to have read that on a fresh reboot the firmware
was not needed, and so on probe request_firmware() was not called? Why would
firmware not be required on a reboot?

 Luis
