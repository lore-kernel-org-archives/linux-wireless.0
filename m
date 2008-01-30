Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.231]:63116 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbYA3QZp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2008 11:25:45 -0500
Received: by wr-out-0506.google.com with SMTP id c48so227939wra.23
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2008 08:25:44 -0800 (PST)
Message-ID: <1ba2fa240801300825ye9cc0f1re9880b57bb48c95@mail.gmail.com> (sfid-20080130_162550_414119_23B7BF8B)
Date: Wed, 30 Jan 2008 18:25:43 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Jory A. Pratt" <geekypenguin@gmail.com>
Subject: Re: should we revert the cfg80211 API patches?
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	"Michael Buesch" <mb@bu3sch.de>
In-Reply-To: <47A0A2F9.3020400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1201708352.4149.21.camel@johannes.berg>
	 <47A0A2F9.3020400@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 30, 2008 6:16 PM, Jory A. Pratt <geekypenguin@gmail.com> wrote:
>
> Johannes Berg wrote:
> > John,
> >
> > It appears that there's more trouble caused by my cfg80211 band API
> > patch than people are willing to put up with. Tomas has already asked
> > for it to be reverted, and neither Michael (Buesch) nor Stefano want to
> > maintain two driver branches (one "stable" 2.6.25 branch and one
> > "development" "for the future" branch).
> >
> > FWIW, I support your decision to not push this particular patch for
> > 2.6.25, it really doesn't fall into the "tested well enough to merge
> > during merge window" category.
> >
> > Additionally, since Michael Wu has (privately) announced to stop working
> > on wireless, a number of drivers are effectively unmaintained now and
> > I'm not sure I can quickly fix the breakage that my patch probably
> > caused in those drivers, especially since Michael Wu is the only
> > developer with access to all that hardware.
> >
> > To ease the short term pain, we can remove/revert the commits in
> > question (those being 51c4c94e89a2042e8b20d640b49b6b605d71420d,
> > 6854a5291cce341751a7e2e195cc3e97d95afeec and
> > d0776155b288c20cc936bfd87d9a76255f244ed8).
> >
> > Maybe I should have waited longer or posted the patches earlier. I
> > didn't post them earlier because I had not wanted to disrupt Intel's
> > iwlwifi work too much knowing that there were patches, and then those
> > patches caused bad breakage with my patch so I had to wait for another
> > Intel patchset fixing a number of bugs they introduced... I'll admit
> > that timing was horrible.
> >
> > But, I'll be frank, if the patches are removed/revert I probably won't
> > continue maintaining them. I can't do much with these patches but
> > continually forward port them on top of new driver changes which is
> > boring and useless work. Experience has shown that hardly anybody but me
> > [1] actually tests my patches until I push them into your tree, so
> > continuing to forward port these patches won't actually help them become
> > better but can only make sure they don't completely bitrot into
> > oblivion.
> >
> > The only way forward I see if these patches are reverted is that we
> > announce with the reversion that we'll merge them again in N weeks (with
> > N being a reasonably small number, say 4-6) and until then people can
> > test the patches and send me driver updates that I'll incorporate. But I
> > don't see how useful that is vs. just leaving the patches in place and
> > you managing the required driver updates.
> >
> > johannes
> >
> > [1] the only other people who test it seem to be mostly clueless people
> > who want to get AP mode working and then ask me stupid questions in
> > private... there are exceptions of course
> >
> Reverting the patch is not the answer. Everyone just needs to step up
> and fix what they can. If maintainers are needed a call needs to be put
> out to find one.
> The work is in the direction that moves wireless in linux toward that of
> a windows machine that the users want and need.

Agree.
Just, the timing was unfortunate.
Tomas

> -Jory
>
