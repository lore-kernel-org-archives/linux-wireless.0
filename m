Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49170 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbcGRSw2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 14:52:28 -0400
Message-ID: <1468867942.2944.0.camel@sipsolutions.net> (sfid-20160718_205249_138376_A21E431A)
Subject: Re: [PATCH 3/3] mac80211: mesh: fixed HT ies in beacon template
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>, Yaniv Machani <yanivma@ti.com>
Cc: linux-kernel@vger.kernel.org, Meirav Kama <meiravk@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Mon, 18 Jul 2016 20:52:22 +0200
In-Reply-To: <20160718133824.GA11996@localhost> (sfid-20160718_153832_665157_D129D05B)
References: <20160713114542.24937-1-yanivma@ti.com>
	 <20160718133824.GA11996@localhost> (sfid-20160718_153832_665157_D129D05B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-07-18 at 09:38 -0400, Bob Copeland wrote:
> On Wed, Jul 13, 2016 at 02:45:40PM +0300, Yaniv Machani wrote:
> > The HT capab info field inside the HT capab IE of the mesh beacon
> > is incorrect (in the case of 20MHz channel width).
> > To fix this driver will check configuration from cfg and
> > will build it accordingly.
> 
> > +    /* determine capability flags */
> > +	cap = sband->ht_cap.cap;
> > +
> > +    /* if channel width is 20MHz - configure HT capab
> > accordingly*/
> > +	if (sdata->vif.bss_conf.chandef.width ==
> > NL80211_CHAN_WIDTH_20) {
> > +		cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
> > +		cap &= ~IEEE80211_HT_CAP_DSSSCCK40;
> > +	}
> 
> Is it required that HT capability match the HT operation in this
> case?
> 

Is there ever a case that HT *capability* should be restricted
artificially like that? I can't remember any cases - we do something
like that to work around broken APs in some cases, but here?

johannes
