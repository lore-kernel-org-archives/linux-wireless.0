Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56672 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210AbYEMQ0C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 12:26:02 -0400
Subject: Re: libertas: fix command timeout after firmware failure
From: David Woodhouse <dwmw2@infradead.org>
To: Dan Williams <dcbw@redhat.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org,
	Brian Cavagnolo <brian@cozybit.com>,
	Javier Cardona <javier@cozybit.com>
In-Reply-To: <1210695568.9976.3.camel@localhost.localdomain>
References: <1210683299.3582.240.camel@pmac.infradead.org>
	 <1210695568.9976.3.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 13 May 2008 17:25:48 +0100
Message-Id: <1210695948.3582.267.camel@pmac.infradead.org> (sfid-20080513_182607_546782_180352AF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-05-13 at 12:19 -0400, Dan Williams wrote:
> On Tue, 2008-05-13 at 13:54 +0100, David Woodhouse wrote:
> > From: Brian Cavagnolo <brian@cozybit.com>
> > 
> > This is a fix for OLPC ticket #6586: "SCAN command fails, timer doesn't
> > fire". In fact, the timer was firing; the problem was that the dnld_sent
> > state variable was not being updated after the timer expired, so
> > lbs_execute_next_command was not being called.
> > 
> > Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
> > Signed-off-by: Javier Cardona <javier@cozybit.com>
> > Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> > 
> > ---
> > Bug fix, for 2.6.26 please.
> > 
> > --- a/drivers/net/wireless/libertas/main.c
> > +++ b/drivers/net/wireless/libertas/main.c
> > @@ -756,6 +756,7 @@ static int lbs_thread(void *data)
> >  				priv->nr_retries = 0;
> >  			} else {
> >  				priv->cur_cmd = NULL;
> > +				priv->dnld_sent = DNLD_RES_RECEIVED;
> >  				lbs_pr_info("requeueing command %x due to timeout (#%d)\n",
> >  					    le16_to_cpu(cmdnode->cmdbuf->command), priv->nr_retries);
> 
> We really need to kill dnld_sent.

Yes. I almost managed it at one point but I think I wanted to get set up
to set on CF and SD hardware before I really did it.

-- 
dwmw2

