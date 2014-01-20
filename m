Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60053 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaATMEn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 07:04:43 -0500
Message-ID: <1390219480.4335.25.camel@jlt4.sipsolutions.net> (sfid-20140120_130446_975886_22D52CD4)
Subject: Re: [PATCH 4/5] cfg80211: introduce strict bandwidth regulatory flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 20 Jan 2014 13:04:40 +0100
In-Reply-To: <CALhHN=q9ZwMEo2xzPtAqkk0oGri+oQ=G4w2KRAvATaB=hc31yw@mail.gmail.com> (sfid-20140120_130228_984395_F4F3A6C1)
References: <1389947524-6102-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1389947524-6102-5-git-send-email-janusz.dziedzic@tieto.com>
	 <1390215337.4335.11.camel@jlt4.sipsolutions.net>
	 <CALhHN=q9ZwMEo2xzPtAqkk0oGri+oQ=G4w2KRAvATaB=hc31yw@mail.gmail.com>
	 (sfid-20140120_130228_984395_F4F3A6C1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-20 at 13:02 +0100, Janusz Dziedzic wrote:
> On 20 January 2014 11:55, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Fri, 2014-01-17 at 09:32 +0100, Janusz Dziedzic wrote:
> >> Introduce NL80211_RRF_STRICT_BW regulatory rule flag.
> >> This mean we will check only banwidth defined in
> >> regulatory database and not check contiguous rules.
> >
> > If you meant for this to alleviate my concerns about crda/db.txt
> > compatibility, you didn't do it right. This has no value whatsoever
> > since it still breaks things.
> >
> 
> So, maybe better introduce opposite logic here. By default always
> calculate BW as STRICT_BW - be backwards compatible with current
> crda/db.txt implementation/calculation.
> And introduce WIDE(LOOSE)_BW flag for the rules we would like
> calculate maximum bandwidth using contiguous rules?

Yeah I suppose that'd work. I think it doesn't even need to be a rule
flag, but rather a country flag?

johannes

