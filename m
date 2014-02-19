Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16283 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbaBSPT0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 10:19:26 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Subject: RE: [PATCH v3 4/6] cfg80211: Add an option to hint indoor operation
Date: Wed, 19 Feb 2014 15:18:38 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A0333824E3@HASMSX106.ger.corp.intel.com> (sfid-20140219_161930_109476_4BC26CCC)
References: <1390818118-27261-1-git-send-email-ilan.peer@intel.com>
 <1390818118-27261-5-git-send-email-ilan.peer@intel.com>
 <20140219000753.GD14296@garbanzo.do-not-panic.com>
In-Reply-To: <20140219000753.GD14296@garbanzo.do-not-panic.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 Hi Luis,

Thanks again,

Ilan.

> On Mon, Jan 27, 2014 at 12:21:56PM +0200, Ilan Peer wrote:
> > @@ -1450,6 +1465,11 @@ __reg_process_hint_user(struct
> > regulatory_request *user_request)  {
> >  	struct regulatory_request *lr = get_last_request();
> >
> > +	if (reg_request_indoor(user_request)) {
> > +		reg_is_indoor = true;
> > +		return REG_REQ_ALREADY_SET;
> 
> Please use another return value here and document it. This would enable
> other type of userspace hints and would not make this an obscure thing.
> 

Sure. This will require documenting the other return values as well .. hope I'll not make a mess.

> > @@ -2014,6 +2047,8 @@ static void restore_regulatory_settings(bool
> > reset_user)
> >
> >  	ASSERT_RTNL();
> >
> > +	reg_is_indoor = false;
> 
> :D
> 
> > +
> >  	reset_regdomains(true, &world_regdom);
> >  	restore_alpha2(alpha2, reset_user);
> >
> > @@ -2515,6 +2550,19 @@ int cfg80211_get_unii(int freq)
> >  	return -EINVAL;
> >  }
> >
> > +bool regulatory_ir_allowed(struct wiphy *wiphy, struct
> > +ieee80211_channel *chan) {
> > +	if (config_enabled(CONFIG_CFG80211_REG_RELAX_NO_IR) &&
> > +	    !(wiphy->regulatory_flags &
> REGULATORY_DISABLE_RELAX_NO_IR) &&
> 
> Don't you want to make the flag REGULATORY_DISABLE_RELAX_NO_IR
> positive, that is REGULATORY_ENABLE_RELAX_NO_IR as otherwise you'd
> require everyone to disable it by default. I think we want to *disable* it by
> default it and let drivers set it explicitly to declare support.
> 
> 

Sure ... will make it positive ... will fix the previous patches as well.

> > +	    reg_is_indoor && (chan->flags &
> IEEE80211_CHAN_INDOOR_ONLY))
> > +		return true;
> > +
> > +	if (chan->flags & IEEE80211_CHAN_NO_IR)
> > +		return false;
> > +	return true;
> > +}
> > +EXPORT_SYMBOL(regulatory_ir_allowed);
> 
> Please use EXPORT_SYMBOL_GPL() moving forward for regulatory core stuff.
> Proprietary drivers can kiss my hairy ass.
> 

With pleasure :)
