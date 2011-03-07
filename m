Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41125 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab1CGTCQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 14:02:16 -0500
Subject: Re: [PATCH] iwlagn: fix offchannel TX bug
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Wey-Yi W Guy <wey-yi.w.guy@intel.com>
In-Reply-To: <20110307185429.GD2664@tuxdriver.com>
References: <1299350139.29845.4.camel@jlt3.sipsolutions.net>
	 <20110307185429.GD2664@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 20:02:15 +0100
Message-ID: <1299524535.6739.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-07 at 13:54 -0500, John W. Linville wrote:

> > --- a/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-03-05 19:32:58.000000000 +0100
> > +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c	2011-03-05 19:33:08.000000000 +0100
> > @@ -3171,7 +3171,7 @@ static int iwl_mac_offchannel_tx(struct
> >   out:
> >  	mutex_unlock(&priv->mutex);
> >   free:
> > -	if (ret)
> > +	if (ret < 0)
> >  		kfree_skb(skb);
> >  
> >  	return ret;
> 
> OK, I give-up...what tree is this against? :-)

Oh dang, it's against our own tree and I thought we'd already sent out
the patch "iwlagn: support off-channel TX". Clearly, that isn't the
case. Wey-yi, can you please merge this fix with the patch?

Sorry about that!

johannes

