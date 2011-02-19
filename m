Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:33987 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab1BSGNG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Feb 2011 01:13:06 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 22:12:45 -0800
Date: Sat, 19 Feb 2011 11:42:42 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vivek Natarajan <Vivek.Natarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] mac80211: Fix a race on enabling power save.
Message-ID: <20110219061241.GA5881@vmraj-lnx.users.atheros.com>
References: <1298018776-6936-1-git-send-email-vnatarajan@atheros.com>
 <1298027245.3772.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1298027245.3772.3.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 18, 2011 at 04:37:25PM +0530, Johannes Berg wrote:
> On Fri, 2011-02-18 at 14:16 +0530, Vivek Natarajan wrote:
> > There is a race on sending a data frame before the tx completion
> > of nullfunc frame for enabling power save. As the data quickly
> > follows the nullfunc frame, the AP thinks that the station is out
> > of power save and continues to send the frames. Whereas in the
> > station, the nullfunc ack will be processed after the tx completion
> > of data frame and mac80211 goes to powersave. Thus the power
> > save state mismatch between the station and the AP causes some
> > data loss and some applications fail because of that. This patch
> > fixes this issue.
> > 
> > Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> > ---
> >  net/mac80211/mlme.c   |   11 ++++++++++-
> >  net/mac80211/status.c |    2 --
> >  2 files changed, 10 insertions(+), 3 deletions(-)
> > 
> > diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> > index d89e878..91006a2 100644
> > --- a/net/mac80211/mlme.c
> > +++ b/net/mac80211/mlme.c
> > @@ -738,8 +738,16 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
> >  		return;
> >  
> >  	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
> > -	    (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)))
> > +	    (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED))) {
> > +		netif_tx_stop_all_queues(sdata->dev);
> > +		/* flush all the frames queued in the driver before
> > +		 * going to power save
> > +		 */
> > +		drv_flush(local, false);
> 
> Ok, I should've thought of this earlier -- but can we really do this?
> 
> I know we currently don't allow powersave when there's more than one
> interface, but we still allow it while there are monitor interfaces and
> a monitor interface could be sending packets, which would violate the
> flush() contract with the driver -- the driver may expect not to get any
> packets during flush.
AFIK we also are not stopping tx queue of monitor iface on offchannel.
Doing so could help flush().

> I'm not sure. Maybe we should disable powersave when there are monitor
> interfaces after all, even though that would rob us of a way to debug
> things. Thoughts?
>
drivers like ath9k receives all frames from any bss on FIF_PROMISC_IN_BSS,
since there is no specific hw filter for that. So in that case it would be
better to disable power save.

--
Rajkumar
