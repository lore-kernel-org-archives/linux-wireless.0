Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50558 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754447AbcJYQAg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Oct 2016 12:00:36 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "briannorris@google.com" <briannorris@google.com>
Subject: RE: [PATCH 2/5] mwifiex: use spinlock for 'mwifiex_processing' in
 shutdown_drv
Date: Tue, 25 Oct 2016 16:00:32 +0000
Message-ID: <1229e7aa12fa4601831872f3e3ac546d@SC-EXCH04.marvell.com> (sfid-20161025_180040_330096_82DCFD00)
References: <1477318892-22877-1-git-send-email-akarwar@marvell.com>
 <1477318892-22877-2-git-send-email-akarwar@marvell.com>
 <20161024234720.GB15034@dtor-ws> <20161024235555.GA7745@localhost>
In-Reply-To: <20161024235555.GA7745@localhost>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian/Dmitry,

> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Tuesday, October 25, 2016 5:26 AM
> To: Dmitry Torokhov
> Cc: Amitkumar Karwar; linux-wireless@vger.kernel.org; Cathy Luo; Nishant
> Sarmukadam; briannorris@google.com
> Subject: Re: [PATCH 2/5] mwifiex: use spinlock for 'mwifiex_processing'
> in shutdown_drv
> 
> Hi,
> 
> On Mon, Oct 24, 2016 at 04:47:20PM -0700, Dmitry Torokhov wrote:
> > On Mon, Oct 24, 2016 at 07:51:29PM +0530, Amitkumar Karwar wrote:
> > > This variable is guarded by spinlock at all other places. This patch
> > > takes care of missing spinlock usage in mwifiex_shutdown_drv().
> > >
> > > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > > ---
> > >  drivers/net/wireless/marvell/mwifiex/init.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/drivers/net/wireless/marvell/mwifiex/init.c
> > > b/drivers/net/wireless/marvell/mwifiex/init.c
> > > index 82839d9..8e5e424 100644
> > > --- a/drivers/net/wireless/marvell/mwifiex/init.c
> > > +++ b/drivers/net/wireless/marvell/mwifiex/init.c
> > > @@ -670,11 +670,14 @@ mwifiex_shutdown_drv(struct mwifiex_adapter
> > > *adapter)
> > >
> > >  	adapter->hw_status = MWIFIEX_HW_STATUS_CLOSING;
> > >  	/* wait for mwifiex_process to complete */
> > > +	spin_lock_irqsave(&adapter->main_proc_lock, flags);
> > >  	if (adapter->mwifiex_processing) {
> > > +		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
> > >  		mwifiex_dbg(adapter, WARN,
> > >  			    "main process is still running\n");
> > >  		return ret;
> > >  	}
> > > +	spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
> >
> > What happens if adapter->mwifiex_processing will become true here?
> 
> That's why I commented:
> 
> "I'm not quite sure why we have this check in the first place; if the
> main process is still running, then don't we have bigger problems here
> anyway?"

If mwifiex_processing is true here, it means main_process is still running. We have set "adapter->hw_status = MWIFIEX_HW_STATUS_CLOSING" in mwifiex_shutdown_drv().
Now we will wait until main_process() gets completed.

---------------------
if (mwifiex_shutdown_drv(adapter) == -EINPROGRESS)
     wait_event_interruptible(adapter->init_wait_q,
				      adapter->init_wait_q_woken);
--------------

We have following logic at the end of main_process()
-------
exit_main_proc:
        if (adapter->hw_status == MWIFIEX_HW_STATUS_CLOSING)
                mwifiex_shutdown_drv(adapter);
--------

Regards,
Amitkumar Karwar
