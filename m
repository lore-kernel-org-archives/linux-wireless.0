Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f180.google.com ([209.85.213.180]:34619 "EHLO
        mail-yb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938712AbcLTTNy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Dec 2016 14:13:54 -0500
Received: by mail-yb0-f180.google.com with SMTP id d59so68586403ybi.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2016 11:13:53 -0800 (PST)
Date: Tue, 20 Dec 2016 14:13:52 -0500
From: Justin Bronder <justin@kuvee.com>
To: Mark Greer <mgreer@animalcreek.com>
Cc: Geoff Lansberry <geoff@kuvee.com>, linux-wireless@vger.kernel.org,
        lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
        sameo@linux.intel.com, robh+dt@kernel.org, mark.rutland@arm.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jaret Cantu <jaret.cantu@timesys.com>
Subject: Re: nfc: trf7970a: Prevent repeated polling from crashing the kernel
Message-ID: <20161220191352.GB23496@lasswell.members.linode.com> (sfid-20161220_201447_878024_B15EAB48)
References: <1482250592-4268-1-git-send-email-glansberry@gmail.com>
 <1482250592-4268-3-git-send-email-glansberry@gmail.com>
 <20161220185905.GA5867@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161220185905.GA5867@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20/12/16 11:59 -0700, Mark Greer wrote:
> On Tue, Dec 20, 2016 at 11:16:32AM -0500, Geoff Lansberry wrote:
> > From: Jaret Cantu <jaret.cantu@timesys.com>
> > 
> > Repeated polling attempts cause a NULL dereference error to occur.
> > This is because the state of the trf7970a is currently reading but
> > another request has been made to send a command before it has finished.
> 
> How is this happening?  Was trf7970a_abort_cmd() called and it didn't
> work right?  Was it not called at all and there is a bug in the digital
> layer?  More details please.
> 
> > The solution is to properly kill the waiting reading (workqueue)
> > before failing on the send.
> 
> If the bug is in the calling code, then that is what should get fixed.
> This seems to be a hack to work-around a digital layer bug.

One of our uses of NFC is to begin polling to read a tag and then stop polling
(in order to save power) until we know via user interaction that we need to poll
again.  This is typically many minutes later so the power saving is pretty
significant.  However, it's possible that a user will remove the tag before
reading has completed.  We also detect this case and stop polling.  I can go
more into this if necessary but that is what exposed a panic.

You can reproduce using neard and python, in our testing it was very likely to
occur in 10-100 iterations of the following.:

    #!/usr/bin/python
    import time

    import dbus

    bus = dbus.SystemBus()
    nfc0 = bus.get_object('org.neard', '/org/neard/nfc0')
    props = dbus.Interface(nfc0, 'org.freedesktop.DBus.Properties')

    try:
        props.Set('org.neard.Adapter', 'Powered', dbus.Boolean(1))
    except:
        pass

    adapter = dbus.Interface(nfc0, 'org.neard.Adapter')

    for i in range(1000):
        adapter.StartPollLoop('Initiator')
        time.sleep(0.1)
        adapter.StopPollLoop()
        print(i)

I believe the last time we tested this was around the 4.1 release.

-- 
Justin Bronder
