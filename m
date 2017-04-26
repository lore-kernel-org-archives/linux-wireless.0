Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54454 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1947337AbdDZGSt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 02:18:49 -0400
Message-ID: <1493187510.31741.195.camel@coelho.fi> (sfid-20170426_082020_175095_49D9F2CA)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Andi Kleen <andi@firstfloor.org>, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org
Date: Wed, 26 Apr 2017 09:18:30 +0300
In-Reply-To: <87zif3aed3.fsf@purkki.adurom.net>
References: <20170424005400.GK22592@two.firstfloor.org>
         <1493016631.31741.139.camel@coelho.fi>
         <20170424124017.GL22592@two.firstfloor.org>
         <1493059948.31741.161.camel@coelho.fi> <87zif3aed3.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: 4.11-rc* iwlwifi instable
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-04-26 at 09:10 +0300, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/iwlwifi-7265D-27.ucode
> > > > 
> > > > We have loads of fixes and improvements in this new version.  And
> > > > hopefully it will make your problems go away. ;)
> > > > 
> > > > Please try it and let me know how it goes.
> > > 
> > > This is -27, but the driver looks for -28
> > > 
> > > [12382.760671] iwlwifi 0000:03:00.0: Direct firmware load for
> > > iwlwifi-7265D-28.ucode failed with error -2
> > > 
> > > Where is version -28?
> > 
> > TL;DR: this error message is harmless and the driver tries to load -27
> > if -28 is not available.
> > 
> > Long story: We upstream driver patches from our internal tree constantly
> > and, at that point, we don't know which FW version will pass all the
> > quality gates to be released officially.  The driver in 4.11 supports up
> > to version -28.  We haven't release -28 yet, though (and maybe won't),
> > so you get this error message when we try to load it.  But if it fails
> > to load, we try to load the one immediately below it and so on, until we
> > reach the minimum API version we support.
> > 
> > These errors are definitely annoying and confusing, but I don't know how
> > to work around them.  Luckily Luis is working on the firmware class[1]
> > and part of his work will make these messages go away.
> 
> FWIW, we got frustrated with the same problem in ath10k and switched to
> request_firmware_direct() to get rid of the warning:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9f5bcfe93315d75da4cc46bd30b536966559359a

Thanks for pointing this out! I hope Luis' series goes in at some point
soon so we can use the new fallback function and get rid of this logic
in the driver.

--
Cheers,
Luca.
