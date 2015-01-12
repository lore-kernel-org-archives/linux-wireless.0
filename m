Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:43805 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbbALLv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 06:51:27 -0500
Received: by mail-wg0-f48.google.com with SMTP id l2so18816225wgh.7
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2015 03:51:26 -0800 (PST)
Message-ID: <54B3B538.5010700@googlemail.com> (sfid-20150112_125134_561815_7C7D8AB6)
Date: Mon, 12 Jan 2015 11:51:20 +0000
From: Chris Clayton <chris2553@googlemail.com>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: kvalo@codeaurora.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: IWLWIFI - 3.18-stable
References: <54B272F0.70307@googlemail.com>	<54B273E1.6030306@googlemail.com>	<CANUX_P2PiGUBaw89Rb2zSuy2x8=GJN=o6XgcasdVMtvoy6kmAQ@mail.gmail.com>	<54B2DBAF.7010208@googlemail.com> <CANUX_P1Bdz4R2WUK53fx7r5CuvBmyBdqZWwR+Of=1mi7VncqZQ@mail.gmail.com>
In-Reply-To: <CANUX_P1Bdz4R2WUK53fx7r5CuvBmyBdqZWwR+Of=1mi7VncqZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Emmanuel.

On 01/12/15 06:03, Emmanuel Grumbach wrote:
> On Sun, Jan 11, 2015 at 10:23 PM, Chris Clayton
> <chris2553@googlemail.com> wrote:

[snip]

>>>
>>> The first one (c93edc639392df733c7d72db4376a9add775d18a) is tagged for stable.
>>
>> Ah, sorry I missed that.
>>
>>> Are you using bluetooth?
>>
>> Yes, I have a bluetooth mouse and use bluetooth for audio from time to time.
>>
>>> Are you able to tell me which of the two really helps?
>>
>> It's c93edc639392df733c7d72db4376a9add775d18a that helps. With that applied, I can set off a task which, in a loop,
>> continually copies a 180MB file from a server on my network. The network remained stable for over 30 minutes before I
>> killed the task. Without the patch, the network fails during the first iteration of copying the file.
>>

Just by way of confirmation, I'm now running 3.19.0-rc4 with c93edc639392df733c7d72db4376a9add775d18a applied and my
network is stable. None of the other patches from iwlwifi-fixes that I was previously using are applied.

Thanks for your help.

>> a9dc5060bf3a32ac3dad472f15416054b92dc5b5 doesn't seem to have any effect on the instability.
> 
> Ok - I am not surprised - thanks.
> c93edc... allows to use 2 antennas instead of one only. Technically,
> one would be enough, but apparently, in your configuration, using 2
> antennas allows to improve reliability.
> 
>>
>>
>>> Unless I am missing something, the first one
>>> (c93edc639392df733c7d72db4376a9add775d18a) should help only if you
>>> disabled power save. Is that the case?
>>
>> Not that I know of. The only power-related thing in my init scripts is echoing 5 to /proc/sys/vm/laptop_mode, which I
>> believe configures disk activity to save power. The mouse does have a power saving feature, however. According to the
>> manual, it reduces its power consumption in steps the longer it is inactive. As I frequently work in kde's konsole
>> terminal application, mouse inactivity is common.
>>
>> Hope this helps and feel free to request additional information.
> 
> Ok - I checked the code and we enable the redundancy mentioned above
> (2 antenna instead of 1) even if power save is enabled.
> FWIW - this redundancy is also called "diversity".

<Smile>. Over 30 years working in the IT industry tells me that is a trick vendors have been using for a long time in
order to try and confuse customers into buying something they've already got! :-)
> 
> Thanks.
> 
>>
>> Chris
>>>
