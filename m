Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbaFKUto (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 16:49:44 -0400
Date: Wed, 11 Jun 2014 22:49:43 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [wireless-regdb] [RFC 1/2] crda: simplify text parsing for
	country/rules
Message-ID: <20140611204943.GF6042@wotan.suse.de> (sfid-20140611_224948_012984_1BB7DB4B)
References: <1402385153-5056-1-git-send-email-janusz.dziedzic@tieto.com> <CAB=NE6VZs7d2bJNW0cp7NhPUMKr=bHn+pKwhvtk2U71rno4VMA@mail.gmail.com> <CALhHN=rzHzSr67W9KoC8u5cARrckOgQA-m26fmhXwX85aEcKoA@mail.gmail.com> <CAB=NE6VwBB-_G6JfLo81PYsjxBbw+C4Y40ZogNh4-eG910rXuw@mail.gmail.com> <CALhHN=pTSRC=k8-Rx3xFQT3b+tydnDMRiSHB4goC50KyZOxwbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALhHN=pTSRC=k8-Rx3xFQT3b+tydnDMRiSHB4goC50KyZOxwbg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2014 at 12:24:17PM +0200, Janusz Dziedzic wrote:
> On 11 June 2014 10:49, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> > On Tue, Jun 10, 2014 at 10:03 PM, Janusz Dziedzic
> > <janusz.dziedzic@tieto.com> wrote:
> >> On 11 June 2014 00:09, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> >>> On Tue, Jun 10, 2014 at 12:25 AM, Janusz Dziedzic
> >>> <janusz.dziedzic@tieto.com> wrote:
> >>>> Remove strange parsers.
> >>>>
> >>>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> >>>
> >>> Did you test this with the different types of accepted rules?
> >>>
> >>
> >> Tested with current db.txt (+AUTO-BW in some cases).
> >
> > I was curious more about the different use cases of the output power,
> > sometimes we use dBm, sometimes mW I think. I think I tried your
> > approach and ended up getting inconsistent results for the different
> > cases, so that's why all the parser junk got added. If you found a way
> > to successfully get rid of it though that's awesome, just want to be
> > sure we tested all cases. I purposely tried to upkeep the output to
> > match the input preference, some folks are picky about mW and others
> > like dB, this helps with regulatory rules as they vary depending on
> > the country and the country typically uses one or the other for the
> > definitions.
> >
> 
> As a required I assume:
> "\t(%f - %f @ %f), (%f mW)" or
> "\t(%f - %f @ %f), (%f)"
> Rest are optional.
> 
> This is the code for eirp:
> 
>        /* Next get eirp */
>        strsep(&line_p, ",");
>        if (!line_p) {
>                fprintf(stderr, "not found eirp in line: %s\n", line);
>                return -EINVAL;
>         }
> 
>        if (strstr(line_p, "mW")) {
>                hits = sscanf(line_p, " (%f mW)", &max_eirp);
>                if (hits != 1)
>                        return -EINVAL;
>                reg_rule->power_rule.max_eirp =
>                        REGLIB_MW_TO_MBM(max_eirp);
>        } else {
>                hits = sscanf(line_p, " (%f)", &max_eirp);
>                if (hits != 1)
>                        return -EINVAL;
>                reg_rule->power_rule.max_eirp =
>                        REGLIB_DBM_TO_MBM(max_eirp);
>        }
> 
> 
> I see DE have mW (input and db2rd output):
> 
> db.txt input
> country DE: DFS-ETSI
>         # entries 279004 and 280006
>         (2400 - 2483.5 @ 40), (100 mW)
>         # entry 303005, 304002 and 305002
>         (5150 - 5350 @ 80), (100 mW), NO-OUTDOOR
>         # entries 308002, 309001 and 310003
>         (5470 - 5725 @ 80), (500 mW), DFS
>         # 60 gHz band channels 1-4, ref: Etsi En 302 567
>         (57240 - 65880 @ 2160), (40), NO-OUTDOOR
> 
> db2rd < db.txt output
> country DE: DFS-ETSI
>         (2400.000 - 2483.500 @ 40.000), (20.00)
>         (5150.000 - 5350.000 @ 80.000), (20.00), NO-OUTDOOR
>         (5470.000 - 5725.000 @ 80.000), (26.98), DFS
>         (57240.000 - 65880.000 @ 2160.000), (40.00), NO-OUTDOOR
> 
> Do you remember some cases where this couldn't work?

I checked and it seems fine, I thikn I failed to just if and else
for a secondary check, looks good to me, can you resend and also
address any discrepancies on CRDA git tree with what should be
there since I did merge the AUTO patches already, if those need
reverting please specify, otherwise we'll need the parser to also
support that.

  Luis
