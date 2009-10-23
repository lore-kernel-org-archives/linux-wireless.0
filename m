Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:2984 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbZJWP5M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 11:57:12 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 17/19] [RFC, v2] libertas: Kconfig entry for libertas+cfg80211
Date: Fri, 23 Oct 2009 17:56:47 +0200
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
References: <20091022133043.185554096@mail.mn-solutions.de> <20091022133425.317619132@mail.mn-solutions.de> <1256307572.12174.33.camel@johannes.local>
In-Reply-To: <1256307572.12174.33.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910231756.47472.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 October 2009 16:19:31 Johannes Berg wrote:
> On Thu, 2009-10-22 at 15:31 +0200, Holger Schurig wrote:
> 
> > +#ifdef CONFIG_LIBERTAS_WEXT
> >  	dev->ethtool_ops = &lbs_ethtool_ops;
> >  	dev->wireless_handlers = &lbs_handler_def;
> >  #endif
> 
> So here you make the wireless_handlers optional.
> 
> I still don't understand why you can't just replace only some 
of the
> handlers, i.e. instead of doing this, simply do
> 
> -	(iw_handler) lbs_set_freq,      /* SIOCSIWFREQ */
> +	(iw_handler) cfg80211_wext_siwfreq,
> 
> etc.
> 
> That's why those exist and are exported. And that way you don't
> need the Kconfig at all, and can remove most of the wext code.

The Kconfig has *NOTHING* to do with mesh.

MESH should be implemented via add_virtual_intf() / 
change_virtual_intf(). This code isn't there yet, mesh_dev is 
always NULL in the CONFIG_LIBERTAS_CFG80211 case, so there's no 
need to export anything to ethtool or WEXT.

And having cfg80211 + (mesh_dev != NULL) is something that
I cannot program, due to (sigh) missing hardware, time,
testing ability. Repeat rinse wash, repeat rinse wash ...


Okay, I now stop talking about this. Please talk with Dan about 
the matter. He knows cfg80211 and libertas probably better than 
I. Once you two have found a decision, I'm looking if I'm still 
interested.

-- 
http://www.holgerschurig.de
