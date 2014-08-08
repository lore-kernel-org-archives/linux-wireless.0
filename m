Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1562 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989AbaHHLEV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2014 07:04:21 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/6] ath10k: remove target soc ps code
References: <1407402212-29809-1-git-send-email-michal.kazior@tieto.com>
	<1407402212-29809-3-git-send-email-michal.kazior@tieto.com>
	<878umzz2d0.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQnvS2C9_C7qkrX5cPLa8weHx_FmS8Gd=d2Pf=EAmf9EiQ@mail.gmail.com>
Date: Fri, 8 Aug 2014 14:04:13 +0300
In-Reply-To: <CA+BoTQnvS2C9_C7qkrX5cPLa8weHx_FmS8Gd=d2Pf=EAmf9EiQ@mail.gmail.com>
	(Michal Kazior's message of "Fri, 8 Aug 2014 13:00:56 +0200")
Message-ID: <87zjffxmxe.fsf@kamboji.qca.qualcomm.com> (sfid-20140808_130424_765434_0D434062)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 8 August 2014 12:45, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> The soc powersave was disabled by default. It
>>> never was fully tested. Some hw apparently had
>>> problems with it and the implementation itself had
>>> a possible race.
>>>
>>> Just remove the refcounting and simply wake up the
>>> device when probing and put to sleep when
>>> removing.
>>>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>
>> This one introduced new warnings:
>>
>> drivers/net/wireless/ath/ath10k/pci.c:646:5: warning: symbol 'ath10k_pci_wake' was not declared. Should it be static?
>> drivers/net/wireless/ath/ath10k/pci.c:653:6: warning: symbol 'ath10k_pci_sleep' was not declared. Should it be static?
>
> I didn't catch this for some reason. Can you share how you run
> checkpatch, please?

I think these are coming from sparse, in essence I run this:

make drivers/net/wireless/ath/ath10k/ C=2 CF="-D__CHECK_ENDIAN__"

Which reminds me that I should add -D__CHECK_ENDIAN__ to the makefile.

-- 
Kalle Valo
