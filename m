Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39138 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaF3WE3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2014 18:04:29 -0400
Received: by mail-pa0-f46.google.com with SMTP id eu11so9389757pac.33
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2014 15:04:29 -0700 (PDT)
Date: Mon, 30 Jun 2014 15:04:24 -0700
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/5] cfg80211: treat the special "unknown" alpha2 as valid
Message-ID: <20140630220424.GM1390@garbanzo.do-not-panic.com> (sfid-20140701_000433_468075_2E31BB18)
References: <1402469724-22358-1-git-send-email-arik@wizery.com>
 <1402469724-22358-3-git-send-email-arik@wizery.com>
 <CAB=NE6UZPcgAAJ6GAnjy2nSdYhLRqxo4h1ZZoZ7vYsAbYBiw+Q@mail.gmail.com>
 <CA+XVXfc=zDyie-3xO86k98zKQUZqDm0dEf9d5qMDAX83svfR_Q@mail.gmail.com>
 <20140623182333.GB1390@garbanzo.do-not-panic.com>
 <CA+XVXfe91Lcf2H1vEficPTNumdd2sBOR8KV8cD5tsy+po4M0mg@mail.gmail.com>
 <CAB=NE6Va7ynqAsRkgVQ1hCLMu6_Wco_=-Wa5dqrSzPMkA-pYeQ@mail.gmail.com>
 <CA+XVXfeTn99ZW9OzUQZNNaHLCMNipsubVP8CVLapWA8Z3oM4+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+XVXfeTn99ZW9OzUQZNNaHLCMNipsubVP8CVLapWA8Z3oM4+w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 24, 2014 at 09:09:41AM +0300, Arik Nemtsov wrote:
> On Mon, Jun 23, 2014 at 9:57 PM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
> > On Mon, Jun 23, 2014 at 11:32 AM, Arik Nemtsov <arik@wizery.com> wrote:
> >>> modifieres for user_reg_hint_type, you'd want a driver_reg_hint_type,
> >
> > Minor note, since the driver reg hint type can be require the
> > regulatory data source to be internal to the driver (firmware or
> > driver, we won't know) and since the new API can allow the
> > driver/firmware to pass and let the request come from CRDA /
> > wireless-regdb / internal db the driver hint is different from the
> > final *set* regulatory domain. So for example although the goal was to
> > query firmware first if the driver passed and let the source of
> > regulatory data come from CRDA / wireless-regdb / internal regdb we'd
> > want to ensure userspace is informed of this. So I think we'd need a
> > regulatory data structure source type as well, right now it'd default
> > to wireless-regdb as the source (that would suffice for CRDA or
> > internal-db), and your changes would add an internal-driver source.
> 
> Sure I can add a source to the regulatory_request structure. It will
> have something like CORE, CRDA, INTERNAL_REGDB, DRIVER.

OK.

> > Since this is allowing drivers to be explicit about their regulatory
> > data it would be nice if as part of this we can then get 'iw reg get'
> > the ability to then spit out per wiphy regd. Since even the custom
> > regd requires passing a custom regd this could even enable parsing
> > that data as well. This should make trouble shooting for intersections
> > much easier on complex systems.
> 
> This would have to wait a bit on my side.

OK.

  Luis
