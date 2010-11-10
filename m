Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:34530 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792Ab0KVGBf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 01:01:35 -0500
Subject: Re: [PATCH] mac80211: Add function to get probe request template
 for current AP
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1289321264.3660.0.camel@jlt3.sipsolutions.net>
References: <1289290893-6766-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1289321264.3660.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 08:13:52 +0200
Message-ID: <1289369632.2522.59.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-11-09 at 17:47 +0100, ext Johannes Berg wrote:
> On Tue, 2010-11-09 at 10:21 +0200, juuso.oikarinen@nokia.com wrote:
> 
> > +struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
> > +					  struct ieee80211_vif *vif)
> > +{
> > +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> > +	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
> > +	struct sk_buff *skb;
> > +	const u8 *ssid;
> > +
> > +	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION))
> > +		return NULL;
> > +
> > +	ASSERT_MGD_MTX(ifmgd);
> 
> This is interesting locking, you will definitely need to document better
> that this may only be called from within the bss_info_changed callback.

Yeah, I agree it is interesting. I was pondering this quite a bit before
ending up with this. It appears there is no surefire way to call a
function from the driver which needs to access some mgd stuff as the
state of the mgd mutex varies depending on mac80211 callback and even
state of the stack.

I'll add some documentation.

-Juuso



> johannes
> 


