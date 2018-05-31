Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47166 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753740AbeEaGax (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 May 2018 02:30:53 -0400
Message-ID: <3a0d36e025325f873f6db2651c6d576b3b14c36d.camel@coelho.fi> (sfid-20180531_083057_727839_0024DEF0)
From: Luca Coelho <luca@coelho.fi>
To: Alexander Wetzel <alexander.wetzel@web.de>, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Golan Ben Ami <golan.ben.ami@intel.com>
Date: Thu, 31 May 2018 09:30:48 +0300
In-Reply-To: <8ac31eb3-17cd-c4ee-fdf6-49aea171a667@web.de>
References: <20180422082745.9743-1-luca@coelho.fi>
         <20180422082745.9743-2-luca@coelho.fi>
         <8ac31eb3-17cd-c4ee-fdf6-49aea171a667@web.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: iwlwifi: regression due to: allow different csr flags for
 different device families
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2018-05-27 at 14:08 +0200, Alexander Wetzel wrote:
> > From: Golan Ben Ami <golan.ben.ami@intel.com>
> > 
> > Different device families may have different flag values
> > for passing a message to the fw (i.e. SW_RESET).
> > In order to keep the code readable, and avoid conditioning
> > upon the family, store a value for each flag, which indicates
> > the bit that needs to be enabled.
> > 
> > Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> 
> This patch generates a Null pointer exception for my Ultimate-N 6300
> card when loading the driver, making the card unusable.
> (Bisecting linked it to commit
> a8cbb46f831d2c101feccdd0e0daf3627b8c1dca.)
> 
> Sine the commit could not be simply reverted I applied this commit to
> my
> distribution kernel - basically 4.16.12 - and can confirm it is
> indeed
> causing the issue.

It seems that I forgot to reply to this, even though we looked into it
and provided a fix[1].  This fix will hopefully be included in 4.17
final.

Thanks a lot for reporting and bisecting!

[1] https://patchwork.kernel.org/patch/10437773/

--
Cheers,
Luca.
