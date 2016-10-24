Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:35452 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754157AbcJXXz6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 19:55:58 -0400
Received: by mail-pf0-f176.google.com with SMTP id s8so107186323pfj.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Oct 2016 16:55:58 -0700 (PDT)
Date: Mon, 24 Oct 2016 16:55:55 -0700
From: Brian Norris <briannorris@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        briannorris@google.com
Subject: Re: [PATCH 2/5] mwifiex: use spinlock for 'mwifiex_processing' in
 shutdown_drv
Message-ID: <20161024235555.GA7745@localhost> (sfid-20161025_015602_545221_7B9FCCE9)
References: <1477318892-22877-1-git-send-email-akarwar@marvell.com>
 <1477318892-22877-2-git-send-email-akarwar@marvell.com>
 <20161024234720.GB15034@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161024234720.GB15034@dtor-ws>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Oct 24, 2016 at 04:47:20PM -0700, Dmitry Torokhov wrote:
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
> > +		spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
> >  		mwifiex_dbg(adapter, WARN,
> >  			    "main process is still running\n");
> >  		return ret;
> >  	}
> > +	spin_unlock_irqrestore(&adapter->main_proc_lock, flags);
> 
> What happens if adapter->mwifiex_processing will become true here?

That's why I commented:

"I'm not quite sure why we have this check in the first place; if the
main process is still running, then don't we have bigger problems here
anyway?"

I think the answer is, we really better NOT see that become true. That
means that we've fired off more interrupts and began processing them.
But all callers should have disabled interrupts and stopped or flushed
the queue at this point, AFAICT.

So I expect the intention here is to be essentially an assert(), without
actually making it fatal. Maybe there's a better way to handle this? I
can't really think of a good one right now.

Brian

> >  
> >  	/* cancel current command */
> >  	if (adapter->curr_cmd) {
> > -- 
> > 1.9.1
> > 
> 
> -- 
> Dmitry
