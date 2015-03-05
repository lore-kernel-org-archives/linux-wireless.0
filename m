Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38389 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbbCEWob (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 17:44:31 -0500
Date: Thu, 5 Mar 2015 23:44:29 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ArikX Nemtsov <arik@wizery.com>
Subject: Re: [PATCH v9 2/3] cfg80211: Add API to change the indoor regulatory
 setting
Message-ID: <20150305224429.GA25035@wotan.suse.de> (sfid-20150305_234437_202177_BAC0B154)
References: <1425189749-15271-1-git-send-email-ilan.peer@intel.com>
 <1425189749-15271-2-git-send-email-ilan.peer@intel.com>
 <20150302212232.GW8749@wotan.suse.de>
 <CB3B3D4774441E42AA3EA0E1BA8230A04D02863A@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A04D02863A@HASMSX106.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 04, 2015 at 10:37:35AM +0000, Peer, Ilan wrote:
> 
> > -----Original Message-----
> > From: Luis R. Rodriguez [mailto:mcgrof@suse.com]
> > Sent: Monday, March 02, 2015 23:23
> > To: Peer, Ilan
> > Cc: linux-wireless@vger.kernel.org; ArikX Nemtsov
> > Subject: Re: [PATCH v9 2/3] cfg80211: Add API to change the indoor
> > regulatory setting
> > 
> > On Sun, Mar 01, 2015 at 01:02:28AM -0500, Ilan Peer wrote:
> > > diff --git a/net/wireless/reg.c b/net/wireless/reg.c index
> > > c24c8bf..f88d512 100644
> > > --- a/net/wireless/reg.c
> > > +++ b/net/wireless/reg.c
> > > @@ -128,9 +128,12 @@ static int reg_num_devs_support_basehint;
> > >   * State variable indicating if the platform on which the devices
> > >   * are attached is operating in an indoor environment. The state variable
> > >   * is relevant for all registered devices.
> > > - * (protected by RTNL)
> > >   */
> > >  static bool reg_is_indoor;
> > > +static spinlock_t reg_indoor_lock;
> > > +
> > > +/* Used to track the userspace process controlling the indoor setting
> > > +*/ static u32 reg_is_indoor_portid;
> > >
> > >  static const struct ieee80211_regdomain *get_cfg80211_regdom(void)  {
> > > @@ -2288,15 +2291,52 @@ int regulatory_hint_user(const char *alpha2,
> > >  	return 0;
> > >  }
> > >
> > > -int regulatory_hint_indoor_user(void)
> > > +int regulatory_hint_indoor(bool is_indoor, u32 portid)
> > >  {
> > > +	spin_lock(&reg_indoor_lock);
> > > +
> > > +	/* Other user space processes cannot override the current owner */
> > > +	if (reg_is_indoor_portid && reg_is_indoor_portid != portid) {
> > > +		spin_unlock(&reg_indoor_lock);
> > > +		return -EPERM;
> > > +	}
> > 
> > I am not satisfied with this solution to conflict. I don't want to think about the
> > solution to this for you -- please address the conflicts with sensible solutions.
> > 
> 
> We could always allow the any user space process to set indoor=0, i.e.,
> indoor=1 is allowed iff all user space process agree on it.

That makes sense if for indoor we tend to have a more liberal
regulatory settings. Do we know this for sure? That is, are
we more restrictive outdoors? Does that vary by country?

> > > +
> > > +	if (reg_is_indoor == is_indoor) {
> > > +		spin_unlock(&reg_indoor_lock);
> > > +		return 0;
> > > +	}
> > 
> > For instance this is a solution to agreement, but yet the above only allows for
> > one wiphy to set this setting and limiting the wireless core. That's rather silly.
> > We've addressed bigger conflicts than this for regulatory -- I have confidence
> > you can address this well.
> 
> This should not really be wiphy specific.

Sorry I meant supplicant specific.

 Luis
