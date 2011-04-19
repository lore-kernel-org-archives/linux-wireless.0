Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:26307 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830Ab1DSOnr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 10:43:47 -0400
Subject: Re: [PATCH 02/10] iwlagn: remove most BUG_ON instances
From: wwguy <wey-yi.w.guy@intel.com>
To: "Berg, Johannes" <johannes.berg@intel.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1303214502.3603.1.camel@jlt3.sipsolutions.net>
References: <1303145057-6545-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1303145057-6545-3-git-send-email-wey-yi.w.guy@intel.com>
	 <20110419120002.GA2220@redhat.com>
	 <1303214502.3603.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Apr 2011 07:40:59 -0700
Message-ID: <1303224059.13481.0.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-19 at 05:01 -0700, Berg, Johannes wrote:
> On Tue, 2011-04-19 at 14:00 +0200, Stanislaw Gruszka wrote:
> > On Mon, Apr 18, 2011 at 09:44:09AM -0700, Wey-Yi Guy wrote:
> > > From: Johannes Berg <johannes.berg@intel.com>
> > > @@ -394,7 +394,9 @@ int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
> > >  		return -EINVAL;
> > >  	}
> > >  
> > > -	BUG_ON(addr & ~DMA_BIT_MASK(36));
> > > +	if (WARN_ON(addr & ~DMA_BIT_MASK(36)))
> > > +		return -EINVAL;
> > Seems useless.
> 
> Better than the BUG_ON, mostly to catch programmer errors though I
> guess.
> 
> > > @@ -169,10 +171,12 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
> > >  	int cmd_idx;
> > >  	int ret;
> > >  
> > > -	lockdep_assert_held(&priv->mutex);
> > I think better keep it.
> 
> Oh, that must be a merge error, I don't remember doing that.
> 
That is a merge error, I will put it back even it is just for debugging.

Wey
> 


