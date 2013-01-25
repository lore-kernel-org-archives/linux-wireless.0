Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:41323 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab3AYMK3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 07:10:29 -0500
Received: by mail-wi0-f177.google.com with SMTP id hm2so249089wib.4
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 04:10:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1537149.hyND0EvR7A@sylvesterjr.pats.ua.ac.be>
References: <1731354.xZITKB59tC@sylvesterjr.pats.ua.ac.be>
	<CAGXE3d_fD9etSnMKFUb6YGz=4g85ACkvdgyPjusMJXus-nvFYg@mail.gmail.com>
	<1537149.hyND0EvR7A@sylvesterjr.pats.ua.ac.be>
Date: Fri, 25 Jan 2013 13:05:12 +0100
Message-ID: <CAGXE3d8kBF-tBeGe6z0KVys5XiVFcrMUnYrbph-FUHJSZhQGKA@mail.gmail.com> (sfid-20130125_131033_350265_8048FB74)
Subject: Re: Unable to get RTS/CTS working in rt2800
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Erwin Van de Velde <erwin.vandevelde@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 25, 2013 at 11:45 AM, Erwin Van de Velde
<erwin.vandevelde@gmail.com> wrote:
> On Friday 25 January 2013 09:42:31 Helmut Schaa wrote:
>> On Thu, Jan 24, 2013 at 4:58 PM, Erwin Van de Velde
>>
>> <erwin.vandevelde@gmail.com> wrote:
>> > In a test setup with 802.11a/n a colleague and I tried enabling
> RTS/CTS.
>> > The only thing we got however was a CTS to self. RTS threshold was
> 1000B,
>> > packet size 1400B.
>>
>> Did you use 11n aggregation?
>
> Yes, but afterwards we also tried it with 802.11a, same result.

Bad. I expected this to work ...

>> > We looked for other options but did not find anything
>> > helpful, what else can we try to enable RTS/CTS?
>>
>> Yup, there are several issues there:
>> - The hw ignores RTS thresholds for AMPDUs AFAIK
>> - HT protection always uses CTS-to-self (hardcoded in driver in
>> rt2800_config_ht_opmode)
>>
>> I don't think any other driver allows to configure if RTS-CTS or
>> CTS-to-self should be used?
>> You can easily enforce RTS-CTS for 11n transmissions by changing
>> rt2800_config_ht_opmode.
>
> Where do I configure that? Is it in the source code or is it a kernel
> module parameter?

You'd need to change the source code of rt2800_config_ht_opmode.

Helmut
