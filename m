Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:37778 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab3JaUVQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Oct 2013 16:21:16 -0400
Received: by mail-bk0-f41.google.com with SMTP id na10so1471273bkb.28
        for <linux-wireless@vger.kernel.org>; Thu, 31 Oct 2013 13:21:14 -0700 (PDT)
Message-ID: <5272BBB7.30304@gmail.com> (sfid-20131031_212130_636841_1691DA20)
Date: Thu, 31 Oct 2013 21:21:11 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 5/7] wireless-regdb: optimize two of ES's rules
References: <5272723B.4090006@gmail.com> <CAB=NE6X7LJnCBVQ5bXiXs-F8MgNoRDGzzdubkVAVmoyd3EaQZw@mail.gmail.com>
In-Reply-To: <CAB=NE6X7LJnCBVQ5bXiXs-F8MgNoRDGzzdubkVAVmoyd3EaQZw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/31/2013 09:00 PM, Luis R. Rodriguez wrote:

> 2013/10/31 Xose Vazquez Perez <xose.vazquez@gmail.com>:

>> This patch is incompatible with my ("pending")patch:
>> http://lists.infradead.org/pipermail/wireless-regdb/2013-February/000136.html

> I'd like Michael to review this one, in the meantime I'll drop this
> one from my patch set. I have a new set of patches I'll post soon.

Time ago I sent the CEPT/ECC regulation:
http://lists.infradead.org/pipermail/wireless-regdb/2012-June/000058.html

===recortamorena===
* ECC/DEC/(04)08 Harmonised use of 5 GHz for the implementation
  of WAS/RLANs: http://www.erodocdb.dk/Docs/doc98/official/pdf/ECCDEC0408.PDF

---cut---
[...]
DECIDES

1. that this Decision designates the frequency bands 5.150-5.350 MHz
and 5.470–5.725 MHz for the implementation of Wireless Access
Systems including Radio Local Area Networks (WAS/RLANs) and the
use of equipment complying with the harmonised standard EN 301 893,
which may also be demonstrated by compliance with equivalent
technical specifications (in the sense of Article 3(2) of the
R&TTE Directive);

2. that in the frequency band 5.150-5.350 MHz, WAS/RLANs stations
shall be restricted to indoor use with a maximum mean e.i.r.p.1 of
200 mW and a maximum mean e.i.r.p. density of 10 mW/MHz in any 1MHz
band;

3. that in the frequency band 5.470-5.725 MHz, the indoor and
outdoor use of WAS/RLANs stations shall be restricted to a maximum
mean e.i.r.p.1 of 1 W and a maximum mean e.i.r.p. density of 50mW/MHz
in any 1 MHz band;

4. that, WAS/RLANs operating in the bands 5.250-5.350 MHz and
5.470-5.725 MHz shall either employ transmitter power control, which
provides, on average, a mitigation factor of at least 3 dB on the
maximum permitted output power of the systems; or, if transmitter
power control is not in use, then the maximum permitted mean
e.i.r.p.1 and the corresponding mean e.i.r.p. density limits in
decides 2 and 3 shall be reduced by 3 dB;

5. that, WAS/RLANs operating in the bands 5.250-5.350 MHz and
5.470-5.725 MHz shall use dynamic frequency selection (DFS) as
described in Recommendation ITU-R M. 1652 to ensure compatible
operation with radiodetermination systems;

6. that, in addition to decides 5, the DFS mechanism shall ensure
that the probability of selecting a given channel will be the same
for all available channels. The intention is to provide, on
average, a near-uniform spread of the loading of the spectrum;

7. that this Decision replaces the previous ERC Decision (99)23;

8. that this Decision shall enter into force on 30 October 2009;

9. that CEPT administrations shall communicate the national
measures implementing this Decision to the ECC chairman and the
Office when the Decision is nationally implemented."
[...]
---end---



* Implementation by country:

http://www.erodocdb.dk/doks/implement_doc_adm.aspx?docid=2033
http://www.erodocdb.dk/doks/mapsi_implement.aspx?docid=2033


- Yes ... 38

- Yes Partly ... 2
Russian Federation
Georgia

- Under study ... 1
Albania

- No info ... 7
Andorra
Vatican City
Monaco
Moldova
San Marino
Azerbaijan
Belarus


All CEPT countries, except those listed above, and for 5GHz
bands, should be clones of the current DE configuration:

(5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
(5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
(5470 - 5725 @ 40), (N/A, 500 mW), DFS

-thanks-
===end===


I did cut&paste from DE to ES, but DE lowers the limit
in 5150-5250 to 100mW for "neighborhood reasons" [1].
Even when 200mW is completely legal in DE.

[1] http://marc.info/?l=linux-wireless&m=127429049514439
