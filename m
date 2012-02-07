Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51550 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2BGUiU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 15:38:20 -0500
Received: by iacb35 with SMTP id b35so10589739iac.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2012 12:38:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120207195415.GG5560@tuxdriver.com>
References: <87pqgkxn25.fsf@nemi.mork.no> <20111128181912.GB2681@tuxdriver.com>
 <20120207195415.GG5560@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 7 Feb 2012 12:37:59 -0800
Message-ID: <CAB=NE6VVcQgum4mQ5eooS2yXo-NNXHvujsUwpbEwNdQQSreaBA@mail.gmail.com> (sfid-20120207_213824_389410_C2FCD3FB)
Subject: Re: [wireless-regdb] wireless-regdb: Update regulatory rules for
 Norway (NO)
To: "John W. Linville" <linville@tuxdriver.com>,
	Michael Green <green@qca.qualcomm.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Cc: =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
	linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	=?UTF-8?Q?Robert_Gr=C3=B8nning?= <slimg@iggu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 7, 2012 at 11:54 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> Well, sorry for the delay...  I will take this silence as "no
> objection". :-)

Sorry, I did get a reply by Michael Green on 11/28/2011 but I never
followed up with the list. Apologies as well with the delay, but here
is our review.

The European Union has some harmonized European radio conformance spec
and QCA's interpretation and position is that that spec overrides
deviations for end products for specific countries like the one being
recommended for Norway. This also means that QCA does not deviate for
EU countries on specs, even if countries have their own quirks, for
any country in the EU.

Supporting changes like these are a deviation from what QCA is used to
using and testing and we unfortunately cannot verify any individual
country specific changes like the one proposed for the EU. It is also
our sentiment that we stand to gain more if we simply unify the EU
requirements through the harmonized spec, it provides simplicity, its
what we use and we can help in that regards. If wireless-regdb decides
to take a different path we simply will not be able to verify and
validate these changes. I'd be surprised if any other 802.11 vendor
differs from this position.

  Luis

> Bjørn, could you give me a "Signed-off-by" line as well?
>
> Thanks,
>
> John
>
> On Mon, Nov 28, 2011 at 01:19:12PM -0500, John W. Linville wrote:
>> Any comments from the regulatory experts in the group?
>>
>> On Tue, Nov 22, 2011 at 03:13:22PM +0100, Bjørn Mork wrote:
>> > As mentioned by Robert Grønning <slimg at iggu.org> in June, Norway does
>> > allow a few more bands than what's currently in the database.  In
>> > particular, the old ISM band at 5725 - 5875 MHz is and has "always" been
>> > allowed.
>> >
>> > The regulations [1] have some weird restrictions wrt power densities etc
>> > which I have no idea how to describe in a format suitable for the db.
>> > I've tried my best to make sure the entries are within the rules.
>> >
>> > The regulations also allow up to 1 W eirp in the band 5470 - 5725 MHz,
>> > and up to 4 W eirp in the bands 5725 - 5795 MHz and 5815 - 5850 MHz if
>> > TPC is in use. The limits are reduced by 3dB without TPC.  As I don't
>> > know how to express the TPC requirement, I've chosen to put the reduced
>> > limits (500 mW and 2 W) in the db entries.  This also matches the German
>> > (DE) entry for 5470 - 5725 MHz, so I guess it must make some sense...
>> >
>> > I also have no idea which SI prefixes you allow in the database, so I've
>> > used whatever was in the regulations.  Please adjust as needed if only
>> > mW or dB is acceptable.  Or let me know and I'll provide an updated patch.
>> >
>> >
>> > Patch attached.
>> >
>> >
>> >
>> >
>> > References:
>> >
>> > [1] Current Norwegian regulations:
>> >   http://www.lovdata.no/cgi-wift/ldles?doc=/sf/sf/sf-20090602-0580.html
>> >
>> > [2] The Norwegian Post and Telecommunications Authority provides an unofficial english translation of these regulations:
>> >   http://www.npt.no/ikbViewer/Content/103810/Regulations_concerning_general_authorisations_for_the_use_of_radio_frequencies.pdf
>> >
>> >
>> > [3] Appendix 1 of ERC/REC 70-03 provides generic information about licensing
>> >   status for Short Range Devices (SRD) in most CEPT countries:
>> >   http://www.ecodocdb.dk/doks/filedownload.aspx?fileid=1694&fileurl=http://www.erodocdb.dk/Docs/doc98/official/pdf/REC7003E.PDF
>> >
>> >
>> >
>> >
>> > Bjørn
>>
>> > diff --git a/db.txt b/db.txt
>> > index e63a43e..375187f 100644
>> > --- a/db.txt
>> > +++ b/db.txt
>> > @@ -469,11 +469,20 @@ country NL:
>> >     (5250 - 5330 @ 40), (N/A, 20), DFS
>> >     (5490 - 5710 @ 40), (N/A, 27), DFS
>> >
>> > +# Data from http://www.lovdata.no/cgi-wift/ldles?doc=/sf/sf/sf-20090602-0580.html
>> >  country NO:
>> > -   (2402 - 2482 @ 40), (N/A, 20)
>> > -   (5170 - 5250 @ 40), (N/A, 20)
>> > -   (5250 - 5330 @ 40), (N/A, 20), DFS
>> > -   (5490 - 5710 @ 40), (N/A, 27), DFS
>> > +   # § 7 (2)
>> > +   (2400 - 2483.5 @ 40), (N/A, 100 mW)
>> > +   # § 7 (3)
>> > +   (5150 - 5350 @ 40), (N/A, 200 mW)
>> > +   # § 7 (4)
>> > +   (5470 - 5725 @ 40), (N/A, 500 mW), DFS
>> > +   # § 7 (5)
>> > +   (5725 - 5795 @ 40), (N/A, 2 W), DFS
>> > +   (5815 - 5850 @ 40), (N/A, 2 W), DFS
>> > +   # § 7 (6)
>> > +   (5725 - 5795 @ 40), (23, 1 W), DFS, PTP-ONLY
>> > +   (5815 - 5850 @ 40), (23, 1 W), DFS, PTP-ONLY
>> >
>> >  country NP:
>> >     (2402 - 2482 @ 40), (N/A, 20)
>>
>>
>> --
>> John W. Linville              Someday the world will need a hero, and you
>> linville@tuxdriver.com                        might be all we have.  Be ready.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>
> _______________________________________________
> wireless-regdb mailing list
> wireless-regdb@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/wireless-regdb
