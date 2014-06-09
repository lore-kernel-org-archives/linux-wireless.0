Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:59770 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaFIHdy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2014 03:33:54 -0400
Received: by mail-qc0-f169.google.com with SMTP id c9so288886qcz.28
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jun 2014 00:33:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400699356.4136.13.camel@jlt4.sipsolutions.net>
References: <1399624824-9204-1-git-send-email-janusz.dziedzic@tieto.com>
	<CAB=NE6UuZFDLdA-KW=ohaFwXjj_3wSY84cj3-KPO7HoKREPHOA@mail.gmail.com>
	<20140520142453.GB13981@tuxdriver.com>
	<CALhHN=qtxwww9hQ7XxK8tan3+4eSoXo3D_g9YLD0QhQDPcDUmg@mail.gmail.com>
	<20140520180832.GD13981@tuxdriver.com>
	<1400610273.4474.6.camel@jlt4.sipsolutions.net>
	<CAB=NE6WiuydxR62dvua_OEyV+sqxvH8aOUHOBLS3ePz1dGCLAw@mail.gmail.com>
	<1400688233.4136.8.camel@jlt4.sipsolutions.net>
	<20140521180020.GA13656@tuxdriver.com>
	<1400699356.4136.13.camel@jlt4.sipsolutions.net>
Date: Mon, 9 Jun 2014 09:33:52 +0200
Message-ID: <CALhHN=qZuPMjQMWGf0+J0ZKnj=5EGtfC=nWjJAYj2YWu=TTYLg@mail.gmail.com> (sfid-20140609_093400_018717_EB9207A3)
Subject: Re: [PATCH] wireless-regdb: add DFS CAC time parameter
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 May 2014 21:09, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-05-21 at 14:00 -0400, John W. Linville wrote:
>
>> The 'do not parse more permissively' would seem to be a problem if
>> we still produce an older format too, no?  I mean, wouldn't we have
>> to simply drop new rules to produce an older binary?  Even worse if
>> we left the old binary in place, since then you could never update
>> any rules for old crda installations at all.
>
> That's true, in a sense.
>
>> It seems like forcing a crda update to use any new format-breaking
>> rules might just be the right thing.  Can we make crda choke and die
>> loudly when it sees an unknown format?  Will the current crda do that?
>
> It will, yes. If the version number is mismatched it'll print "Invalid
> database version" (to stderr) and exit.
>

Why not just skip this binary interface between regdb --> crda and use
signed db.txt file?

Eg.
1) first we sign db.txt file using gpg - that will be all what
wireless-regdb will do

        cat db.txt | gpg --clearsign --default-key regdbkey_private >
db_signed.txt

As a result we will get something like this:

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

# This is the world regulatory domain
country 00:
(2402 - 2472 @ 40), (20)
# Channel 12 - 13.
(2457 - 2482 @ 20), (20), NO-IR AUTO-BW
# Channel 14. Only JP enables this and for 802.11b only
(2474 - 2494 @ 20), (20), NO-IR
# Channel 36 - 48
(5170 - 5250 @ 80), (20), NO-IR
# NB: 5260 MHz - 5700 MHz requies DFS
# Channel 149 - 165
(5735 - 5835 @ 80), (20), NO-IR
# IEEE 802.11ad (60GHz), channels 1..3
(57240 - 63720 @ 2160), (0)

....

country ZW: DFS-ETSI
(2402 - 2482 @ 40), (20)
(5170 - 5250 @ 80), (20)
(5250 - 5330 @ 80), (20), DFS
(5490 - 5710 @ 80), (27), DFS

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJTkbhXAAoJEJMu885bZibypxYH+QEVe1VNDalrzS99luWrqLn1
Cfrck6l4rdb/z+Ef1lGRxjYtvad/bRTYBHLwWqJEt/R5dvf1k32sNlZU+++dBLsg
IFBHlVdYa7DQok0K0Hfw8jGU3S6+XrSnFUHhiBR0NRP/SJGzevSE+MhVNulf6bZu
/uN1nW/+VCZ46wh5EGarWO3cWFCAJKJXujPWN6Zm97ieOBtAN95BHk29h5g+aSNS
NcszEvbIy86kKquCTUWQcAgUAp0ZijlQin1NoXr87Z3k9vKSAIK4kp+8WIfnHYYE
Y3g/lOMHh6bKOKllYxBxWNZQIgLP1R2yf/qv8JyGfeQTNfNlCihIQRFQeU0Hj5U=
=pCXt
-----END PGP SIGNATURE-----

2) crda will be a script that will do something like that:

        sh gpg_verify.sh && sh show_country.sh | crda_tiny

a) gpg_verify.sh will verify db.txt signature
- gpg --default-key regdb_public --verify db_signed.txt

b) show_country.sh will print text country base on COUNTRY enviroment
eg.
janusz@dell:~/work/gpg$ COUNTRY=US ./show_country.sh
country US: DFS-FCC
(2402 - 2472 @ 40), (30)
(5170 - 5250 @ 80), (17)
(5250 - 5330 @ 80), (23), DFS
(5735 - 5835 @ 80), (30)
(57240 - 63720 @ 2160), (40)

c) crda_tiny will parse this text and will pass regdb parameters using nl80211


BR
Janusz
