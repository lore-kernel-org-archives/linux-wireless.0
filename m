Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:34800 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753214AbdDCSmM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 14:42:12 -0400
Received: by mail-pg0-f52.google.com with SMTP id 21so128663343pgg.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Apr 2017 11:42:11 -0700 (PDT)
Date: Mon, 3 Apr 2017 11:42:08 -0700
From: Brian Norris <briannorris@chromium.org>
To: Dmitry Torokhov <dtor@google.com>
Cc: Xinming Hu <huxinming820@gmail.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Rajat Jain <rajatja@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH 2/3] mwifiex: using general print function during device
 intialization
Message-ID: <20170403184208.GB116262@google.com> (sfid-20170403_204223_128651_D9F8E5A9)
References: <1490865547-10208-1-git-send-email-huxinming820@gmail.com>
 <1490865547-10208-2-git-send-email-huxinming820@gmail.com>
 <CAE_wzQ890=BCQviifEkcgfFO7XA+SNeFCUgn_Bx9_4n9uB1nsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAE_wzQ890=BCQviifEkcgfFO7XA+SNeFCUgn_Bx9_4n9uB1nsg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 31, 2017 at 03:46:58PM -0700, Dmitry Torokhov wrote:
> On Thu, Mar 30, 2017 at 2:19 AM, Xinming Hu <huxinming820@gmail.com> wrote:
> > From: Xinming Hu <huxm@marvell.com>
> >
> > adapter->dev is initialized after mwifiex_register done, before that
> > print message by general pr_* function
> 
> No, we should move away from naked pr_*() as much as possible. Please
> change  mwifiex_register() to accept "dev" parameter and assign
> adapter->dev early enough so that the standard mwifiex_err() calls are
> usable.

Agreed. You mean like I did here? :)

ba1c7e45ec22 mwifiex: set adapter->dev before starting to use mwifiex_dbg()

That's in v4.11-rc4, partly as a bugfix to this:

2e02b5814217 ("mwifiex: Allow mwifiex early access to device structure")

> Also consider changing _mwifiex_dbg() to handle cases when
> adapter->dev is NULL and fall back to pr_<level>.

That'd be nice. It would have mitigated the problems of commit
2e02b5814217 too.

Brian

> > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > ---
> >  drivers/net/wireless/marvell/mwifiex/pcie.c | 78 ++++++++++++-----------------
> >  drivers/net/wireless/marvell/mwifiex/sdio.c |  3 +-
> >  2 files changed, 34 insertions(+), 47 deletions(-)

[...]
