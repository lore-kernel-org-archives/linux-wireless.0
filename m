Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:37443 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaLTK1x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2014 05:27:53 -0500
Received: by mail-ig0-f178.google.com with SMTP id hl2so1916938igb.11
        for <linux-wireless@vger.kernel.org>; Sat, 20 Dec 2014 02:27:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALhHN=qmhK983BHasRQKVtrHQy44wOdZc-PRL8s8v+e0GDHZHQ@mail.gmail.com>
References: <CAGXE3d8Uv01qjfvRQkMr1w_5wB6XKpC7d2VOR3UG0DMPHk6r9A@mail.gmail.com>
	<54940B8C.5070801@neratec.com>
	<CALhHN=qmhK983BHasRQKVtrHQy44wOdZc-PRL8s8v+e0GDHZHQ@mail.gmail.com>
Date: Sat, 20 Dec 2014 18:27:52 +0800
Message-ID: <CAFuUQkh1R6Lv2UQKtACV4ijbQ-AZujVE6rt0Zwu7SqrrWS7oXw@mail.gmail.com> (sfid-20141220_112756_956852_E05F626D)
Subject: Re: DFS CAC time
From: YanBo <dreamfly281@gmail.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One correct based on the patch, the 5600 should be change with 5590,
or else the channel 128 will be disabled in my testing.


+       (5490 - 5590 @ 80), (27), DFS, AUTO-BW
+       (5590 - 5650 @ 40), (27), (600000), DFS, AUTO-BW
+       (5650 - 5710 @ 40), (27), DFS, AUTO-BW

BR /Yanbo

On Fri, Dec 19, 2014 at 8:28 PM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> On 19 December 2014 at 12:27, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
>> On 12/18/2014 05:21 PM, Helmut Schaa wrote:
>>> Hi,
>>>
>>> [...]
>>>
>>> So, every channel has a CAC time of 60 seconds.
>>>
>>> Checking version 1.7.2 of the ETSI regulation indicates that we might
>>> need some modifications to cfg80211:
>>>
>>> From [1] page 79:
>>>
>>> "NOTE 1: For channels whose nominal bandwidth falls completely or
>>> partly within the
>>> band 5 600 MHz to 5 650 MHz, the Channel Availability Check Time shall be
>>> 10 minutes.
>>> NOTE 2: For channels whose nominal bandwidth falls completely or
>>> partly within the
>>> band 5 600 MHz to 5 650 MHz, the Off-Channel CAC Time shall be within the
>>> range 1 hour to 24 hours."
>>>
>>> So, for these channels we should select a longer initial CAC time.
>>>
>>> Is anyone aware of this issue?
>>>
>>> Thanks,
>>> Helmut
>>>
>>>
>>> [1] http://www.etsi.org/deliver/etsi_en/301800_301899/301893/01.07.02_20/en_301893v010702a.pdf
>>> --
>>
>> Hello Helmut,
>>
>> just forget about those aka 'weather channels' that require a pracitcally
>> impossible to achieve radar detection probability rate (99.99% during CAC, see
>> table D.5).
>>
>> They should simply be disabled, either at mac layer, or at least in ath/regd.c.
>>
>
> You can use internal regdb and set this correctly in db.txt, eg
>
> +       (5490 - 5600 @ 80), (27), DFS, AUTO-BW
> +       (5600 - 5650 @ 40), (27), (600000), DFS, AUTO-BW
> +       (5650 - 5710 @ 40), (27), DFS, AUTO-BW
>
> There are also patches for crda/wireless-regdb but not merged, so use
> internal regdb.
>
> BR
> Janusz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
