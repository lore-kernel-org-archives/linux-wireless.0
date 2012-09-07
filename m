Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52543 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760436Ab2IGLRk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 07:17:40 -0400
Message-ID: <1347016689.4256.10.camel@jlt4.sipsolutions.net> (sfid-20120907_131745_368283_412605DB)
Subject: Re: [PATCHv2 1/2] mac80211: export ieee80211_send_deauth_disassoc
 for usage outside of mlme.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: Antonio Quartulli <ordex@autistici.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 07 Sep 2012 13:18:09 +0200
In-Reply-To: <5049C35A.1050601@lri.fr>
References: <1346951275-32081-1-git-send-email-ordex@autistici.org>
	  (sfid-20120906_190828_405993_603EB9FF) <1347006332.4256.9.camel@jlt4.sipsolutions.net>
	 <5049C35A.1050601@lri.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-07 at 11:50 +0200, Nicolas Cavallari wrote:
> On 07/09/2012 10:25, Johannes Berg wrote:
> > On Thu, 2012-09-06 at 19:07 +0200, Antonio Quartulli wrote:
> > 
> >> -		if (!(ifmgd->flags & IEEE80211_STA_MFP_ENABLED))
> >> -			IEEE80211_SKB_CB(skb)->flags |=
> >> -				IEEE80211_TX_INTFL_DONT_ENCRYPT;
> > 
> > 
> >> +		if (sdata->vif.type == NL80211_IFTYPE_STATION &&
> >> +		    !(sdata->u.mgd.flags & IEEE80211_STA_MFP_ENABLED))
> >> +			IEEE80211_SKB_CB(skb)->flags |=
> >> +				IEEE80211_TX_INTFL_DONT_ENCRYPT;
> > 
> > It would seem that this should be 
> > 
> > 	if (sdata->vif.type != NL80211_IFTYPE_STATION ||
> > 	    !(flags & MFP_ENABLED))
> > 
> > ?
> 
> Or just never set TX_INTFL_DONT_ENCRYPT at all and rely on
> ieee80211_tx_h_select_key() to do the right thing ?

I don't think it can do the right thing, it doesn't check whether MFP is
enabled or not... unless you want to test all those cases I'd rather not
change it :)

johannes

