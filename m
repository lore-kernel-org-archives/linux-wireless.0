Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29877 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbaDWIkk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2014 04:40:40 -0400
Date: Wed, 23 Apr 2014 11:40:35 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Allow HT capa override to add 40 MHz intolerant
Message-ID: <20140423084035.GB5767@jouni.qca.qualcomm.com> (sfid-20140423_104055_264196_46B7A9C6)
References: <20140415161356.GA14293@jouni.qca.qualcomm.com>
 <1398180248.4211.23.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1398180248.4211.23.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 22, 2014 at 05:24:08PM +0200, Johannes Berg wrote:
> > +++ b/net/mac80211/main.c
> > @@ -446,7 +446,8 @@ static const struct ieee80211_ht_cap mac80211_ht_capa_mod_mask = {
> >  	.cap_info = cpu_to_le16(IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
> >  				IEEE80211_HT_CAP_MAX_AMSDU |
> >  				IEEE80211_HT_CAP_SGI_20 |
> > -				IEEE80211_HT_CAP_SGI_40),
> > +				IEEE80211_HT_CAP_SGI_40 |
> > +				IEEE80211_HT_CAP_40MHZ_INTOLERANT),
> 
> This had a conflict because LDPC was already in those flags ... I think
> I did the right thing by just adding 40MHZ_INTOLERANT.

Thanks, that looks good to me.

-- 
Jouni Malinen                                            PGP id EFC895FA
