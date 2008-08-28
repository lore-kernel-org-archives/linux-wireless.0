Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from winston.telenet-ops.be ([195.130.137.75]:45900 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbYH1X6u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 19:58:50 -0400
Message-ID: <48B73BB8.7000302@telenet.be> (sfid-20080829_015855_122802_4553C790)
Date: Fri, 29 Aug 2008 01:58:48 +0200
From: Ian Schram <ischram@telenet.be>
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwl5000 oopses
References: <1217937364.3603.37.camel@johannes.berg>	 <1217938927.3603.40.camel@johannes.berg>	 <1ba2fa240808050820j1aa0ae7cj11f2758caa5ba4df@mail.gmail.com>	 <1219919760.8434.5.camel@johannes.berg>	 <1ba2fa240808280439m3524d17cm63deebdfc0d5b9dd@mail.gmail.com>	 <1219925859.25321.10.camel@johannes.berg>	 <1ba2fa240808280752t4b41996au43bf4cb1a61b7967@mail.gmail.com>	 <48B6C7EA.7080606@telenet.be> <1ba2fa240808281430q7be3bb1eg8724af7247372efb@mail.gmail.com>
In-Reply-To: <1ba2fa240808281430q7be3bb1eg8724af7247372efb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Tomas Winkler wrote:
> On Thu, Aug 28, 2008 at 6:44 PM, Ian Schram <ischram@telenet.be> wrote:
>>
>> Tomas Winkler wrote:
>>> On Thu, Aug 28, 2008 at 3:17 PM, Johannes Berg
>>> <johannes@sipsolutions.net> wrote:
>>>> On Thu, 2008-08-28 at 14:39 +0300, Tomas Winkler wrote:
>>>>> On Thu, Aug 28, 2008 at 1:36 PM, Johannes Berg
>>>>> <johannes@sipsolutions.net> wrote:
>>>>>> On Tue, 2008-08-05 at 18:20 +0300, Tomas Winkler wrote:
>>>>>>> On Tue, Aug 5, 2008 at 3:22 PM, Johannes Berg
>>>>>>> <johannes@sipsolutions.net> wrote:
>>>>>>>>> This is kernel 2.6.27-rc1-00504-g2b12a4c-dirty
>>>>>>>> [  126.826663] iwlagn: Intel(R) Wireless WiFi Link AGN driver for
>>>>>>>> Linux, 1.3.27kds
>>>>>>>> [  126.826947] iwlagn: Copyright(c) 2003-2008 Intel Corporation
>>>>>>>> [  126.828369] iwlagn: Detected Intel Wireless WiFi Link 5350AGN
>>>>>>>> REV=0x24
>>>>>>>> [  126.848680] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a
>>>>>>>> channels
>>>>>>>> [  127.014564] firmware: requesting iwlwifi-5000-1.ucode
>>>>>>>> [  127.170640] iwlagn: Error wrong command queue 43 command id 0x6B
>>>>>>>> [  127.170832] ------------[ cut here ]------------
>>>>>>>> [  127.170884] kernel BUG at
>>>>>>>> drivers/net/wireless/iwlwifi/iwl-tx.c:1163!
>>>>>>>> [  127.170941] Oops: Exception in kernel mode, sig: 5 [#1]
>>>>>> This is still happening with -rc4.
>>>>> I know, at least one regression.
>>>> Well, I guess for me the addition of the 5000 series code to the kernel
>>>> is the regression, without it I can use the machine just fine, just have
>>>> no wireless ;)
>>> And when I say that driver is half backed because I'm not done
>>> cleaning bugs it's somehow not understood
>>> Instead of chasing bugs I have to spend time to fitght the system.
>>> Tomas
>>> --
>> Probably a good idea to not see this as
>> ,,you vs system'' ..  Anyways that discussion is going on in other threads
>> perhaps we can focus on what has to be done about this bug.
>>
>> what's known about this bug? ad where does it trigger? reproducible?
>>
>> the error message clearly shows an invalid queue id (43 or 0x2b) where it
>> should be
>> a number in the range of [0,4], this is multiqueue related?
>>
>> the value in this error message was set by the driver, and then relayed by
>> the ucode
>> in order to know which "command" this is a response to.
>>
>> assuming there is no memory corruption, and the ucode is correct, ...
>>
>> It might be set wrong. The value that is set is either the command queue, or
>> a
>> tx_command queue which is determined by a call to skb_get_queue_mapping(skb)
>>
>> might be nice to add some debug output documenting what this function is
>> returning.
>>
>>
>>
>> finally can i quickly ask why these macro's (that "encode" this queue id to
>> the field in which it's passed to the ucode):
>> #define SEQ_TO_QUEUE(x)  ((x >> 8) & 0xbf)
>> #define QUEUE_TO_SEQ(x)  ((x & 0xbf) << 8)
>> use 0xbf, when according to the sourcecode comments it only uses the last 6
>> bits, hence i would
>> expect 0x3f. In QUEUE_TO_SEQ this msb should never be set .. so i wonder if
>> there is a hack
>> i'm missing somewhere.
> 
> Actually this is the correct settings (there is still a lot of old
> days junk in the code)
> 
> +#define SEQ_TO_QUEUE(s)        (((s) >> 8) & 0x1f)
> +#define QUEUE_TO_SEQ(q)        (((q) & 0x1f) << 8)
> +#define SEQ_TO_INDEX(s)        ((s) & 0xff)
> +#define INDEX_TO_SEQ(i)        ((i) & 0xff)
> 
> Yet this is not it an issue first of all it works pretty well I never

True. 0x1f seems slightly inconsistent with  the iwl-command.h, but
that's not really the issue right now.

> hit this one if not under load.
> ' Error wrong command queue 43 command id ___0x6B___'  6b looks more
> like slub poison -- accessing already freed skb
> 
> Thanks
> Tomas

hmm, 0x6B indeed is not a documented command ID...
Only triggering under load must point to some overflow or race i guess.

I should get myself a new laptop to be able to play with this...
The best i can do now, is wonder if this patch
"[PATCH 08/10] iwlwifi: decrement rx skb counter in scan abort handler"
might be responsible, but that's just fuzzy string matching "recent patches" with
"freed skb" ;-)
