Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:63605 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbbBHN0W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2015 08:26:22 -0500
Received: by mail-ig0-f181.google.com with SMTP id hn18so11471587igb.2
        for <linux-wireless@vger.kernel.org>; Sun, 08 Feb 2015 05:26:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALhHN=pxxL9Wr9aURjZV8fQ7uvSV6e49KTLbEAzUZ0zTDhPsqw@mail.gmail.com>
References: <1420645811-17877-1-git-send-email-eliad@wizery.com>
	<1420645811-17877-3-git-send-email-eliad@wizery.com>
	<20150207115758.GA503@w1.fi>
	<CALhHN=rj=1OE8xv_q4cTRVkF_=Ko-3amjn4_6tYHXg9dtev=9A@mail.gmail.com>
	<CAB3XZEfJt=YKP8+SKie7L_4sdxcdrGUtzruDvrjFKDvXKo2L3w@mail.gmail.com>
	<CALhHN=pxxL9Wr9aURjZV8fQ7uvSV6e49KTLbEAzUZ0zTDhPsqw@mail.gmail.com>
Date: Sun, 8 Feb 2015 15:26:21 +0200
Message-ID: <CAB3XZEeqpNaXQ_1VPmuTZU0xN3s3tx71d_f-Z6pAhYo4NyxkAA@mail.gmail.com> (sfid-20150208_142722_511139_455A40E8)
Subject: Re: [PATCH v2 3/3] mac80211: don't defer scans in case of radar detection
From: Eliad Peller <eliad@wizery.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 8, 2015 at 3:17 PM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> On 8 February 2015 at 11:57, Eliad Peller <eliad@wizery.com> wrote:
>> On Sat, Feb 7, 2015 at 9:17 PM, Janusz Dziedzic
>> <janusz.dziedzic@tieto.com> wrote:
>>> BTW, what in case we will start AP on first interface (DFS channel),
>>> on second one we will try to connect to other AP. As I understand this
>>> correctly, second iface (STA iface) will not allow to scan (connect)
>>> ...?
>>>
>> right.
>> The rationale behind it that you must listen constantly to detect
>> radar events, which prevents scanning off-channel.
>> (i guess an exception for on-channel scanning can be added if needed, though)
>>
> Still I can image hw with hw_scan() support that could have dedicated
> "hw part" for scanning.
> So, driver should made this decision (allow or not) base on hw features.
>
this will probably require additional radio...

anyway, i don't have any objection here :)
just explained the original logic (and my patch only changed the
behavior from blocking indefinitely to returning error immediately)

Eliad.
