Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:55877 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbbALGDC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 01:03:02 -0500
Received: by mail-lb0-f176.google.com with SMTP id p9so16032682lbv.7
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jan 2015 22:03:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54B2DBAF.7010208@googlemail.com>
References: <54B272F0.70307@googlemail.com>
	<54B273E1.6030306@googlemail.com>
	<CANUX_P2PiGUBaw89Rb2zSuy2x8=GJN=o6XgcasdVMtvoy6kmAQ@mail.gmail.com>
	<54B2DBAF.7010208@googlemail.com>
Date: Mon, 12 Jan 2015 08:03:00 +0200
Message-ID: <CANUX_P1Bdz4R2WUK53fx7r5CuvBmyBdqZWwR+Of=1mi7VncqZQ@mail.gmail.com> (sfid-20150112_070344_967719_2AAFAA18)
Subject: Re: IWLWIFI - 3.18-stable
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Chris Clayton <chris2553@googlemail.com>
Cc: kvalo@codeaurora.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 11, 2015 at 10:23 PM, Chris Clayton
<chris2553@googlemail.com> wrote:
> Thanks Emmanuel.
>
> On 01/11/15 14:16, Emmanuel Grumbach wrote:
>> Hi Chris,
>>
>> thank you for you analysis, it is very helpful
>>
>
> You're welcome.
>
>>> Doh! Cut and paste error ...
>>>
>>> On 01/11/15 12:56, Chris Clayton wrote:
>>>> Hi Kalle,
>>>>
>>>> Having recently bought a new laptop, I've just started using the iwlwifi driver for wireless networking. I found both
>>>> 3.18.x and the current development tree to be very unreliable due to frequent disconnections from the router.
>>>>
>>>> Before you merged them into your tree, I grabbed the latest fixes from iwlwifi-fixes tree and applied them to the
>>>> development kernel. Since I did that I've had no problems at all with dropped connections. I then looked at each patch
>>>> to see whether it might be applicable to 3.18 and found that two of them looked as if they should be useful. They are:
>>>>
>>>> c93edc639392df733c7d72db4376a9add775d18a - iwlwifi: mvm: don't allow diversity if BT Coex / TT forbid it
>>>
>>> The above should have been:
>>>
>>> c93edc639392df733c7d72db4376a9add775d18a - iwlwifi: mvm: fix Rx with both chains
>>>
>>>>
>>>> a9dc5060bf3a32ac3dad472f15416054b92dc5b5 - iwlwifi: mvm: fix out of bounds access to tid_to_mac80211_ac
>>>>
>>>> With those two applied, I've had stable wireless networking on 3.18.2 and, more recently, 3.18.2. Consequently, they
>>>> seem appropriate for tagging for 3.18-stable, but, as far as I can see, they haven't been tagged for stable. Apologies,
>>>> if I'm mistaken, but if I'm not, could you consider submitting the two patches for inclusion in 3.18, please? Of course,
>>>> they may be appropriate to earlier kernels too - I haven't looked.
>>>>
>>
>> The first one (c93edc639392df733c7d72db4376a9add775d18a) is tagged for stable.
>
> Ah, sorry I missed that.
>
>> Are you using bluetooth?
>
> Yes, I have a bluetooth mouse and use bluetooth for audio from time to time.
>
>> Are you able to tell me which of the two really helps?
>
> It's c93edc639392df733c7d72db4376a9add775d18a that helps. With that applied, I can set off a task which, in a loop,
> continually copies a 180MB file from a server on my network. The network remained stable for over 30 minutes before I
> killed the task. Without the patch, the network fails during the first iteration of copying the file.
>
> a9dc5060bf3a32ac3dad472f15416054b92dc5b5 doesn't seem to have any effect on the instability.

Ok - I am not surprised - thanks.
c93edc... allows to use 2 antennas instead of one only. Technically,
one would be enough, but apparently, in your configuration, using 2
antennas allows to improve reliability.

>
>
>> Unless I am missing something, the first one
>> (c93edc639392df733c7d72db4376a9add775d18a) should help only if you
>> disabled power save. Is that the case?
>
> Not that I know of. The only power-related thing in my init scripts is echoing 5 to /proc/sys/vm/laptop_mode, which I
> believe configures disk activity to save power. The mouse does have a power saving feature, however. According to the
> manual, it reduces its power consumption in steps the longer it is inactive. As I frequently work in kde's konsole
> terminal application, mouse inactivity is common.
>
> Hope this helps and feel free to request additional information.

Ok - I checked the code and we enable the redundancy mentioned above
(2 antenna instead of 1) even if power save is enabled.
FWIW - this redundancy is also called "diversity".

Thanks.

>
> Chris
>>
