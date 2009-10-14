Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:48813 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757334AbZJNXgH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 19:36:07 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2009 16:36:12 -0700
Date: Wed, 14 Oct 2009 16:35:28 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ic.felix@gmail.com" <ic.felix@gmail.com>
Subject: Re: [PATCH] mac80211: fix SME warning by removing stale BSS upon
	assoc failure
Message-ID: <20091014233528.GA4172@tux>
References: <1255481442-27130-1-git-send-email-lrodriguez@atheros.com> <1255562895.4095.297.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1255562895.4095.297.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 14, 2009 at 04:28:15PM -0700, Johannes Berg wrote:
> On Tue, 2009-10-13 at 20:50 -0400, Luis R. Rodriguez wrote:
> > If you try to authenticate with an AP we will keep track of the
> > AP's BSS and expect to eventually either give up on the AP or complete
> > an association cycle with it. If an AP rejects our association though
> > mac80211 currently insists on telling cfg80211 a BSS authenticated
> > correctly, this is wrong as it leaves a bogus BSS lingering around.
> 
> But if assoc fails, it _did_ authenticate correctly.

Well sure, but why do we want to keep the authentication present if
association failed? And as a matter of fact it lingers there forever.
Is that desired behaviour?

> > --- a/net/mac80211/mlme.c
> > +++ b/net/mac80211/mlme.c
> > @@ -1463,11 +1463,11 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
> >  	if (status_code != WLAN_STATUS_SUCCESS) {
> >  		printk(KERN_DEBUG "%s: AP denied association (code=%d)\n",
> >  		       sdata->dev->name, status_code);
> >  		list_del(&wk->list);
> >  		kfree(wk);
> > -		return RX_MGMT_CFG80211_ASSOC;
> > +		return RX_MGMT_CFG80211_DEAUTH;
> 
> I'm sure this is correct. Maybe cfg80211 doesn't react properly to
> getting an assoc frame with non-zero status?

I see, will have to take a look when I get a chance then, not now though.

  Luis
