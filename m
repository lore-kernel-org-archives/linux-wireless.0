Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:63556 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaLSM27 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2014 07:28:59 -0500
Received: by mail-la0-f42.google.com with SMTP id gd6so754766lab.15
        for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2014 04:28:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54940B8C.5070801@neratec.com>
References: <CAGXE3d8Uv01qjfvRQkMr1w_5wB6XKpC7d2VOR3UG0DMPHk6r9A@mail.gmail.com>
	<54940B8C.5070801@neratec.com>
Date: Fri, 19 Dec 2014 13:28:57 +0100
Message-ID: <CALhHN=qmhK983BHasRQKVtrHQy44wOdZc-PRL8s8v+e0GDHZHQ@mail.gmail.com> (sfid-20141219_132902_785600_95FD152D)
Subject: Re: DFS CAC time
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 December 2014 at 12:27, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
> On 12/18/2014 05:21 PM, Helmut Schaa wrote:
>> Hi,
>>
>> [...]
>>
>> So, every channel has a CAC time of 60 seconds.
>>
>> Checking version 1.7.2 of the ETSI regulation indicates that we might
>> need some modifications to cfg80211:
>>
>> From [1] page 79:
>>
>> "NOTE 1: For channels whose nominal bandwidth falls completely or
>> partly within the
>> band 5 600 MHz to 5 650 MHz, the Channel Availability Check Time shall be
>> 10 minutes.
>> NOTE 2: For channels whose nominal bandwidth falls completely or
>> partly within the
>> band 5 600 MHz to 5 650 MHz, the Off-Channel CAC Time shall be within the
>> range 1 hour to 24 hours."
>>
>> So, for these channels we should select a longer initial CAC time.
>>
>> Is anyone aware of this issue?
>>
>> Thanks,
>> Helmut
>>
>>
>> [1] http://www.etsi.org/deliver/etsi_en/301800_301899/301893/01.07.02_20/en_301893v010702a.pdf
>> --
>
> Hello Helmut,
>
> just forget about those aka 'weather channels' that require a pracitcally
> impossible to achieve radar detection probability rate (99.99% during CAC, see
> table D.5).
>
> They should simply be disabled, either at mac layer, or at least in ath/regd.c.
>

You can use internal regdb and set this correctly in db.txt, eg

+       (5490 - 5600 @ 80), (27), DFS, AUTO-BW
+       (5600 - 5650 @ 40), (27), (600000), DFS, AUTO-BW
+       (5650 - 5710 @ 40), (27), DFS, AUTO-BW

There are also patches for crda/wireless-regdb but not merged, so use
internal regdb.

BR
Janusz
