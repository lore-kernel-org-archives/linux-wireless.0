Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49832 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab2HEM7A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2012 08:59:00 -0400
Received: by obbuo13 with SMTP id uo13so4219322obb.19
        for <linux-wireless@vger.kernel.org>; Sun, 05 Aug 2012 05:59:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <501E68EE.1060000@net.t-labs.tu-berlin.de>
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	<1343059275-49590-2-git-send-email-thomas@net.t-labs.tu-berlin.de>
	<501CD9F3.4000903@net.t-labs.tu-berlin.de>
	<CAFtRNNzV+vwCcg7APcjUUA4f7zhphH4=v4KshUq5XYKWHmBdhQ@mail.gmail.com>
	<501E539A.9060706@net.t-labs.tu-berlin.de>
	<CAFtRNNyXgrzsB8Od+qqLgRSb3o_KkxD4sG3UOzu5C1Sz06-GkA@mail.gmail.com>
	<501E68EE.1060000@net.t-labs.tu-berlin.de>
Date: Sun, 5 Aug 2012 15:59:00 +0300
Message-ID: <CAFtRNNyF4Hm=U2LiJqpb60m6yjp+Hf1bi_Cth39H4QAHYZrPsA@mail.gmail.com> (sfid-20120805_145912_980472_4F83F422)
Subject: Re: [ath5k-devel] [PATCH 1/2] ath5k: fix wrong per rate target power
 eeprom reads for AR5K_EEPROM_MODE_11A
From: Nick Kossifidis <mickflemm@gmail.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: nbd@nbd.name, jirislaby@gmail.com, linux-wireless@vger.kernel.org,
	mcgrof@qca.qualcomm.com, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>,
	Adrian Chadd <adrian@freebsd.org>
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

CCing Adrian in case this bug is also present on newer HAL sources on
FreeBSD etc...

Thanks for testing/patching Thomas, I 'll try to find some time to
work on EEPROM code again, I know it's a mess :P


-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
