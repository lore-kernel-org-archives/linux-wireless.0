Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.u-psud.fr ([129.175.33.42]:26737 "EHLO smtp2.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760320Ab2IGKAD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 06:00:03 -0400
Message-ID: <5049C35A.1050601@lri.fr> (sfid-20120907_120008_684032_BAF46BDB)
Date: Fri, 07 Sep 2012 11:50:18 +0200
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Antonio Quartulli <ordex@autistici.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 1/2] mac80211: export ieee80211_send_deauth_disassoc
 for usage outside of mlme.c
References: <1346951275-32081-1-git-send-email-ordex@autistici.org>  (sfid-20120906_190828_405993_603EB9FF) <1347006332.4256.9.camel@jlt4.sipsolutions.net>
In-Reply-To: <1347006332.4256.9.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/09/2012 10:25, Johannes Berg wrote:
> On Thu, 2012-09-06 at 19:07 +0200, Antonio Quartulli wrote:
> 
>> -		if (!(ifmgd->flags & IEEE80211_STA_MFP_ENABLED))
>> -			IEEE80211_SKB_CB(skb)->flags |=
>> -				IEEE80211_TX_INTFL_DONT_ENCRYPT;
> 
> 
>> +		if (sdata->vif.type == NL80211_IFTYPE_STATION &&
>> +		    !(sdata->u.mgd.flags & IEEE80211_STA_MFP_ENABLED))
>> +			IEEE80211_SKB_CB(skb)->flags |=
>> +				IEEE80211_TX_INTFL_DONT_ENCRYPT;
> 
> It would seem that this should be 
> 
> 	if (sdata->vif.type != NL80211_IFTYPE_STATION ||
> 	    !(flags & MFP_ENABLED))
> 
> ?

Or just never set TX_INTFL_DONT_ENCRYPT at all and rely on
ieee80211_tx_h_select_key() to do the right thing ?
