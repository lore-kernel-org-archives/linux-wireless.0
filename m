Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:11147 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbZGWH5t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 03:57:49 -0400
Received: by wa-out-1112.google.com with SMTP id j5so117800wah.21
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 00:57:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890907220941j70f5ca98g5af9d9372eeef2e@mail.gmail.com>
References: <f7de31c0907220607v3266710co5640389fc0ccbc22@mail.gmail.com>
	 <20090722131957.GA5276@tuxdriver.com>
	 <f7de31c0907220704x5000854bq652b09bf5b6bfc3c@mail.gmail.com>
	 <43e72e890907220916n6a5c76d3ydbfc0233f86e3546@mail.gmail.com>
	 <15B47C78534E094AA9A41F58FB8D74F30147BE67876F@SC1EXMB-MBCL.global.atheros.com>
	 <43e72e890907220941j70f5ca98g5af9d9372eeef2e@mail.gmail.com>
Date: Thu, 23 Jul 2009 14:57:49 +0700
Message-ID: <f7de31c0907230057yb7fe603u1cdfb1583132ae58@mail.gmail.com>
Subject: Re: Update for regulatory database on 5GHz band for Thailand (TH)
From: Phattanon Duangdara <sfalpha@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 22, 2009 at 11:41 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> On Wed, Jul 22, 2009 at 9:27 AM, David Quan<David.Quan@atheros.com> wrote:
>> I am not sure what the question is here.
>> Our windows driver already have 5G turn on for Thailand.
>> Are you stating that it is not on the Linux Ath9K?
>
> David, just a heads up, a public list is being CC'd here.
>
> In the db.txt (from wireless-regdb) we currently have TH mapped as:
>
> country TH:
>        (2402 - 2482 @ 40), (N/A, 20)
>
> This came from the regpair TH was mapped to, which does differ from
> FCC3_WORLD. TH was mapped to NULL1_WORLD which explains the lack of 5
> GHz on TH on db.txt.
>
>> In Windows code, it is Thailand is mapped to FCC3_WORLD.
>
> OK this needs to be updated and the regulatory database as well. Only
> these countries map to FCC3_WORLD currently in ath.ko (the shared
> module between ath5k, ath9k and ar9170):
>
>        {CTRY_BRAZIL, FCC3_WORLD, "BR"},
>        {CTRY_SOUTH_AFRICA, FCC3_WORLD, "ZA"},
>        {CTRY_SRI_LANKA, FCC3_WORLD, "LK"},
>
> To get TH to map to FCC3_WORLD we need a one line change to ath.ko
> code and to the public db.txt to change to use the same regulatory
> information as "BR", "ZA", and "LK":
>
> country TH:
>        (2402 - 2482 @ 20), (N/A, 20)
>        (5170 - 5250 @ 20), (3, 17)
>        (5250 - 5330 @ 20), (3, 20), DFS
>        (5490 - 5710 @ 20), (3, 20), DFS
>        (5735 - 5835 @ 20), (3, 30)
>
> I'll send the respective patch if you ACK TH should map to the above.
>
>  Luis

Yes, And some of windows drivers already enable 5GHz for Thailand.
So please update for us.

Thanks,
Phattanon
