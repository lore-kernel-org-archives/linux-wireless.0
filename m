Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server6.subsys.no ([85.19.71.170]:43321 "EHLO server6.subsys.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933517Ab1FWSIf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2011 14:08:35 -0400
Subject: wireless-regdb: Update regulatory rules for Norway (NO)
From: Robert =?ISO-8859-1?Q?Gr=F8nning?= <slimg@iggu.org>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Jun 2011 19:58:41 +0200
Message-ID: <1308851921.31392.117.camel@torgerde> (sfid-20110623_200901_044252_842FE4E2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for spamming, I've updated some of the information so there is a
reason.

It seems like NO is wrong according to Norwegian wireless rules

This is how NO currently looks like:
http://wireless.kernel.org/en/developers/Regulatory/Database?alpha2=NO
-------------------START-------------------
country NO:
        (2402 - 2482 @ 40), (N/A, 20)
        (5170 - 5250 @ 40), (N/A, 20)
        (5250 - 5330 @ 40), (N/A, 20), DFS
        (5490 - 5710 @ 40), (N/A, 27), DFS
--------------------END--------------------

In the end of the document I've rewritten NO regulatory entry according
to the rules below.

This is what the Norwegian rules say about general usage of frequencies
for wi-fi:
Note: The following text is a translation (Google Translate) from a
subsection of the following document written in Norwegian:
http://www.lovdata.no/for/sf/sd/xd-20090602-0580.html#7
-------------------------------------START--------------------------------------
(3) the frequency band 5150-5350 MHz is authorized for indoor data
transfer including radio-based local area networks (WAS / RLAN) with a
maximum radiated power of 200 mW eirp the frequency use defined in the
standard EN 301 893 If any other use than indoor use, the average
spectral density in the frequency band 5150-5350 MHz is limited to 10
mW / MHz eirp in any 1 MHz range.

(4) the frequency band 5470-5725 MHz may be used for data transfer with
maximum radiated power of 1 W eirp Maximum average spectral density
shall not exceed 50 mW / MHz eirp in any 1 MHz band. The radio equipment
shall implement transmit power control (TPC) which provides an average
attenuation of at least 3 dB.
If TPC is not in use, the maximum allowed radiated power and power
density is 3 dB lower than that following the first and second sentence.
The radio equipment will use Dynamic Frequency Selection (DFS) as
specified in the standard EN 301 893

(5) The frequency bands 5725-5795 MHz and 5815-5850 MHz for data
transfer with maximum radiated power of 4 W eirp Maximum average
spectral density shall not exceed 200 mW / MHz eirp in any 1 MHz band.
The radio equipment shall implement Dynamic Frequency Selection (DFS) as
specified in the standard EN 302 502 Radio equipment shall transmit
power control (TPC) which provides an average attenuation of at least 3
dB. If TPC is not in use, the maximum allowed radiated power and power
density is 3 dB lower than that following the first and second sentence.
On the border between Norway and neighboring power density shall not
exceed -122.5 dBW / m 2 measured with a reference bandwidth of 1 MHz
unless otherwise stated in the coordination agreement.

(6) The frequency bands 5725-5795 and 5815-5850 MHz for point-to-point
radio links with maximum radiated power of 200 W eirp Maximum permitted
power supplied antenna is 1 W.
The maximum average spectral density shall not exceed 10 W / MHz
eirp in any 1 MHz band. The concept of point-to-point radio links
exclude all forms of point-to-multipoint, omnidirectional systems and
transmitters send the same information located in the same place (sector
antennas). The radio equipment shall implement Dynamic Frequency
Selection (DFS) as specified in the standard EN 302 502 On the border
between Norway and neighboring power density shall not exceed -122.5
dBW / m 2 measured with a reference bandwidth of 1 MHz unless
otherwise stated in the coordination agreement.
--------------------------------------END---------------------------------------

According to that documentation, to my understanding NO should look like
this instead:
-------------------START-------------------
country NO:
        (2400 - 2483.5 @ 40), (N/A, 20)
        (5150 - 5350   @ 40), (N/A, 23)
        (5470 - 5725   @ 40), (N/A, 27), DFS
        (5725 - 5795   @ 40), (N/A, 33), DFS
        (5815 - 5850   @ 20), (N/A, 33), DFS
--------------------END--------------------

Those are the frequencies mentioned in the law, I'm not sure if you want
those numbers, or numbers adjusted to the WiFi channel spec, those would
then be:
-------------------START-------------------
country NO:
	(2402 - 2482 @ 40), (N/A, 20)
	(5150 - 5340 @ 40), (N/A, 23)
	(5480 - 5720 @ 40), (N/A, 27), DFS
        (5725 - 5795 @ 40), (N/A, 33), DFS
        (5815 - 5850 @ 20), (N/A, 33), DFS
--------------------END--------------------

Question 1:
The norwegian laws also says that if TPC is available, then the maximum
allowed TX power
of the 5470-5725, 5725-5795 and 5815-5850 MHz frequency ranges will add
3 dBm to the maximum allowed tx-power, I don't know how to write this in
wireless-regdb.

Question 3:
The norwegian documentation also mentions these radio frequencies for
wireless data transfer:
* 5725 -> 5795 MHz and 5815-5850 MHz: point-to-point radio links
* 17,1 -> 17,3 GHz:
* 57 -> 66 GHz:
Does these belong in the wireless-regdb as well?

I hope my limited knowlege doesn't cause anyone unreasonable much work,
I'm really trying to get better at this.

-Robert Grønning (Norway)

