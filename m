Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33866 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbcHALQb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2016 07:16:31 -0400
Message-ID: <1470045822.3389.24.camel@sipsolutions.net> (sfid-20160801_131757_335784_B3B292FF)
Subject: Re: [PATCH v3 3/3] mac80211: mesh: fixed HT ies in beacon template
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>,
	Yaniv Machani <yanivma@ti.com>, linux-kernel@vger.kernel.org
Cc: Meirav Kama <meiravk@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Mon, 01 Aug 2016 12:03:42 +0200
In-Reply-To: <40a34537-486e-a466-5a7e-e253f19d81c3@gmail.com> (sfid-20160722_072626_919337_95556AEF)
References: <20160713200755.26839-1-yanivma@ti.com>
	 <40a34537-486e-a466-5a7e-e253f19d81c3@gmail.com>
	 (sfid-20160722_072626_919337_95556AEF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-07-22 at 14:26 +0900, Masashi Honma wrote:
> On 2016年07月14日 05:07, Yaniv Machani wrote:
> > +
> > +	/* if channel width is 20MHz - configure HT capab
> > accordingly*/
> > +	if (sdata->vif.bss_conf.chandef.width ==
> > NL80211_CHAN_WIDTH_20) {
> > +		cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
> > +		cap &= ~IEEE80211_HT_CAP_DSSSCCK40;
> > +	}
> 
> I have tested this part of your patch and this works for me.
> 
> Previouly, "Supported Channel Width Set bit" in HT Capabilities
> element was 1 even though disable_ht40=1 existed in
> wpa_supplicant.conf. After appllication of patch, the bit was 0.
> 

But why is that behaviour *correct*? We still support 40 MHz bandwidth
things, we just don't use them if we disable HT40.

johannes
