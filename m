Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:42268 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbaAZWME convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jan 2014 17:12:04 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Subject: RE: [PATCH v2 4/6] cfg80211: Add an option to hint indoor operation
Date: Sun, 26 Jan 2014 22:11:55 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A03336BCAF@HASMSX106.ger.corp.intel.com> (sfid-20140126_231208_905338_ACDFF313)
References: <1389801162-14488-1-git-send-email-ilan.peer@intel.com>
 <1389801162-14488-5-git-send-email-ilan.peer@intel.com>
 <20140125002002.GB28512@garbanzo.do-not-panic.com>
In-Reply-To: <20140125002002.GB28512@garbanzo.do-not-panic.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks again,

Ilan.

> > +/*
> > + * State variable indicating if the platform on which the devices
> > + * are attached is operating in an indoor environment. The state
> > +variable
> > + * is relevant for all registered devices.
> > + * Note: currently not protected by any synchronization primitive.
> > + */
> > +static bool reg_is_indoor;
> > +
> 
> See if it makes sense to instead start building up a single reg data structure
> that has a slew of members. That's welcomed as a separate patch later...
>

Sure. Will have a look at this.
 
> > @@ -1475,6 +1493,11 @@ reg_process_hint_user(struct
> regulatory_request *user_request)
> >  		return treatment;
> >  	}
> >
> > +	if (reg_request_indoor(user_request) && treatment ==
> REG_REQ_OK) {
> > +		reg_is_indoor = true;
> > +		return REG_REQ_OK;
> > +	}
> > +
> 
> Are you setting this to false when we disconnect (reset regulatory)?
> You should.
> 

I wasn't. Fixing.

> > @@ -1658,9 +1681,6 @@ static void reg_process_hint(struct
> regulatory_request *reg_request)
> >  	struct wiphy *wiphy = NULL;
> >  	enum reg_request_treatment treatment;
> >
> > -	if (WARN_ON(!reg_request->alpha2))
> > -		return;
> > -
> 
> last_request checks for the alpha2 are abundent... you'd have to go review
> such use cases... One strategy might be to not treat this as a pure regulatory
> request but rather a hint of information, ie, not override last_request for this
> type of request.

Actually, when the hint is processed, REG_REQ_ALREADY_SET is returned, so the request is immedialty freed, and the last request is not updated. I thought that this should suffice. Do you see any other issue with this?

> > +#endif /* CONFIG_CFG80211_REG_SOFT_CONFIGURATIONS */
> 
> config_enabled() would make this look sexier.

Fixing ..

> 
> > @@ -2502,6 +2551,8 @@ int __init regulatory_init(void)
> >  	user_alpha2[0] = '9';
> >  	user_alpha2[1] = '7';
> >
> > +	reg_is_indoor = false;
> 
> Yeah this is not needed as during init this will be false, but you do want to
> ensure you set this to flase during reset of regulatory.
> 
>   Luis
