Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:60747 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934094AbZIOBII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 21:08:08 -0400
Received: by bwz19 with SMTP id 19so2478954bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 18:08:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8ea57b3c57061154c0d312925100c827.squirrel@webmail.ufra.edu.br>
References: <4A9BFCCB.6040808@ufra.edu.br>
	 <3ace41890908311126m5212926cl27172ae775fc92f2@mail.gmail.com>
	 <4A9D7DC0.6050701@ufra.edu.br> <4AAC240E.20104@ufra.edu.br>
	 <3ace41890909130313y474074ecnc5e720f780a4bd8f@mail.gmail.com>
	 <3ace41890909132041w2d3f10b7r72e0eb855f1ab2a5@mail.gmail.com>
	 <43e72e890909132109l4b47431cw85cfba21ec1fb42c@mail.gmail.com>
	 <4AAE7395.1050502@ufra.edu.br>
	 <3ace41890909141411r3d57c6datca12c69cf51c32d9@mail.gmail.com>
	 <8ea57b3c57061154c0d312925100c827.squirrel@webmail.ufra.edu.br>
Date: Tue, 15 Sep 2009 02:08:10 +0100
Message-ID: <3ace41890909141808qcb41032gddbc64a51ac20d32@mail.gmail.com>
Subject: Re: zd1211rw on ppc (iBook G4) -- Solved, somewhat)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Leonardo Hamada <leonardo.hamada@ufra.edu.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(I'd prefer *not* to have one-on-one exchanges, so where appropriate
please CC: the list)

On Tue, Sep 15, 2009 at 12:30 AM, Leonardo Hamada
<leonardo.hamada@ufra.edu.br> wrote:
>
> Em Seg, Setembro 14, 2009 18:11, Hin-Tak Leung escreveu:
>> On Mon, Sep 14, 2009 at 5:47 PM, Leonardo H. Souza Hamada
>> <leonardo.hamada@ufra.edu.br> wrote:
>>
>>> <<<Disabling original zd1211rw in kernel configuration, recompiled
>>> kernel as instructed above, installed new kernel, reboot, many times
>>> until I got it right>>>
>>
>> The patch isn't particularly version-specific - may have applied to
>> the kernel source itself...
>
>
> No, the patch was applied to compat package. The script install what is
> necessary.

I meant the patch should have applied to the vanilla kernel source as
well, if you have gone to the trouble of recompiling the kernel to get
mac80211 as module. (i.e. don't bother with compat-wireless).

>
>
>>
>>> Results:
>>>
>>> dmesg seems ok. no errors.
>>
>> No, I want to see dmesg - there should be something similiar to this?
>>
>> cfg80211: Calling CRDA for country: GB
>> cfg80211: Regulatory domain changed to country: GB
>>       (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>>       (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>>       (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>>       (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
>>       (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
>
>
> I'm sure saw the first line as: cfg80211: Calling CRDA for country: JP
>
> There wasn't the rest (frequency stuff), I think. So this is suspicious.

That's strange. Do you have the crda package installed? You need the
regulatory database userland stuff for crda to work.
http://www.linuxwireless.org/en/developers/Regulatory/CRDA

>>> can do iwlist wlan0
>>>
>>> iwconfig wlan0 shows:
>>> IEEE 802.11bg  Mode:Managed  Access Point: Not-Associated
>>>          Tx-Power=20 dBm
>>>          Retry  long limit:7   RTS thr:off   Fragment thr:off
>>>          Encryption key:off
>>>          Power Management:off
>>>
>>>
>>> I do not seem to be able to connect to a given access point so far. LED
>>> does not blink.
>>
>> stay dark or stay lit?
>>
>
>
> Before ifconfig wlan0 up it stays lit. After it, always dark.

Hmm, I am not familiar with the LED code in zd1211rw - somebody else
please comment.
