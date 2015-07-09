Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:36113 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbbGIPQp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 11:16:45 -0400
Received: by obdbs4 with SMTP id bs4so173806399obd.3
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 08:16:44 -0700 (PDT)
Date: Thu, 9 Jul 2015 10:15:55 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: wireless-regdb <wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless-regdb: Update regulatory rules for Taiwan (TW)
Message-ID: <20150709151555.GB142895@ubuntu-hedt> (sfid-20150709_171648_728650_6E1C08C7)
References: <1436256435-25048-1-git-send-email-wens@csie.org>
 <20150707205418.GC369@ubuntu-xps13>
 <CAGb2v67gw=Z32fLGzKP2S0OGf-fQPhCLEZdt4v5yZuRAvSis7g@mail.gmail.com>
 <CAGb2v65qjqLEaChkQDNYaZY7dnA3=DVVrAKQnR-wtggKQj5_+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGb2v65qjqLEaChkQDNYaZY7dnA3=DVVrAKQnR-wtggKQj5_+g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 08, 2015 at 11:07:20AM +0800, Chen-Yu Tsai wrote:
> > Thanks. I think there should be a written document about what the
> > rules should be like, or what is expected:
> >
> >   1. WiFi channel boundaries or band boundaries
> >   2. peak output power or peak power spectral density
> >
> > In http://lists.infradead.org/pipermail/wireless-regdb/2015-July/000856.html
> > you mentioned the software is smart enough to work out how to combine
> > different bands and what channels to use, so I see no reason to explicitly
> > chop up contiguous spectrum, unless there are explicit rules forbidding
> > combined use of bands with different regulatory rules. AFAIK the FCC
> > only requires one to satisfy all rules when usage crosses band boundaries.
> >
> > http://lists.infradead.org/pipermail/wireless-regdb/2015-July/000857.html
> > also raises a similar question.

I was really commenting about the transmit power updates in your patch.
I just compared the frequency changes to the documentation you linked to
and those do look okay to me.

> >> I would however consider an update for 5.15-5.25 GHz and 5.6-5.65 GHz
> >> provided that there's official documentation to substantiate the change.
> >> I unfortunately cannot read Chinese, so I would need some assistance to
> >> confirm the documentation.
> >
> > I could possibly ask around, though I'm not optimistic. The "official"
> > documents are just transcripts from NCC hosted Q&A sessions regarding
> > the latest regulations. Proposals/questions are submitted by vendors,
> > and the NCC responds and puts together an aggregated transcript.
> 
> Just got off the phone with the NCC. Their position is, spectrum allocation
> is not within their purview, but the Ministry of Transportation and
> Communications. As noted in the patch, they have already opened up the
> spectrum to U-NII and low power radio usage. What remains is that the
> NCC revise its testing standards. Until then, their position is that,
> since their testing standards are modeled after FCC standards, vendors
> can just test under FCC standards, then convert the reports into LP0002
> format, and cite the FCC test report.
> 
> There is no formal English version of the Q&A transcript, at least not
> until some foreign testing body requests it. The person in charge just
> asked me to translate it myself...

If you send a patch which updates only the frequencies I would likely
apply that after allowing a week or so for others to either ack or nack
it (and running the stuff you linked to through google translate and
seeing if I could make any sense of the output).

I think the power updates are probably based on a misunderstanding, and
may not even be completely correct. For the most part after they've been
converted to EIRP (eirp = 10 * log10(mW)) they don't turn out to be
substantially different than what we have now. I think the value in
5250-5350 MHz is probably incorrect however. Based on my quick skim of
the document you linked to it should be 50 mW rather than 250. 50 mW
also roughly matches to the 17 dBm which is in the database today,
whereas 250 mW is closer to 24 dBm.

My suggestion would be update the frequencies but not the existing
transmit power limits, unless you discover that any of the power limits
are definitely incorrect.

Thanks,
Seth
