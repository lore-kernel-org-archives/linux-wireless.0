Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:47057 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbbALMUV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 07:20:21 -0500
Received: by mail-la0-f49.google.com with SMTP id hs14so23720818lab.8
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2015 04:20:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54B3B538.5010700@googlemail.com>
References: <54B272F0.70307@googlemail.com>
	<54B273E1.6030306@googlemail.com>
	<CANUX_P2PiGUBaw89Rb2zSuy2x8=GJN=o6XgcasdVMtvoy6kmAQ@mail.gmail.com>
	<54B2DBAF.7010208@googlemail.com>
	<CANUX_P1Bdz4R2WUK53fx7r5CuvBmyBdqZWwR+Of=1mi7VncqZQ@mail.gmail.com>
	<54B3B538.5010700@googlemail.com>
Date: Mon, 12 Jan 2015 14:20:20 +0200
Message-ID: <CANUX_P3012KuL8KvAvotVShuUqNXSgnW5g571xpGo1NGhmyNOg@mail.gmail.com> (sfid-20150112_132027_690098_2F09F0AF)
Subject: Re: IWLWIFI - 3.18-stable
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Chris Clayton <chris2553@googlemail.com>
Cc: kvalo@codeaurora.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> [snip]
>
>>>>
>>>> The first one (c93edc639392df733c7d72db4376a9add775d18a) is tagged for stable.
>>>
>>> Ah, sorry I missed that.
>>>
>>>> Are you using bluetooth?
>>>
>>> Yes, I have a bluetooth mouse and use bluetooth for audio from time to time.
>>>
>>>> Are you able to tell me which of the two really helps?
>>>
>>> It's c93edc639392df733c7d72db4376a9add775d18a that helps. With that applied, I can set off a task which, in a loop,
>>> continually copies a 180MB file from a server on my network. The network remained stable for over 30 minutes before I
>>> killed the task. Without the patch, the network fails during the first iteration of copying the file.
>>>
>
> Just by way of confirmation, I'm now running 3.19.0-rc4 with c93edc639392df733c7d72db4376a9add775d18a applied and my
> network is stable. None of the other patches from iwlwifi-fixes that I was previously using are applied.
>
> Thanks for your help.
>
>>> a9dc5060bf3a32ac3dad472f15416054b92dc5b5 doesn't seem to have any effect on the instability.
>>
>> Ok - I am not surprised - thanks.
>> c93edc... allows to use 2 antennas instead of one only. Technically,
>> one would be enough, but apparently, in your configuration, using 2
>> antennas allows to improve reliability.
>>
>>>
>>>
>>>> Unless I am missing something, the first one
>>>> (c93edc639392df733c7d72db4376a9add775d18a) should help only if you
>>>> disabled power save. Is that the case?
>>>
>>> Not that I know of. The only power-related thing in my init scripts is echoing 5 to /proc/sys/vm/laptop_mode, which I
>>> believe configures disk activity to save power. The mouse does have a power saving feature, however. According to the
>>> manual, it reduces its power consumption in steps the longer it is inactive. As I frequently work in kde's konsole
>>> terminal application, mouse inactivity is common.
>>>
>>> Hope this helps and feel free to request additional information.
>>
>> Ok - I checked the code and we enable the redundancy mentioned above
>> (2 antenna instead of 1) even if power save is enabled.
>> FWIW - this redundancy is also called "diversity".
>
> <Smile>. Over 30 years working in the IT industry tells me that is a trick vendors have been using for a long time in
> order to try and confuse customers into buying something they've already got! :-)
>>

Oh - we do that all the time, but this is something else :)
It is not very easy to take the good system decision: have the
antennas on all the time and you'll waste power, switch off antennas
and you will lose link quality.
The best would be to make it depend on the network as a whole. This is
what 11k is supposed to solve, but we don't really implement this.
