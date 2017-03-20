Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:33830 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756245AbdCTUFz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 16:05:55 -0400
Received: by mail-pg0-f41.google.com with SMTP id 21so49274408pgg.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Mar 2017 13:05:54 -0700 (PDT)
Date: Mon, 20 Mar 2017 13:05:51 -0700
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rajat Jain <rajatja@google.com>
Subject: Re: [4/4] mwifiex: pcie: de-duplicate buffer allocation code
Message-ID: <20170320200550.GA12143@google.com> (sfid-20170320_210648_422330_D5FAFE96)
References: <20170311013924.73348-5-briannorris@chromium.org>
 <20170320170835.5ED1C609C6@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170320170835.5ED1C609C6@smtp.codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Mon, Mar 20, 2017 at 05:08:35PM +0000, Kalle Valo wrote:
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
> 
> Patch set to Changes Requested.

This applies fine to your wireless-drivers/master branch for me, where
patches 1-3 were applied. Are you applying this to
wireless-drivers-next? It's quite understandable that patch 4 wouldn't
apply there, as you've stripped out the previous patches...

Brian
