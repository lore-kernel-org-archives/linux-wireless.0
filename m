Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60411 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbZJPSbM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 14:31:12 -0400
Date: Fri, 16 Oct 2009 14:20:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ic.felix@gmail.com" <ic.felix@gmail.com>
Subject: Re: [PATCH] mac80211: fix SME warning by removing stale BSS upon
	assoc failure
Message-ID: <20091016182039.GC6438@tuxdriver.com>
References: <1255481442-27130-1-git-send-email-lrodriguez@atheros.com> <1255562895.4095.297.camel@johannes.local> <20091014233528.GA4172@tux> <1255685492.4095.309.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1255685492.4095.309.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 16, 2009 at 06:31:32PM +0900, Johannes Berg wrote:
> On Wed, 2009-10-14 at 16:35 -0700, Luis R. Rodriguez wrote:
> 
> > Well sure, but why do we want to keep the authentication present if
> > association failed? And as a matter of fact it lingers there forever.
> > Is that desired behaviour?
> 
> Yes, well, the SME is supposed to clean it up or try the association
> again (possibly with different parameters in the IEs, e.g. different WPA
> settings). The cfg80211 SME certainly does so (it deauthenticates).
> 
> > > > +++ b/net/mac80211/mlme.c
> > > > @@ -1463,11 +1463,11 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
> > > >  	if (status_code != WLAN_STATUS_SUCCESS) {
> > > >  		printk(KERN_DEBUG "%s: AP denied association (code=%d)\n",
> > > >  		       sdata->dev->name, status_code);
> > > >  		list_del(&wk->list);
> > > >  		kfree(wk);
> > > > -		return RX_MGMT_CFG80211_ASSOC;
> > > > +		return RX_MGMT_CFG80211_DEAUTH;
> > > 
> > > I'm sure this is correct. Maybe cfg80211 doesn't react properly to
> > > getting an assoc frame with non-zero status?
> > 
> > I see, will have to take a look when I get a chance then, not now though.
> 
> > Actually can you elaborate a little on the logic here as to why
> > we want to issue an association command with non-zero status to
> > cfg80211 instead of just knocking off the current authentication
> > and killing the BSS?
> 
> Is the above sufficient? Btw, please don't talk about "killing the BSS",
> you're not talking about a BSS struct but rather one of the mlme work
> structs.

So, should this patch be dropped?  It is currently in w-t...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
