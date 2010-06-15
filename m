Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:44027 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab0FOPW3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 11:22:29 -0400
Received: by pxi8 with SMTP id 8so3434460pxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jun 2010 08:22:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100615.232558.867740727379709943.kou@clear-code.com>
References: <20100613.145200.1459063883179763823.kou@clear-code.com>
	<AANLkTinEMAQu33Tlv81-Cdx9fLZK-a-7uJlbAo7te2_w@mail.gmail.com>
	<20100615.232558.867740727379709943.kou@clear-code.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 15 Jun 2010 08:22:09 -0700
Message-ID: <AANLkTin9bG4qDEKwgOXmlR3k9wZ-JBSIlh3JzYjzVDeY@mail.gmail.com>
Subject: Re: [PATCH] zd1211rw: ignore unknown regulatory domain.
To: Kouhei Sutou <kou@clear-code.com>
Cc: Stephen.Chen@atheros.com, David.Quan@atheros.com,
	linux-wireless@vger.kernel.org, Michael.Green@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 15, 2010 at 7:25 AM, Kouhei Sutou <kou@clear-code.com> wrote:
> Hi,
>
> In <AANLkTinEMAQu33Tlv81-Cdx9fLZK-a-7uJlbAo7te2_w@mail.gmail.com>
>  "Re: [PATCH] zd1211rw: ignore unknown regulatory domain." on Sun, 13 Jun 2010 13:23:20 -0700,
>  "Luis R. Rodriguez" <mcgrof@gmail.com> wrote:
>
>>> I'm using PLANEX GW-US54GXS (2019:5303) and it works with
>>> the attached patch. Could you consider to merge the attached
>>> patch?
>>>
>>> Problem: GW-US54GXS uses zd1211rw but zd1211rw doesn't have
>>> a regulatory domain reported by GW-US54GXS (0x49).
>>>
>>> Solutions:
>>>
>>>  (1) add a new regulatory domain (0x49). Here is a patch to
>>>      use the approach:
>>
>> Stephen, David, does 0x49 map to JP for zd1211 ? Are there other ones?
>> Here is our list so far:
> ...
>> Kouhei, if no regulatory domain is found, instead we should world
>> roam, we cannot allow letting the user change regulatory domains at
>> their whim. We can, however let them choose one to help compliance,
>> but you can only help compliance once you know your actual regulatory
>> domain.
>
> Luis, thanks for your input.
> It seems that we can't use GW-US54GXS until 0x49 regulatory
> domain is registered to zd1211rw. Is it right?
>
> If it is right, what I can do for GW-US54GXS? Should I wait
> a response from Stephen and/or David?

We spoke and 0x49 - > JP is ok, can you send a patch for that?

  Luis
