Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41536 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758159AbcLTT4d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Dec 2016 14:56:33 -0500
Date: Tue, 20 Dec 2016 12:56:21 -0700
From: Mark Greer <mgreer@animalcreek.com>
To: Justin Bronder <justin@kuvee.com>
Cc: Geoff Lansberry <geoff@kuvee.com>, linux-wireless@vger.kernel.org,
        lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
        sameo@linux.intel.com, robh+dt@kernel.org, mark.rutland@arm.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jaret Cantu <jaret.cantu@timesys.com>
Subject: Re: nfc: trf7970a: Prevent repeated polling from crashing the kernel
Message-ID: <20161220195621.GA6400@animalcreek.com> (sfid-20161220_205713_932337_AF1BE4C5)
References: <1482250592-4268-1-git-send-email-glansberry@gmail.com>
 <1482250592-4268-3-git-send-email-glansberry@gmail.com>
 <20161220185905.GA5867@animalcreek.com>
 <20161220191352.GB23496@lasswell.members.linode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161220191352.GB23496@lasswell.members.linode.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 20, 2016 at 02:13:52PM -0500, Justin Bronder wrote:
> On 20/12/16 11:59 -0700, Mark Greer wrote:
> > On Tue, Dec 20, 2016 at 11:16:32AM -0500, Geoff Lansberry wrote:
> > > From: Jaret Cantu <jaret.cantu@timesys.com>
> > > 
> > > Repeated polling attempts cause a NULL dereference error to occur.
> > > This is because the state of the trf7970a is currently reading but
> > > another request has been made to send a command before it has finished.
> > 
> > How is this happening?  Was trf7970a_abort_cmd() called and it didn't
> > work right?  Was it not called at all and there is a bug in the digital
> > layer?  More details please.
> > 
> > > The solution is to properly kill the waiting reading (workqueue)
> > > before failing on the send.
> > 
> > If the bug is in the calling code, then that is what should get fixed.
> > This seems to be a hack to work-around a digital layer bug.
> 
> One of our uses of NFC is to begin polling to read a tag and then stop polling
> (in order to save power) until we know via user interaction that we need to poll
> again.  This is typically many minutes later so the power saving is pretty
> significant.  However, it's possible that a user will remove the tag before
> reading has completed.  We also detect this case and stop polling.  I can go
> more into this if necessary but that is what exposed a panic.
> 
> You can reproduce using neard and python, in our testing it was very likely to
> occur in 10-100 iterations of the following.:
> 
>     #!/usr/bin/python
>     import time
> 
>     import dbus
> 
>     bus = dbus.SystemBus()
>     nfc0 = bus.get_object('org.neard', '/org/neard/nfc0')
>     props = dbus.Interface(nfc0, 'org.freedesktop.DBus.Properties')
> 
>     try:
>         props.Set('org.neard.Adapter', 'Powered', dbus.Boolean(1))
>     except:
>         pass
> 
>     adapter = dbus.Interface(nfc0, 'org.neard.Adapter')
> 
>     for i in range(1000):
>         adapter.StartPollLoop('Initiator')
>         time.sleep(0.1)
>         adapter.StopPollLoop()
>         print(i)
> 
> I believe the last time we tested this was around the 4.1 release.

Thanks for the info, Justin, but I was also seeking more information
at the kernel NFC subsystem and trf7970a driver level.  This patch
adds code inside an 'if' in the driver whose condition should never
be evaluate to true but apparently it did.  How?

Thanks,

Mark
--
