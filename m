Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856Ab1BIG0q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 01:26:46 -0500
Date: Wed, 9 Feb 2011 07:26:45 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/5] iwlwifi: fix ack health for WiFi/BT combo devices
Message-ID: <20110209062645.GB2184@redhat.com>
References: <1297153919-18766-1-git-send-email-sgruszka@redhat.com>
 <1297153919-18766-4-git-send-email-sgruszka@redhat.com>
 <1297179370.20613.30.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297179370.20613.30.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 08, 2011 at 07:36:10AM -0800, wwguy wrote:
> Hi Stanislaw,
> 
> On Tue, 2011-02-08 at 00:31 -0800, Stanislaw Gruszka wrote:
> > Combo devices have TX statistics on different place, because
> > struct statistics_rx_bt and struct statistics_rx have different
> > size. User proper values on combo devices instead of random data.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/iwlwifi/iwl-agn.c |    9 +++++++--
> >  1 files changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> > index 8c4ca39..6dd5001 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> > @@ -1419,8 +1419,13 @@ bool iwl_good_ack_health(struct iwl_priv *priv, struct iwl_rx_packet *pkt)
> >  	if (priv->_agn.agg_tids_count)
> >  		return true;
> >  
> > -	cur = &pkt->u.stats.tx;
> > -	old = &priv->_agn.statistics.tx;
> > +	if (iwl_bt_statistics(priv)) {
> > +		cur = &pkt->u.stats_bt.tx;
> > +		old = &priv->_agn.statistics_bt.tx;
> > +	} else {
> > +		cur = &pkt->u.stats.tx;
> > +		old = &priv->_agn.statistics.tx;
> > +	}
> >  
> >  	actual_delta = le32_to_cpu(cur->actual_ack_cnt) -
> >  		       le32_to_cpu(old->actual_ack_cnt);
> 
> Should this combine with 3/5?

This bug was there before my 3'rd patch, it was just hard
to see it. I would like to have fix separate for documenting 
purposes.

Stanislaw
