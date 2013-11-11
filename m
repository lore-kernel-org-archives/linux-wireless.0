Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36346 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab3KKOlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 09:41:07 -0500
Message-ID: <1384180862.14334.25.camel@jlt4.sipsolutions.net> (sfid-20131111_154112_016322_FC8D2C98)
Subject: Re: [PATCH 05/19] cfg80211: processing core regulatory hints on its
 own
From: Johannes Berg <johannes@sipsolutions.net>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 11 Nov 2013 15:41:02 +0100
In-Reply-To: <CAGRGNgXdnwYnNYncPQGp=NNF1FxY3sFMSSf7arWYeX3v=PFAzw@mail.gmail.com> (sfid-20131107_014742_750163_B1BE1A20)
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
	 <1383671897-7746-6-git-send-email-mcgrof@do-not-panic.com>
	 <1383733459.14307.22.camel@jlt4.sipsolutions.net>
	 <CAB=NE6UuRf=Wsfe_uym1+r+Ay0eNoJKa6Fo1Hi0r-LA8wTddng@mail.gmail.com>
	 <CAGRGNgXdnwYnNYncPQGp=NNF1FxY3sFMSSf7arWYeX3v=PFAzw@mail.gmail.com>
	 (sfid-20131107_014742_750163_B1BE1A20)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-11-07 at 11:47 +1100, Julian Calaby wrote:

> >>> -     switch (__regulatory_hint(wiphy, reg_request)) {
> >>> +     switch (reg_request->initiator) {
> >>> +     case NL80211_REGDOM_SET_BY_CORE:
> >>> +             reg_process_hint_core(reg_request);
> >>> +             return;
> >
> > Note that for the core request we bail out early.
> >
> >>> +     case NL80211_REGDOM_SET_BY_USER:
> >>> +     case NL80211_REGDOM_SET_BY_DRIVER:
> >>> +     case NL80211_REGDOM_SET_BY_COUNTRY_IE:
> >>> +             treatment = __regulatory_hint(wiphy, reg_request);
> >>> +             break;
> >>> +     }
> >>> +
> >>> +     switch (treatment) {
> >>
> >> is used uninitialized here
> >
> > As I see it in the code we either bail early or its assigned to the
> > return value of __regulatory_hint() for the non-core case. Did I miss
> > something?
> 
> I think Johannes just wants you to assign something to it so that
> paranoid static checkers / compilers won't complain that it's unset in
> the potential case where we make it through the switch without hitting
> any of the cases. (Adding a default: case to the switch statement
> would also work, but as you've been very very careful to spell out all
> the cases here that'd tempt developers to remove all the careful
> spelling out in some crazed cleanup binge.)
> 
> Of course this will never happen if reg_request->initiator is an enum
> and all it's possible values are covered in the switch statement, but
> some compilers (and developers like me) need it spelled out for them.

Well actually I was just careless and didn't realize that it was
actually a false compiler warning :)

johannes

