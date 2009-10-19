Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f212.google.com ([209.85.217.212]:46629 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbZJSQhP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 12:37:15 -0400
Received: by gxk4 with SMTP id 4so3389931gxk.8
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2009 09:37:19 -0700 (PDT)
Subject: Re: [PATCH] mac80211: fix SME warning by removing stale BSS upon
 assoc failure
From: ASIC Felix <ic.felix@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20091016182039.GC6438@tuxdriver.com>
References: <1255481442-27130-1-git-send-email-lrodriguez@atheros.com>
	 <1255562895.4095.297.camel@johannes.local> <20091014233528.GA4172@tux>
	 <1255685492.4095.309.camel@johannes.local>
	 <20091016182039.GC6438@tuxdriver.com>
Content-Type: text/plain
Date: Mon, 19 Oct 2009 09:37:11 -0700
Message-Id: <1255970231.32300.21.camel@darkslate>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-10-16 at 14:20 -0400, John W. Linville wrote:
> On Fri, Oct 16, 2009 at 06:31:32PM +0900, Johannes Berg wrote:
> > On Wed, 2009-10-14 at 16:35 -0700, Luis R. Rodriguez wrote:
> > 
> > > Well sure, but why do we want to keep the authentication present if
> > > association failed? And as a matter of fact it lingers there forever.
> > > Is that desired behaviour?
> > 
> > Yes, well, the SME is supposed to clean it up or try the association
> > again (possibly with different parameters in the IEs, e.g. different WPA
> > settings). The cfg80211 SME certainly does so (it deauthenticates).
> > 
> > > > > +++ b/net/mac80211/mlme.c
> > > > > @@ -1463,11 +1463,11 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
> > > > >  	if (status_code != WLAN_STATUS_SUCCESS) {
> > > > >  		printk(KERN_DEBUG "%s: AP denied association (code=%d)\n",
> > > > >  		       sdata->dev->name, status_code);
> > > > >  		list_del(&wk->list);
> > > > >  		kfree(wk);
> > > > > -		return RX_MGMT_CFG80211_ASSOC;
> > > > > +		return RX_MGMT_CFG80211_DEAUTH;
> > > > 
> > > > I'm sure this is correct. Maybe cfg80211 doesn't react properly to
> > > > getting an assoc frame with non-zero status?
> > > 
> > > I see, will have to take a look when I get a chance then, not now though.
> > 
> > > Actually can you elaborate a little on the logic here as to why
> > > we want to issue an association command with non-zero status to
> > > cfg80211 instead of just knocking off the current authentication
> > > and killing the BSS?
> > 
> > Is the above sufficient? Btw, please don't talk about "killing the BSS",
> > you're not talking about a BSS struct but rather one of the mlme work
> > structs.
> 
> So, should this patch be dropped?  It is currently in w-t...

I'm still running the first w-t kernel with this fix
(master-2009-10-14), and haven't seen the sme warning I had been
complaining about for the past months, also: no connection drops.
Note I have _not_ run performance tests.

So this patch affects the sme issue. You guys will know where the
correct place is for fixing it.


By the way, (master-2009-10-14) is the best kernel for me since about
March/April this year. It looks like we're out of the rough again on
ath9k&mac80211.

Felix


