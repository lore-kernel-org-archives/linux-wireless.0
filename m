Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:34031 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751663AbdCPSlV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 14:41:21 -0400
Received: by mail-pf0-f176.google.com with SMTP id p189so5094942pfp.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Mar 2017 11:41:20 -0700 (PDT)
Date: Thu, 16 Mar 2017 11:41:16 -0700
From: Brian Norris <briannorris@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com
Subject: Re: [PATCH v2] mwifiex: fix kernel crash after shutdown command
 timeout
Message-ID: <20170316184115.GA105900@google.com> (sfid-20170316_194136_090289_4A362246)
References: <1489660132-27352-1-git-send-email-akarwar@marvell.com>
 <20170316183317.GA2935@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170316183317.GA2935@dtor-ws>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,

On Thu, Mar 16, 2017 at 11:33:17AM -0700, Dmitry Torokhov wrote:
> On Thu, Mar 16, 2017 at 03:58:52PM +0530, Amitkumar Karwar wrote:
> > We observed a SHUTDOWN command timeout during reboot stress test
> > due to a corner case firmware bug. It leads to use-after-free on
> > adapter structure pointer and crash.
> > 
> > Let's add MWIFIEX_IFACE_WORK_DONT_RUN work flag to avoid executing
> > any work scheduled after cancel_work_sync() call in teardown path
> > to resolve the issue.
> > 
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > ---
> > v2: New work_flag has been added to resolve the issue cleanly as per
> > Brian's suggestion.
> > ---
> >  drivers/net/wireless/marvell/mwifiex/main.h | 1 +
> >  drivers/net/wireless/marvell/mwifiex/pcie.c | 4 ++++
> >  drivers/net/wireless/marvell/mwifiex/sdio.c | 4 ++++
> >  3 files changed, 9 insertions(+)
> > 
> > diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
> > index 5c82972..d5b1fd6 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/main.h
> > +++ b/drivers/net/wireless/marvell/mwifiex/main.h
> > @@ -510,6 +510,7 @@ struct mwifiex_roc_cfg {
> >  enum mwifiex_iface_work_flags {
> >  	MWIFIEX_IFACE_WORK_DEVICE_DUMP,
> >  	MWIFIEX_IFACE_WORK_CARD_RESET,
> > +	MWIFIEX_IFACE_WORK_DONT_RUN,
> >  };
> >  
> >  struct mwifiex_private {
> > diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > index a0d9180..bb3d798 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > @@ -294,6 +294,7 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
> >  	if (!adapter || !adapter->priv_num)
> >  		return;
> >  
> > +	set_bit(MWIFIEX_IFACE_WORK_DONT_RUN, &card->work_flags);
> >  	cancel_work_sync(&card->work);
> >  
> >  	reg = card->pcie.reg;
> > @@ -2721,6 +2722,9 @@ static void mwifiex_pcie_work(struct work_struct *work)
> >  	struct pcie_service_card *card =
> >  		container_of(work, struct pcie_service_card, work);
> >  
> > +	if (test_bit(MWIFIEX_IFACE_WORK_DONT_RUN, &card->work_flags))
> > +		return;
> 
> I do not see how this could possible prevent use-after-free, assuming
> that the "card" memory is gone by the time mwifiex_pcie_work() gets to
> run.

The 'card' memory isn't getting freed; it's the 'adapter' memory we're
worried about. This is either already freed (because the FW init
procedure failed), or else it's freed later in this function via
mwifiex_remove_card().

(We're also worried about having the FW dump race with the FW shutdown
sequence, which can begin later in this function. This patch blocks both
races AFAICT.)

> You need to check this flag before queueing firmware dump work, and
> make sure it is not racy with setting this flag in mwifiex_pcie_remove()
> (and sdio).

That's another approach that could work, but it's a little more
invasive.

I'm still reviewing and testing this, but I believe this is nearly
equivalent to my own draft version, which tested out fine.

Brian
