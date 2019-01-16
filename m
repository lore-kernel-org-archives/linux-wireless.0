Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3192EC43612
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 12:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00C322082F
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 12:50:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mork.no header.i=@mork.no header.b="RvNCD7r1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392861AbfAPMuF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 07:50:05 -0500
Received: from canardo.mork.no ([148.122.252.1]:56611 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392849AbfAPMuF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 07:50:05 -0500
Received: from miraculix.mork.no ([IPv6:2a02:2121:2c3:50aa:444a:e7ff:fe66:8618])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id x0GCnhwg029600
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 16 Jan 2019 13:49:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1547642985; bh=euI5brSmIZevATEkwr6ZQPETte2Ty1jRDi+D9odVfuo=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=RvNCD7r1KxOME68gv9WN5QQMcrcllAguPpa3a9+4thTL34CWMxJTP0en4VH1mFyxF
         /3oLLlw0m12pBXBoQ7c2su/1G3/vVJKbrG1ezVChvwSZI4KNChxBWC1XvmRW7+Mi5y
         kjNiZlgr9QaPF11ZbOI7OT98xEpngXaE+hWCZk00=
Received: from bjorn by miraculix.mork.no with local (Exim 4.89)
        (envelope-from <bjorn@mork.no>)
        id 1gjkdW-0001YG-Gh; Wed, 16 Jan 2019 13:49:38 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Petko Bordjukov <bordjukov@gmail.com>
Cc:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "wireless-regdb\@lists.infradead.org" 
        <wireless-regdb@lists.infradead.org>
Subject: Re: [wireless-regdb] Tx power for slave devices in ETSI DFS region
Organization: m
References: <423eaa39-fc06-6a5a-a8fd-5e15d503dff5@quantenna.com>
        <03c1e278fdd880bf7409c0b1c03366178b765cda.camel@sipsolutions.net>
        <cdcde7a4-a2b0-5d4b-83e6-cfbffdfe93d9@quantenna.com>
        <CAAgmp6ujgvXAvzB5Y7UcLxosfHCeSaSy5taiJ-jhu2YDk+RVFg@mail.gmail.com>
Date:   Wed, 16 Jan 2019 13:49:38 +0100
In-Reply-To: <CAAgmp6ujgvXAvzB5Y7UcLxosfHCeSaSy5taiJ-jhu2YDk+RVFg@mail.gmail.com>
        (Petko Bordjukov's message of "Wed, 16 Jan 2019 12:26:01 +0200")
Message-ID: <87won4lqcd.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.100.2 at canardo
X-Virus-Status: Clean
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

You could simplify the entries for most of the CEPT area by coding in a
common reference to the ECC/DEC/(04)08 instead of trying to express
every detailed restriction from every national regulation.

There is absolutely no reason to make the regulatory database more
complicated than what you find in https://www.erodocdb.dk/document/381
and the associated implemetation status on
https://www.efis.dk/matrixviewer.jsp?annex=3D18

The CEPT members can and should be expected to keep the ERO database
updated. Duplicating that job is unnecessary and only causes errors.
The national regulations are supposed to be implementations of the
ECC/DEC/(04)08.  Any differences should be explained and documented in
the ERO database, or they can be considered translation errors.

So there should not be much difference between most of the CEPT
countries for the 5150-5350 and 5470-5725 MHz bands, according to the
current ECC/DEC/(04)08 implementation status.

Just my .02 =E2=82=AC


Bj=C3=B8rn

Petko Bordjukov <bordjukov@gmail.com> writes:

> Hello Igor and Johannes,
>
> From my research around TPC and radar detection in the context of the BG
> regulatory domain and respectively ETSI, the relevant regulatory rules ar=
e more
> specific than both what can currently be expressed in the regdb and what =
will be
> possible to be expressed with your suggested modifications.
>
> For example, in [1] it is stated that for the 5470-5725 MHz band:
>
>   * The maximum allowed transmission power is 1 W e.i.r.p. with a maximum=
 of 50
>     mW/MHz spectral density of the average e.i.r.p. for each 1 MHz band.
>
>   * The use of TPC that ensures lowering the average e.i.r.p. of the enti=
re
>     system (as I understand it, this means both the AP and STAs) of at le=
ast 3
>     dbm is required.
>
>   * In case TPC (as I understand it -- that exhibits the parameters above=
) is
>     not used, both the maximum allowed transmission power and maximum spe=
ctral
>     density of the average e.i.r.p. are lowered by 3 dB.
>
>   * The use of methods for limiting radio interference ensuring at least =
the
>     described in BDS 301 893 (respectively ETSI 301 893) protection
> for providing
>     coexistance with radio radar systems.
>
> If there is will to extend the regdb format to be able to express accurat=
ely and
> in their entirety the specifics of the relevant regulations, IMO a wider =
and
> more detailed discussion is in order.
>
> [1] http://www.crc.bg/files/_bg/Spisak_2015.pdf - List of radio equipment=
 that
>     uses harmonized within the European Union bands and electronic
>     communications terminal equipment (the List)
>
> Best regards,
>
> Petko
>
> On Wed, Jan 16, 2019 at 6:00 AM Igor Mitsyanko
> <igor.mitsyanko.os@quantenna.com> wrote:
>>
>> On 1/15/19 5:45 AM, Johannes Berg wrote:
>> >> Question is: does wireless core assumes that each device can do radar
>> >> detection in slave modes (eg acting as a STA) and it is enabled by
>> >> default? I couldn't find any logic in kernel which would limit 27 dbm
>> >> power to 20 for STA devices.
>> >
>> > No, we shouldn't assume that it can do radar detection by itself ...
>> >
>> > I guess we should have some code? Or just fix the regdb?
>> >
>> > johannes
>> >
>> >
>>
>> Maybe we have to do both, as there are multiple things to consider:
>> - current regdb values are fine for AP mode
>> - Tx power values can be 3 dbm higher if TPC is supported. This is
>> mentioned in a comment in regdb, but not used anywhere.
>> - if STA detects radar, non-occupancy period must start
>> - when non-occupancy period elapses, STA must do CAC before returning to
>> channel. I guess CAC must be triggered by wpa_supplicant?
>>
>>
>> I'm not sure how to present additional information in regdb while
>> preserving backwards compatibility. Maybe we can:
>> 1. Have a separate rule marked with NO_RDETECT flag which will advertise
>> lower Tx power. Linux wireless core will have to select rule with
>> highest Tx power if possible, for better results.
>> 2. For TPC 3dbm gain, have a flag TPC_GAIN
>> As an example, AW rules will look like:
>>
>> country AW: DFS-ETSI
>>         (2402 - 2482 @ 40), (20)
>>         (5170 - 5250 @ 80), (20), AUTO-BW, TPC_GAIN=3D3
>>         (5250 - 5330 @ 80), (20), DFS, AUTO-BW, TPC_GAIN=3D3
>>         (5490 - 5710 @ 160), (27), DFS, TPC_GAIN=3D3
>>         (5490 - 5710 @ 160), (20), DFS, NO_RDETECT, TPC_GAIN=3D3
>>
>> Linux wireless core will have to update Tx power values when switching
>> from AP and STA modes, and somehow notify drivers.
>> _______________________________________________
>> wireless-regdb mailing list
>> wireless-regdb@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/wireless-regdb
>
> _______________________________________________
> wireless-regdb mailing list
> wireless-regdb@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/wireless-regdb
