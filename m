Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49003 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761469AbZJNXja (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 19:39:30 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2009 16:39:35 -0700
Date: Wed, 14 Oct 2009 16:38:51 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ic.felix@gmail.com" <ic.felix@gmail.com>
Subject: Re: [PATCH] mac80211: fix SME warning by removing stale BSS upon
	assoc failure
Message-ID: <20091014233849.GB4172@tux>
References: <1255481442-27130-1-git-send-email-lrodriguez@atheros.com> <1255562895.4095.297.camel@johannes.local> <20091014233528.GA4172@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20091014233528.GA4172@tux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 14, 2009 at 04:35:28PM -0700, Luis Rodriguez wrote:
> > > --- a/net/mac80211/mlme.c
> > > +++ b/net/mac80211/mlme.c
> > > @@ -1463,11 +1463,11 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
> > >     if (status_code != WLAN_STATUS_SUCCESS) {
> > >             printk(KERN_DEBUG "%s: AP denied association (code=%d)\n",
> > >                    sdata->dev->name, status_code);
> > >             list_del(&wk->list);
> > >             kfree(wk);
> > > -           return RX_MGMT_CFG80211_ASSOC;
> > > +           return RX_MGMT_CFG80211_DEAUTH;
> >
> > I'm sure this is correct. Maybe cfg80211 doesn't react properly to
> > getting an assoc frame with non-zero status?
> 
> I see, will have to take a look when I get a chance then, not now though.

Actually can you elaborate a little on the logic here as to why
we want to issue an association command with non-zero status to
cfg80211 instead of just knocking off the current authentication
and killing the BSS?

  Luis
