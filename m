Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:8816 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab1CGUAp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 15:00:45 -0500
Subject: Re: [PATCH] iwlagn: fix offchannel TX bug
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Chatre, Reinette" <reinette.chatre@intel.com>
In-Reply-To: <1299524535.6739.6.camel@jlt3.sipsolutions.net>
References: <1299350139.29845.4.camel@jlt3.sipsolutions.net>
	 <20110307185429.GD2664@tuxdriver.com>
	 <1299524535.6739.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 11:44:20 -0800
Message-ID: <1299527060.5082.172.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-07 at 11:02 -0800, Johannes Berg wrote:
> On Mon, 2011-03-07 at 13:54 -0500, John W. Linville wrote:
> 
> > > --- a/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-03-05 19:32:58.000000000 +0100
> > > +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-03-05 19:33:08.000000000 +0100
> > > @@ -3171,7 +3171,7 @@ static int iwl_mac_offchannel_tx(struct
> > >   out:
> > >  	mutex_unlock(&priv->mutex);
> > >   free:
> > > -	if (ret)
> > > +	if (ret < 0)
> > >  		kfree_skb(skb);
> > >  
> > >  	return ret;
> > 
> > OK, I give-up...what tree is this against? :-)
> 
> Oh dang, it's against our own tree and I thought we'd already sent out
> the patch "iwlagn: support off-channel TX". Clearly, that isn't the
> case. Wey-yi, can you please merge this fix with the patch?
> 
> Sorry about that!

oh, sorry, I did not merge because waiting for the patch to fix the
iwlagn compiling problem. sorry!

Wey
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


