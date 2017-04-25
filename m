Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53936 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1170758AbdDYHFh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 03:05:37 -0400
Message-ID: <1493103929.31741.173.camel@coelho.fi> (sfid-20170425_090728_662940_17828423)
From: Luca Coelho <luca@coelho.fi>
To: Andi Kleen <andi@firstfloor.org>
Cc: linuxwifi@intel.com, linux-wireless@vger.kernel.org
Date: Tue, 25 Apr 2017 10:05:29 +0300
In-Reply-To: <20170424190524.GP22592@two.firstfloor.org>
References: <20170424005400.GK22592@two.firstfloor.org>
         <1493016631.31741.139.camel@coelho.fi>
         <20170424124017.GL22592@two.firstfloor.org>
         <1493059948.31741.161.camel@coelho.fi>
         <20170424190524.GP22592@two.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: 4.11-rc* iwlwifi instable
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-04-24 at 12:05 -0700, Andi Kleen wrote:
> On Mon, Apr 24, 2017 at 09:52:28PM +0300, Luca Coelho wrote:
> > On Mon, 2017-04-24 at 05:40 -0700, Andi Kleen wrote:
> > > > > Any fixes/workarounds?
> > > > 
> > > > It seems that you are using an old firmware version:
> > > > 
> > > > > [70585.074356] iwlwifi 0000:03:00.0: Loaded firmware version: 21.302800.0
> > > > 
> > > > We have already published version -27 for 4.11 and you're still using
> > > > version -21.  You can get the latest version from here:
> > > 
> > > Ok if the old firmware is not supported anymore how about a warning
> > > or an error? 
> > 
> > It is expected to work with -21.  If it really doesn't work with it
> > anymore, but works with the newer ones, I'll bump the minimum supported
> > version so we'll print an error and bail out.
> 
> A warning may be better because it can be difficult to get a
> new firmware if the network is dead. Or perhaps error + override
> argument.

Hopefully you keep the previously working kernel around when you try a
new -rc. ;)


> Even the old firmware works at least for some time.

Now seriously, as I said before, -21 is expected to work, but we don't
really do much testing with older firmwares after we released new ones. 
We already have two newer versions in linux-firmware.git[1], -22 and
-27.

I have checked it a bit further and I see that we even stopped
supporting firmwares older than -22 [2] (since 4.9-rc1).  But it seems
that I made a mistake in that patch and use -17 for all NICs, while it
should have been -17 for older NICs and -22 for newer ones... I'll send
a patch to fix that.


> > Hope this helps.  And please let me know if iwlwifi-7265D-27.ucode works
> > for you.
> 
> So far it seems to work, and connects much faster than the old one.

That's good to hear! Please let us know if you find any issues with it.


[1] https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4b87e5af638b6056bd6c20b0954d09a5a58633be

--
Cheers,
Luca.
