Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51600 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab2HES0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2012 14:26:35 -0400
Received: by obbuo13 with SMTP id uo13so4579961obb.19
        for <linux-wireless@vger.kernel.org>; Sun, 05 Aug 2012 11:26:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <501E68EE.1060000@net.t-labs.tu-berlin.de>
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	<1343059275-49590-2-git-send-email-thomas@net.t-labs.tu-berlin.de>
	<501CD9F3.4000903@net.t-labs.tu-berlin.de>
	<CAFtRNNzV+vwCcg7APcjUUA4f7zhphH4=v4KshUq5XYKWHmBdhQ@mail.gmail.com>
	<501E539A.9060706@net.t-labs.tu-berlin.de>
	<CAFtRNNyXgrzsB8Od+qqLgRSb3o_KkxD4sG3UOzu5C1Sz06-GkA@mail.gmail.com>
	<501E68EE.1060000@net.t-labs.tu-berlin.de>
Date: Sun, 5 Aug 2012 21:26:35 +0300
Message-ID: <CAFtRNNzdnJjeZ4i=caV4eErFzF4sjFft3u6RQ4v_VOuNyaAZ0A@mail.gmail.com> (sfid-20120805_202715_945833_DA915C1F)
Subject: Re: [ath5k-devel] [PATCH 1/2] ath5k: fix wrong per rate target power
 eeprom reads for AR5K_EEPROM_MODE_11A
From: Nick Kossifidis <mickflemm@gmail.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: nbd@nbd.name, jirislaby@gmail.com, linux-wireless@vger.kernel.org,
	mcgrof@qca.qualcomm.com, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/8/5 Thomas Huehn <thomas@net.t-labs.tu-berlin.de>:
> Hi Nick
>
>> According to EEPROM docs there are 10 calibration piers on all chips
>> after 5111 for 11a but some of them are not used and the way to test
>> this is if frequency is zero. Now here is a bug in the EEPROM code
>> that might result the wrong reads you get, check this out:
>>
>> on ath5k_eeprom_read_freq_list we do this
>>
>> if (!freq1)
>>  break;
>>
>> instead of this
>>
>> if (!freq1)
>>  continue;
>
>
> That did the trick !
> So reading 10 calibration piers and using the fix from above works in
> terms of tx_power changes on CM9 and DCMA82 are properly used by the
> hardware.
>
> I will send a patch for that.
>
>
> Greetings Thomas
>

I have some time right now so I'll re-send my patches (one of them
needs a fix anyway) together with this one to make John's job easier.
Send your EEPROM patch on top of them so that he can see it (remember
to CC him).


-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
