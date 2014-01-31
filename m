Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53420 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbaAaUEj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 15:04:39 -0500
Message-ID: <1391198672.4141.26.camel@jlt4.sipsolutions.net> (sfid-20140131_210442_786147_616B3BD8)
Subject: Re: [PATCH v4] cfg80211: regulatory introduce maximum bandwidth
 calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 31 Jan 2014 21:04:32 +0100
In-Reply-To: <CALhHN=pWfrsY5HEuXRoAvr=k0VDNAfm=yrk3jF2-qiC-j6gB8A@mail.gmail.com> (sfid-20140131_171848_718946_F1166EA6)
References: <1391071940-4296-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1391177274.4141.21.camel@jlt4.sipsolutions.net>
	 <CALhHN=pWfrsY5HEuXRoAvr=k0VDNAfm=yrk3jF2-qiC-j6gB8A@mail.gmail.com>
	 (sfid-20140131_171848_718946_F1166EA6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-01-31 at 17:18 +0100, Janusz Dziedzic wrote:
> On 31 January 2014 15:07, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Thu, 2014-01-30 at 09:52 +0100, Janusz Dziedzic wrote:
> >
> > I'll apply this, but I think we should think about this:
> >
> >> @@ -950,11 +1027,18 @@ static void handle_channel(struct wiphy *wiphy,
> >
> >> +     max_bandwidth_khz = freq_range->max_bandwidth_khz;
> >> +     /* Check if auto calculation requested */
> >> +     if (!max_bandwidth_khz) {
> >> +             regd = reg_get_regdomain(wiphy);
> >> +             max_bandwidth_khz = reg_get_max_bandwidth(regd, reg_rule);
> >> +     }
> >
> > It seems rather odd to have to look up the regdomain here, when we
> > actually came from a regdomain update originally. Or didn't we?
> >
> In the handle_channel() function we don't know regd.
> 
> reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq));

Yeah I thought we had it in the callers, maybe not then.

johannes

