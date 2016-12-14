Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35002 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754722AbcLNH6s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 02:58:48 -0500
Date: Wed, 14 Dec 2016 13:03:38 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Kalle Valo <kvalo@qca.qualcomm.com>
Subject: Re: [PATCH 1/2] ath10k: add accounting for the extended peer
 statistics
Message-ID: <20161214073337.GA4046@atheros-ThinkPad-T61> (sfid-20161214_085855_424930_0BF27052)
References: <992a4e2676037a06f482cdbe2d3d39e287530be5.1480974623.git.chunkeey@googlemail.com>
 <20161207062824.GA3404@atheros-ThinkPad-T61>
 <2870294.lMmxz9iPmq@debian64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2870294.lMmxz9iPmq@debian64>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 13, 2016 at 01:41:33PM +0100, Christian Lamparter wrote:
> Hello,
> 
> It looks like google put your mail into the spam-can. 
> I'm sorry for not answering sooner.

[shafi] np, thanks for your reply !

> 
> On Wednesday, December 7, 2016 11:58:24 AM CET Mohammed Shafi Shajakhan wrote:
> > On Mon, Dec 05, 2016 at 10:52:45PM +0100, Christian Lamparter wrote:
> > > The 10.4 firmware adds extended peer information to the
> > > firmware's statistics payload. This additional info is
> > > stored as a separate data field and the elements are
> > > stored in their own "peers_extd" list.
> > > 
> > > These elements can pile up in the same way as the peer
> > > information elements. This is because the
> > > ath10k_wmi_10_4_op_pull_fw_stats() function tries to
> > > pull the same amount (num_peer_stats) for every statistic
> > > data unit.
> > > 
> > > Fixes: 4a49ae94a448faa ("ath10k: fix 10.4 extended peer stats update")
> > > Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> > > ---
> > >  drivers/net/wireless/ath/ath10k/debug.c | 7 +++++--
> > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> > > index 82a4c67f3672..4acd9eb65910 100644
> > > --- a/drivers/net/wireless/ath/ath10k/debug.c
> > > +++ b/drivers/net/wireless/ath/ath10k/debug.c
> > > @@ -399,6 +399,7 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
> > >  			 * prevent firmware from DoS-ing the host.
> > >  			 */
> > >  			ath10k_fw_stats_peers_free(&ar->debug.fw_stats.peers);
> > > +			ath10k_fw_extd_stats_peers_free(&ar->debug.fw_stats.peers_extd);
> > 
> > [shafi] thanks for fixing this !
> > 
> > >  			ath10k_warn(ar, "dropping fw peer stats\n");
> > >  			goto free;
> > >  		}
> > > @@ -409,10 +410,12 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
> > >  			goto free;
> > >  		}
> > >  
> > > +		if (!list_empty(&stats.peers))
> > 
> > [shafi] sorry please correct me if i am wrong, for 'extended peer stats' we are checking
> > for normal 'peer stats' ? Is this the fix intended, i had started a build to
> > check your change and we will keep you posted, does this fix displaying
> > 'rx_duration' in ath10k fw_stats.
> The idea is not to queue any "extended peer stats" when there where no "peer stats" to
> begin with. Because otherwise, the function is still vulnerable to OOM since the 
> extended peers stats will be queued unchecked (not that this is currently a problem).

[shafi] list_splice_tail_init should still check for non-empty 'peers_extd' list
and append if required ? please let me know if i am still missing something

>  
> > > +			list_splice_tail_init(&stats.peers_extd,
> > > +					      &ar->debug.fw_stats.peers_extd);
> > > +
> > >  		list_splice_tail_init(&stats.peers, &ar->debug.fw_stats.peers);
> > >  		list_splice_tail_init(&stats.vdevs, &ar->debug.fw_stats.vdevs);
> > > -		list_splice_tail_init(&stats.peers_extd,
> > > -				      &ar->debug.fw_stats.peers_extd);
> > >  	}
> > >  
> > >  	complete(&ar->debug.fw_stats_complete);
> 
> Regards,
> Christian
> 
> 
