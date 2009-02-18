Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32178 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518AbZBRWVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 17:21:17 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 18 Feb 2009 14:21:17 -0800
Date: Wed, 18 Feb 2009 14:20:30 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 00/15] cfg80211: add a workqueue for regulatory
	processing
Message-ID: <20090218222030.GF4246@tesla> (sfid-20090218_232122_502942_C3ABDB89)
References: <1234930922-29367-1-git-send-email-lrodriguez@atheros.com> <20090218221824.GB3953@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20090218221824.GB3953@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 18, 2009 at 02:18:24PM -0800, John W. Linville wrote:
> On Tue, Feb 17, 2009 at 08:21:47PM -0800, Luis R. Rodriguez wrote:
> > This series has a few cleanups and minor fixes but mainly
> > adds a workqueue for cfg80211 to use to process all regulatory
> > hints. This v3 changes _all_ regulatory hints to use this
> > workqueue.
> >
> > I've combined this series with my later one that had only 3 patches=
=2E
> >
> > This series is also rebased on today's pull of wl.
> >
> > Luis R. Rodriguez (15):
> >   cfg80211: rename cfg80211_registered_device's idx to wiphy_idx
> >   cfg80211: add wiphy_idx_valid to check for wiphy_idx sanity
> >   cfg80211: rename cfg80211_drv_mutex to cfg80211_mutex
> >   nl80211: disallow user requests prior to regulatory_init()
> >   cfg80211: add regulatory_hint_core() to separate the core reg hin=
t
> >   cfg80211: propagate -ENOMEM during regulatory_init()
> >   cfg80211: add assert_cfg80211_lock() to ensure proper protection
> >   cfg80211: make regulatory_request use wiphy_idx instead of wiphy
> >   cfg80211: protect first access of last_request on 11d hint under
> >     mutex
> >   cfg80211: remove likely from an 11d hint case
> >   cfg80211: free rd on unlikely event on 11d hint
> >   cfg80211: move all regulatory hints to workqueue
> >   cfg80211: comments style cleanup
> >   cfg80211: allow drivers that agree on regulatory to agree
> >   cfg80211: rename regdom_changed to regdom_changes() and use it
>=20
> Not sure what happened, but all I got was this:
>=20
>  271   T Feb 17 Luis R. Rodrigu (  44) [PATCH v3 00/15] cfg80211: add=
 a workqueue for regulatory processing
>  272 O T Feb 17 Luis R. Rodrigu (   0) =E2=94=9C=E2=94=80>[PATCH v3 0=
4/15] nl80211: disallow user requests prior to regulatory_init()
>  273 O T Feb 17 Luis R. Rodrigu (   0) =E2=94=9C=E2=94=80>[PATCH v3 0=
5/15] cfg80211: add regulatory_hint_core() to separate the core reg hin=
t
>  274 O T Feb 17 Luis R. Rodrigu (   0) =E2=94=9C=E2=94=80>[PATCH v3 0=
6/15] cfg80211: propagate -ENOMEM during regulatory_init()
>  275 O T Feb 17 Luis R. Rodrigu (   0) =E2=94=9C=E2=94=80>[PATCH v3 1=
0/15] cfg80211: remove likely from an 11d hint case
>  276 O T Feb 17 Luis R. Rodrigu (   0) =E2=94=94=E2=94=80>[PATCH v3 1=
4/15] cfg80211: allow drivers that agree on regulatory to agree
>=20
> Would you mind resending (at least to my address)?

Sorry about that... Microsoft Exchange 2007 happened. Will resend from =
a less buggy
SMTP somewhere.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
