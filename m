Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63977 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758449AbbCDKhk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 05:37:40 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ArikX Nemtsov" <arik@wizery.com>
Subject: RE: [PATCH v9 2/3] cfg80211: Add API to change the indoor
	regulatory setting
Date: Wed, 4 Mar 2015 10:37:35 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A04D02863A@HASMSX106.ger.corp.intel.com> (sfid-20150304_113745_128121_1B5C392A)
References: <1425189749-15271-1-git-send-email-ilan.peer@intel.com>
 <1425189749-15271-2-git-send-email-ilan.peer@intel.com>
 <20150302212232.GW8749@wotan.suse.de>
In-Reply-To: <20150302212232.GW8749@wotan.suse.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> -----Original Message-----
> From: Luis R. Rodriguez [mailto:mcgrof@suse.com]
> Sent: Monday, March 02, 2015 23:23
> To: Peer, Ilan
> Cc: linux-wireless@vger.kernel.org; ArikX Nemtsov
> Subject: Re: [PATCH v9 2/3] cfg80211: Add API to change the indoor
> regulatory setting
> 
> On Sun, Mar 01, 2015 at 01:02:28AM -0500, Ilan Peer wrote:
> > diff --git a/net/wireless/reg.c b/net/wireless/reg.c index
> > c24c8bf..f88d512 100644
> > --- a/net/wireless/reg.c
> > +++ b/net/wireless/reg.c
> > @@ -128,9 +128,12 @@ static int reg_num_devs_support_basehint;
> >   * State variable indicating if the platform on which the devices
> >   * are attached is operating in an indoor environment. The state variable
> >   * is relevant for all registered devices.
> > - * (protected by RTNL)
> >   */
> >  static bool reg_is_indoor;
> > +static spinlock_t reg_indoor_lock;
> > +
> > +/* Used to track the userspace process controlling the indoor setting
> > +*/ static u32 reg_is_indoor_portid;
> >
> >  static const struct ieee80211_regdomain *get_cfg80211_regdom(void)  {
> > @@ -2288,15 +2291,52 @@ int regulatory_hint_user(const char *alpha2,
> >  	return 0;
> >  }
> >
> > -int regulatory_hint_indoor_user(void)
> > +int regulatory_hint_indoor(bool is_indoor, u32 portid)
> >  {
> > +	spin_lock(&reg_indoor_lock);
> > +
> > +	/* Other user space processes cannot override the current owner */
> > +	if (reg_is_indoor_portid && reg_is_indoor_portid != portid) {
> > +		spin_unlock(&reg_indoor_lock);
> > +		return -EPERM;
> > +	}
> 
> I am not satisfied with this solution to conflict. I don't want to think about the
> solution to this for you -- please address the conflicts with sensible solutions.
> 

We could always allow the any user space process to set indoor=0, i.e., indoor=1 is allowed iff all user
space process agree on it.

> > +
> > +	if (reg_is_indoor == is_indoor) {
> > +		spin_unlock(&reg_indoor_lock);
> > +		return 0;
> > +	}
> 
> For instance this is a solution to agreement, but yet the above only allows for
> one wiphy to set this setting and limiting the wireless core. That's rather silly.
> We've addressed bigger conflicts than this for regulatory -- I have confidence
> you can address this well.

This should not really be wiphy specific.

Regards,

Ilan.

