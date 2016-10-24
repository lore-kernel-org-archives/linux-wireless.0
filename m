Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33868 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753216AbcJXX5u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 19:57:50 -0400
Received: by mail-pf0-f195.google.com with SMTP id 128so17778424pfz.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Oct 2016 16:57:49 -0700 (PDT)
Date: Mon, 24 Oct 2016 16:57:46 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Brian Norris <briannorris@chromium.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH 2/5] mwifiex: use spinlock for 'mwifiex_processing' in
 shutdown_drv
Message-ID: <20161024235746.GC15034@dtor-ws> (sfid-20161025_015752_631446_9AF8C9F4)
References: <1477318892-22877-1-git-send-email-akarwar@marvell.com>
 <1477318892-22877-2-git-send-email-akarwar@marvell.com>
 <20161024191914.GB968@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161024191914.GB968@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 24, 2016 at 12:19:15PM -0700, Brian Norris wrote:
> On Mon, Oct 24, 2016 at 07:51:29PM +0530, Amitkumar Karwar wrote:
> > This variable is guarded by spinlock at all other places. This patch
> > takes care of missing spinlock usage in mwifiex_shutdown_drv().
> > 
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > ---
> >  drivers/net/wireless/marvell/mwifiex/init.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
> > index 82839d9..8e5e424 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/init.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/init.c
> > @@ -670,11 +670,14 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
> >  
> >  	adapter->hw_status = MWIFIEX_HW_STATUS_CLOSING;
> >  	/* wait for mwifiex_process to complete */
> > +	spin_lock_irqsave(&adapter->main_proc_lock, flags);
> >  	if (adapter->mwifiex_processing) {
> 
> I'm not quite sure why we have this check in the first place; if the
> main process is still running, then don't we have bigger problems here
> anyway? But this is definitely the "right" way to check this flag, so:

No, this is definitely not right way to check it. What exactly does this
spinlock protect? It seems that the intent is to make sure we do not
call mwifiex_shutdown_drv() while mwifiex_main_process() is executing.
It even says above that we are "waiting" for it (but we do not, we may
bail out or we may not, depends on luck).

To implement this properly you not only need to take a lock and check
the flag, but keep the lock until mwifiex_shutdown_drv() is done, or
use some other way to let mwifiex_main_process() know it should not
access the adapter while mwifiex_shutdown_drv() is running.

NACK.

Thanks.

> 
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> 
> > +		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
> >  		mwifiex_dbg(adapter, WARN,
> >  			    "main process is still running\n");
> >  		return ret;
> >  	}
> > +	spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
> >  
> >  	/* cancel current command */
> >  	if (adapter->curr_cmd) {
> > -- 
> > 1.9.1
> > 

-- 
Dmitry
