Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:34816 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756144AbdERQaS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 12:30:18 -0400
Received: by mail-it0-f48.google.com with SMTP id c15so103480829ith.0
        for <linux-wireless@vger.kernel.org>; Thu, 18 May 2017 09:30:17 -0700 (PDT)
Date: Thu, 18 May 2017 09:30:08 -0700
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rajat Jain <rajatja@google.com>
Subject: Re: [4/4] mwifiex: pcie: de-duplicate buffer allocation code
Message-ID: <20170518163007.GA117009@google.com> (sfid-20170518_183141_781844_DAD9071E)
References: <20170311013924.73348-5-briannorris@chromium.org>
 <20170518133348.6C5C660F63@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170518133348.6C5C660F63@smtp.codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 18, 2017 at 01:33:48PM +0000, Kalle Valo wrote:
> Brian Norris <briannorris@chromium.org> wrote:
> > This code was duplicated as part of the PCIe FLR code added to this
> > driver. Let's de-duplicate it to:
> > 
> >  * make things easier to read (mwifiex_pcie_free_buffers() now has a
> >    corresponding mwifiex_pcie_alloc_buffers())
> >  * reduce likelihood of bugs
> >  * make error logging equally verbose
> >  * save lines of code!
> > 
> > Also drop some of the commentary that isn't really needed.
> > 
> > Signed-off-by: Brian Norris <briannorris@chromium.org>
> 
> Failed to apply:
> 
> fatal: sha1 information is lacking or useless (drivers/net/wireless/marvell/mwifiex/pcie.c).
> error: could not build fake ancestor
> Applying: mwifiex: pcie: de-duplicate buffer allocation code
> Patch failed at 0001 mwifiex: pcie: de-duplicate buffer allocation code
> The copy of the patch that failed is found in: .git/rebase-apply/patch

Hmm, well it still applies for me, but it does require a 3-way merge...
and I guess I have local history (because the 3 previous patches *used*
to be together...):

$ pwclient git-am -p linux-wireless 9618309
Applying patch #9618309 using u'git am'
Description: [4/4] mwifiex: pcie: de-duplicate buffer allocation code
Applying: mwifiex: pcie: de-duplicate buffer allocation code
Using index info to reconstruct a base tree...
M	drivers/net/wireless/marvell/mwifiex/pcie.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/marvell/mwifiex/pcie.c

Anyway, I'll resend.

Brian

> Patch set to Changes Requested.


> https://patchwork.kernel.org/patch/9618309/
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
> 
