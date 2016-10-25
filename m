Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50000 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932298AbcJYQLT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Oct 2016 12:11:19 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Brian Norris <briannorris@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Subject: RE: [PATCH 2/5] mwifiex: use spinlock for 'mwifiex_processing' in
 shutdown_drv
Date: Tue, 25 Oct 2016 16:11:14 +0000
Message-ID: <91f0f4390ac14afc9e4f3498d1b79c78@SC-EXCH04.marvell.com> (sfid-20161025_181123_097645_F88CF4C9)
References: <1477318892-22877-1-git-send-email-akarwar@marvell.com>
 <1477318892-22877-2-git-send-email-akarwar@marvell.com>
 <20161024191914.GB968@localhost> <20161024235746.GC15034@dtor-ws>
In-Reply-To: <20161024235746.GC15034@dtor-ws>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,

> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Tuesday, October 25, 2016 5:28 AM
> To: Brian Norris
> Cc: Amitkumar Karwar; linux-wireless@vger.kernel.org; Cathy Luo; Nishant
> Sarmukadam
> Subject: Re: [PATCH 2/5] mwifiex: use spinlock for 'mwifiex_processing'
> in shutdown_drv
> 
> On Mon, Oct 24, 2016 at 12:19:15PM -0700, Brian Norris wrote:
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
> >
> > I'm not quite sure why we have this check in the first place; if the
> > main process is still running, then don't we have bigger problems here
> > anyway? But this is definitely the "right" way to check this flag, so:
> 
> No, this is definitely not right way to check it. What exactly does this
> spinlock protect? It seems that the intent is to make sure we do not
> call mwifiex_shutdown_drv() while mwifiex_main_process() is executing.
> It even says above that we are "waiting" for it (but we do not, we may
> bail out or we may not, depends on luck).
> 
> To implement this properly you not only need to take a lock and check
> the flag, but keep the lock until mwifiex_shutdown_drv() is done, or use
> some other way to let mwifiex_main_process() know it should not access
> the adapter while mwifiex_shutdown_drv() is running.
> 
> NACK.
> 

As I explained in other email, here is the sequence.
1) We find mwifiex_processing is true in mwifiex_shitdown_drv(). "-EINPROGRESS" is returned by the function and hw_status state is changed to MWIFIEX_HW_STATUS_CLOSING.
2) We wait until main_process is completed.

                if (mwifiex_shutdown_drv(adapter) == -EINPROGRESS)
                        wait_event_interruptible(adapter->init_wait_q,
                                                 adapter->init_wait_q_woken);

3) We have following check at the end of main_process()

exit_main_proc:
        if (adapter->hw_status == MWIFIEX_HW_STATUS_CLOSING)
                mwifiex_shutdown_drv(adapter);

4) Here at the end of mwifiex_shutdown_drv(), we are setting "adapter->init_wait_q_woken" and waking up the thread in point (2)

Regards,
Amitkumar
