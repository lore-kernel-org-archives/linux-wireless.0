Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53864 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1173836AbdDXSwj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Apr 2017 14:52:39 -0400
Message-ID: <1493059948.31741.161.camel@coelho.fi> (sfid-20170424_205305_174345_5CC14261)
From: Luca Coelho <luca@coelho.fi>
To: Andi Kleen <andi@firstfloor.org>
Cc: linuxwifi@intel.com, linux-wireless@vger.kernel.org
Date: Mon, 24 Apr 2017 21:52:28 +0300
In-Reply-To: <20170424124017.GL22592@two.firstfloor.org>
References: <20170424005400.GK22592@two.firstfloor.org>
         <1493016631.31741.139.camel@coelho.fi>
         <20170424124017.GL22592@two.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: 4.11-rc* iwlwifi instable
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-04-24 at 05:40 -0700, Andi Kleen wrote:
> > > Any fixes/workarounds?
> > 
> > It seems that you are using an old firmware version:
> > 
> > > [70585.074356] iwlwifi 0000:03:00.0: Loaded firmware version: 21.302800.0
> > 
> > We have already published version -27 for 4.11 and you're still using
> > version -21.  You can get the latest version from here:
> 
> Ok if the old firmware is not supported anymore how about a warning
> or an error? 

It is expected to work with -21.  If it really doesn't work with it
anymore, but works with the newer ones, I'll bump the minimum supported
version so we'll print an error and bail out.


> > https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/iwlwifi-7265D-27.ucode
> > 
> > We have loads of fixes and improvements in this new version.  And
> > hopefully it will make your problems go away. ;)
> > 
> > Please try it and let me know how it goes.
> 
> This is -27, but the driver looks for -28
> 
> [12382.760671] iwlwifi 0000:03:00.0: Direct firmware load for
> iwlwifi-7265D-28.ucode failed with error -2
> 
> Where is version -28?

TL;DR: this error message is harmless and the driver tries to load -27
if -28 is not available.

Long story: We upstream driver patches from our internal tree constantly
and, at that point, we don't know which FW version will pass all the
quality gates to be released officially.  The driver in 4.11 supports up
to version -28.  We haven't release -28 yet, though (and maybe won't),
so you get this error message when we try to load it.  But if it fails
to load, we try to load the one immediately below it and so on, until we
reach the minimum API version we support.

These errors are definitely annoying and confusing, but I don't know how
to work around them.  Luckily Luis is working on the firmware class[1]
and part of his work will make these messages go away.

Hope this helps.  And please let me know if iwlwifi-7265D-27.ucode works
for you.

[1] https://lkml.org/lkml/2017/3/29/1004


--
Cheers,
Luca.
