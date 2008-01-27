Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:46740 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759130AbYA0TTb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 14:19:31 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2516135wah.23
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jan 2008 11:19:28 -0800 (PST)
Message-ID: <1ba2fa240801271119m29a316eeib815facfbf2051e0@mail.gmail.com> (sfid-20080127_191944_486841_0222E98D)
Date: Sun, 27 Jan 2008 21:19:28 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Patrick McHardy" <kaber@trash.net>
Subject: Re: [RFC PATCH 06/10] mac80211: A-MPDU Tx adding qdisc support
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	yi.zhu@intel.com
In-Reply-To: <479CC590.7090406@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11999857423156-git-send-email-ron.rindjunsky@intel.com>
	 <11999857503421-git-send-email-ron.rindjunsky@intel.com>
	 <479CC590.7090406@trash.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 27, 2008 7:55 PM, Patrick McHardy <kaber@trash.net> wrote:
> Ron Rindjunsky wrote:
> > This patch allows qdisc support in A-MPDU Tx. This is not a complete
> > solution, but a general direction to handle QoS <-> TID switches
> >
> > Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> > ---
>
> > --- a/net/mac80211/wme.c
> > +++ b/net/mac80211/wme.c
> > @@ -19,10 +19,13 @@
> >  #include "wme.h"
> >
> >  /* maximum number of hardware queues we support. */
> > -#define TC_80211_MAX_QUEUES 8
> > +#define TC_80211_MAX_QUEUES 16
>
> Is there a reason to add new features to this instead of using
> the generic multiqueue support, moving classification to a
> classifier and killing wme?
>
Multiqueue is where we are heading to. We have developed this solution
before multiqueue was accepted and it worked well for few months
already so it can provide enough usability for 11n users for now.
We still have too many opens to close so we prefer to stage them
rather then choke on them. It will take few more weeks till we start
to work on it unless someone else take the lead of course.
Thanks
Tomas

>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
