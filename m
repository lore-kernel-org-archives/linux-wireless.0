Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:36735 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab0ETHEO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 03:04:14 -0400
Received: by pxi18 with SMTP id 18so1174841pxi.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 May 2010 00:04:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100520064809.GC32757@tpkurt2.garloff.de>
References: <20100519172944.GB32757@tpkurt2.garloff.de> <AANLkTilXo13Pn6n0n3mJONuUj50BImufADLveYAjX3YR@mail.gmail.com>
	<20100520064809.GC32757@tpkurt2.garloff.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 20 May 2010 00:03:54 -0700
Message-ID: <AANLkTinqVWmXNVR_3Wd3nSWWe7LwtCn3J7ZGFYYfuTen@mail.gmail.com>
Subject: Re: WLAN Regulatory Domain Germany
To: Kurt Garloff <kurt@garloff.de>
Cc: Michael Green <Michael.Green@atheros.com>,
	David Quan <David.Quan@atheros.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 19, 2010 at 11:48 PM, Kurt Garloff <kurt@garloff.de> wrote:
> Luis,
>
> On Wed, May 19, 2010 at 03:20:24PM -0700, Luis R. Rodriguez wrote:
>> On Wed, May 19, 2010 at 10:29 AM, Kurt Garloff <kurt@garloff.de> wrote:
>> > country DE:
>> >        # entries 279004 and 280006
>> >        (2400 - 2483.5 @ 40), (N/A, 100 mW)
>> >        # entry 303005
>> >        (5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
>> >        # entries 304002 and 305002
>> >        (5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
>> >        # entries 308002, 309001 and 310003
>> >        (5470 - 5725 @ 40), (N/A, 500 mW), DFS
>> >
>> > 8<------------------------------------------------------------------------
>> >
>> > (Or in db, as displayed by iw reg get)
>> > country DE:
>> >        (2400 - 2483 @ 40), (N/A, 20)
>> >        (5150 - 5250 @ 40), (N/A, 20), NO-OUTDOOR
>> >        (5250 - 5350 @ 40), (N/A, 20), NO-OUTDOOR, DFS
>> >        (5470 - 5725 @ 40), (N/A, 27), DFS
>> >
>> > PS: I'm not subscribed, please copy responses to me.
>>
>> Thanks for the e-mail and your review, I've passed this to our
>> regulatory gods and it is now being picked at and reviewed.
>
> Thanks.
>
> Two more remarks:
> - Having looked at the framework how we handle this regulatory stuff
>  in Linux these days, it looks very reasonable to me -- good job!

Thanks! Thank Johannes as well :)

> - The frequencies above (from Frequenznutzungsplan = freq. util. plan)
>  are really the limits of the frequency ranges to be used, not channel
>  center freqs. So if we'd have to put possible center freqs in there
>  and assume 22MHz (+-11MHz) for the 2.4 GHz range, we'd need to put
>  2411 -- 2472.5 in the DB. Likewise, assuming 20MHz (+-10MHz for the
>  5GHz range, we'd specify 5160 -- 5240, 5240 -- 5340 and 5480 -- 5715),
>  of, for 40MHz(+-20MHz) channels, it would be 5170 -- 5230, 5230 --
>  5330 and 5490 -- 5705. Such values are displayed with iw reg get
>  for our neighbors NL, FR, ... which gave me the idea that we might
>  not have the real boundaries in the db, but center freqs.
>  That said, I'd think real boundaries make more sense, as channel
>  widths may evolve over time ...

The db.txt rules uses the exact ranges, not the center of freq, the
bandwidth indicates the maximum bandwidth allowed. We had also revised
on linux-wireless some changes to make for future more complex
considerations. For details see:

http://wireless.kernel.org/en/developers/todo-list

  Luis
