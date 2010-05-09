Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54172 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab0EIUYa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 May 2010 16:24:30 -0400
Received: by fxm10 with SMTP id 10so1866997fxm.19
        for <linux-wireless@vger.kernel.org>; Sun, 09 May 2010 13:24:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BE46584.5060304@create-net.org>
References: <4BE43C18.2030806@create-net.org> <j2v69e28c911005070935wb720d757labf3a0484aedefb8@mail.gmail.com>
	<4BE46584.5060304@create-net.org>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 9 May 2010 22:24:08 +0200
Message-ID: <r2y69e28c911005091324sbff07538i28babb432e6751db@mail.gmail.com>
Subject: Re: Packet injection with ath9k
To: Roberto Riggio <roberto.riggio@create-net.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/5/7 Roberto Riggio <roberto.riggio@create-net.org>:
> Hi,
>
> well, that is what i wanted to understand. These are the struct
> that I'm using to compose the rediotap header:
>
> struct ieee80211_radiotap_header {
>    u_int8_t    it_version;
>    u_int8_t    it_pad;
>    u_int16_t       it_len;
>    u_int32_t       it_present;

AFAIK these 2 fields need to be little-endian even on big-endian
machines. If your system is big-endian, this can cause problems.

> } __attribute__((__packed__));
>
> struct click_radiotap_header {
>    struct ieee80211_radiotap_header wt_ihdr;
>    u_int8_t    wt_rate;
>    u_int8_t    wt_txpower;
>    u_int8_t        wt_rts_retries;
>    u_int8_t        wt_data_retries;
> };
>
> The flags are set in order to take into account the fields that I
> specify. But i do not know at which point the frame are
> dropped.
>
> R.
>
> On 05/07/2010 06:35 PM, Gábor Stefanik wrote:
>>
>> Hi!
>> Are you sure it is not your injector that is having alignment issues?
>> AFAIK the radiotap parser explicitly uses endianness-aware function
>> everywhere.
>>
>> On Fri, May 7, 2010 at 6:13 PM, Roberto Riggio
>> <roberto.riggio@create-net.org>  wrote:
>>
>>>
>>> Hi,
>>>
>>> I'm writing an application to inject traffic over a wireless interface.
>>> This
>>> app
>>> is working fine on an x86 machine. However if i compile the same app for
>>> an arm platform, no frame are sent over the wireless interface (ath9k).
>>>
>>> I'm guessing that this is because of some alignment issues but i cannot
>>> track
>>> the piece of code that is actually parsing the frame. I've found the
>>> __ieee80211_parse_tx_radiotap in net/mac80211/tx.c function, but it is
>>> not called when i try to inject some traffic, so the frame are dropped
>>> before that.
>>>
>>> Any hints?
>>>
>>> Thanks
>>> R.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>
>>
>>
>
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
