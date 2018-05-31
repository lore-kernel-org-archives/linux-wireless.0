Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47222 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754093AbeEaJRu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 May 2018 05:17:50 -0400
Message-ID: <3a75df90e3c235c40b353ad5b3edabbd338ad864.camel@coelho.fi> (sfid-20180531_111755_046547_547A66D4)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Alexander Wetzel <alexander.wetzel@web.de>,
        linux-wireless@vger.kernel.org,
        Golan Ben Ami <golan.ben.ami@intel.com>
Date: Thu, 31 May 2018 12:17:46 +0300
In-Reply-To: <87k1rk1af5.fsf@kamboji.qca.qualcomm.com>
References: <20180422082745.9743-1-luca@coelho.fi>
         <20180422082745.9743-2-luca@coelho.fi>
         <8ac31eb3-17cd-c4ee-fdf6-49aea171a667@web.de>
         <3a0d36e025325f873f6db2651c6d576b3b14c36d.camel@coelho.fi>
         <87k1rk1af5.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: iwlwifi: regression due to: allow different csr flags for
 different device families
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-05-31 at 11:44 +0300, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > On Sun, 2018-05-27 at 14:08 +0200, Alexander Wetzel wrote:
> > > > From: Golan Ben Ami <golan.ben.ami@intel.com>
> > > > 
> > > > Different device families may have different flag values
> > > > for passing a message to the fw (i.e. SW_RESET).
> > > > In order to keep the code readable, and avoid conditioning
> > > > upon the family, store a value for each flag, which indicates
> > > > the bit that needs to be enabled.
> > > > 
> > > > Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
> > > > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> > > 
> > > This patch generates a Null pointer exception for my Ultimate-N
> > > 6300
> > > card when loading the driver, making the card unusable.
> > > (Bisecting linked it to commit
> > > a8cbb46f831d2c101feccdd0e0daf3627b8c1dca.)
> > > 
> > > Sine the commit could not be simply reverted I applied this
> > > commit to
> > > my
> > > distribution kernel - basically 4.16.12 - and can confirm it is
> > > indeed
> > > causing the issue.
> > 
> > It seems that I forgot to reply to this, even though we looked into
> > it
> > and provided a fix[1].  This fix will hopefully be included in 4.17
> > final.
> > 
> > Thanks a lot for reporting and bisecting!
> > 
> > [1] https://patchwork.kernel.org/patch/10437773/
> 
> Something is not right, commit 0513c083d1f4 is in wireless-drivers-
> next
> so it will be in 4.18. Are we mixing commits or releases or did I
> pull
> it to wrong tree?
> 
> 0513c083d1f4 iwlwifi: add csr configuration for 6300 devices

No, you are right, it was my mistake (I mixed this up with the 16 CPUs
which you picked up for 4.17).  The fix for this regression should go
only to 4.18, since the original patch is not even in 4.17-rc*.

Sorry for the confusion.

So, rephrasing my buggy phrase from the previous email:

"This fix will hopefully be included in 4.18-rc1 and probably earlier
in wireless-testing".

--
Cheers,
Luca.
