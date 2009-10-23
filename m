Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbZJWQaW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 12:30:22 -0400
Subject: Re: [PATCH 17/19] [RFC, v2] libertas: Kconfig entry for
 libertas+cfg80211
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200910231756.47472.hs4233@mail.mn-solutions.de>
References: <20091022133043.185554096@mail.mn-solutions.de>
	 <20091022133425.317619132@mail.mn-solutions.de>
	 <1256307572.12174.33.camel@johannes.local>
	 <200910231756.47472.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Fri, 23 Oct 2009 09:30:15 -0700
Message-Id: <1256315415.2164.46.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-10-23 at 17:56 +0200, Holger Schurig wrote:
> On Friday 23 October 2009 16:19:31 Johannes Berg wrote:
> > On Thu, 2009-10-22 at 15:31 +0200, Holger Schurig wrote:
> > 
> > > +#ifdef CONFIG_LIBERTAS_WEXT
> > >  	dev->ethtool_ops = &lbs_ethtool_ops;
> > >  	dev->wireless_handlers = &lbs_handler_def;
> > >  #endif
> > 
> > So here you make the wireless_handlers optional.
> > 
> > I still don't understand why you can't just replace only some 
> of the
> > handlers, i.e. instead of doing this, simply do
> > 
> > -	(iw_handler) lbs_set_freq,      /* SIOCSIWFREQ */
> > +	(iw_handler) cfg80211_wext_siwfreq,
> > 
> > etc.
> > 
> > That's why those exist and are exported. And that way you don't
> > need the Kconfig at all, and can remove most of the wext code.
> 
> The Kconfig has *NOTHING* to do with mesh.
> 
> MESH should be implemented via add_virtual_intf() / 
> change_virtual_intf(). This code isn't there yet, mesh_dev is 
> always NULL in the CONFIG_LIBERTAS_CFG80211 case, so there's no 
> need to export anything to ethtool or WEXT.
> 
> And having cfg80211 + (mesh_dev != NULL) is something that
> I cannot program, due to (sigh) missing hardware, time,
> testing ability. Repeat rinse wash, repeat rinse wash ...
> 
> 
> Okay, I now stop talking about this. Please talk with Dan about 
> the matter. He knows cfg80211 and libertas probably better than 
> I. Once you two have found a decision, I'm looking if I'm still 
> interested.

Please keep going :)  At this point, you likely understand cfg80211
better than I do.  And as I"ve commented in a few other mails this
morning, I don't think it'll be as complex as I thought it was earlier.

Dan


