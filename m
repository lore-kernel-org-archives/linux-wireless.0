Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51892 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755649AbcLOQnr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 11:43:47 -0500
Date: Thu, 15 Dec 2016 22:13:39 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Kalle Valo <kvalo@qca.qualcomm.com>
Subject: Re: [PATCH 1/2] ath10k: add accounting for the extended peer
 statistics
Message-ID: <20161215164338.GB8030@atheros-ThinkPad-T61> (sfid-20161215_174350_747315_F320D714)
References: <992a4e2676037a06f482cdbe2d3d39e287530be5.1480974623.git.chunkeey@googlemail.com>
 <2870294.lMmxz9iPmq@debian64>
 <20161214073337.GA4046@atheros-ThinkPad-T61>
 <1859306.unY1Rqbrx8@debian64>
 <20161215162659.GA8030@atheros-ThinkPad-T61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161215162659.GA8030@atheros-ThinkPad-T61>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

I am also thinking, as of now there is not much use in appending
the extended peer stats (which gets periodically ) to the linked list
'&ar->debug.fw_stats.peers_extd)'  and should we get rid of the below
(and the required cleanup as well) 

list_splice_tail_init(&stats.peers_extd,
		&ar->debug.fw_stats.peers_extd);


since rx_duration is getting updated periodically to the per sta
information. Kindly let me know your thoughts about this.

regards,
shafi

On Thu, Dec 15, 2016 at 09:56:59PM +0530, Mohammed Shafi Shajakhan wrote:
> Hello Christian,
> 
> On Wed, Dec 14, 2016 at 05:38:02PM +0100, Christian Lamparter wrote:
> > On Wednesday, December 14, 2016 1:03:38 PM CET Mohammed Shafi Shajakhan wrote:
> > > > On Wednesday, December 7, 2016 11:58:24 AM CET Mohammed Shafi Shajakhan wrote:
> > > > > On Mon, Dec 05, 2016 at 10:52:45PM +0100, Christian Lamparter wrote:
> > > > > > @@ -409,10 +410,12 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
> > > > > >  			goto free;
> > > > > >  		}
> > > > > >  
> > > > > > +		if (!list_empty(&stats.peers))
> > > > > 
> > > > > [shafi] sorry please correct me if i am wrong, for 'extended peer stats' we are checking
> > > > > for normal 'peer stats' ? Is this the fix intended, i had started a build to
> > > > > check your change and we will keep you posted, does this fix displaying
> > > > > 'rx_duration' in ath10k fw_stats.
> > > > The idea is not to queue any "extended peer stats" when there where no "peer stats" to
> > > > begin with. Because otherwise, the function is still vulnerable to OOM since the 
> > > > extended peers stats will be queued unchecked (not that this is currently a problem).
> > > 
> > > [shafi] list_splice_tail_init should still check for non-empty 'peers_extd' list
> > > and append if required ? please let me know if i am still missing something
> > Well, you can also count the entries in peers_extd and delete the old entries
> > if they start to overflow. If you want to do it differently, please go ahead.
> >
> [shafi] sorry for the delay (got stuck up with something else), I will add some prints explicitly
> and keep you posted ASAP. Since the extended peer stats gets updated periodically I
> would like to confirm the debug linked list associated to the extended peer
> stats does not overflows and potentially cause OOM.
> 
> regards,
> shafi
