Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56017 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbbDXObq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2015 10:31:46 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: implement more versatile set_bitrate_mask
References: <1428672772-9275-1-git-send-email-michal.kazior@tieto.com>
	<87618v44jv.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQnNNKF7riAgcVj1LupABAGodm751jxOUuZgam8u=wthUA@mail.gmail.com>
	<87vbgpzfo0.fsf@kamboji.qca.qualcomm.com>
	<87383szni2.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQkao3kNSCfqi5KdroHL+iHH2fYjZP=oDShjD2VEOM1KnQ@mail.gmail.com>
Date: Fri, 24 Apr 2015 17:31:36 +0300
In-Reply-To: <CA+BoTQkao3kNSCfqi5KdroHL+iHH2fYjZP=oDShjD2VEOM1KnQ@mail.gmail.com>
	(Michal Kazior's message of "Wed, 22 Apr 2015 09:33:06 +0200")
Message-ID: <87fv7ptx6f.fsf@kamboji.qca.qualcomm.com> (sfid-20150424_163151_425223_049270A7)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 22 April 2015 at 08:27, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Kalle Valo <kvalo@qca.qualcomm.com> writes:
>>
>>> Michal Kazior <michal.kazior@tieto.com> writes:
>>>
>>>>> To reduce support questions from the users it would be nice to give few
>>>>> good examples how to use this with iw. And also it makes it easier to
>>>>> test the patch. If you could send something I can add it to the commit
>>>>> log.
>>>>
>>>> Should work:
>>>>
>>>>   iw wlan0 set bitrates legacy 1 6 12 ht-mcs 1 2 3
>>>>   iw wlan0 set bitrates legacy-5 mcs-5 7 8 9
>
> Oh, I just noticed I typo'ed: s/mcs-5/ht-mcs-5/.
>
>
>>>>   iw wlan0 set bitrates legacy-5 24 ht-mcs-5 vht-mcs-5 1:0-9
>>>>
>>>> Won't work:
>>>>
>>>>   iw wlan0 set bitrates legacy-5 ht-mcs-5 vht-mcs-5 1:0-5
>>>>   iw wlan0 set bitrates vht-mcs-5 2:7-9
>>>>
>>>> (note the invalid VHT MCS ranges)
>>>
>>> Thanks, I added these to the commit log.
>>
>> Actually, I had some problems:
>>
>> # iw wlan0 set bitrates legacy-2.4 1 6 12 ht-mcs-2.4 1 2 3
>> command failed: Invalid argument (-22)
>> # iw wlan0 set bitrates legacy-5 1 6 12 ht-mcs-5 1 2 3
>> command failed: Invalid argument (-22)
>
> There's no 1mbps (CCK) on 5GHz. If you remove the "1" from legacy-5 it
> should work.

I fixed the commit now to:

----------------------------------------------------------------------
These work:

  iw wlan0 set bitrates legacy-5 6 12 ht-mcs-5 1 2 3
  iw wlan0 set bitrates legacy-5 ht-mcs-5 7 8 9
  iw wlan0 set bitrates legacy-5 24 ht-mcs-5 vht-mcs-5 1:0-9

These won't work:

  iw wlan0 set bitrates legacy-5 ht-mcs-5 vht-mcs-5 1:0-5
  iw wlan0 set bitrates vht-mcs-5 2:7-9

(note the invalid VHT MCS ranges)
----------------------------------------------------------------------

>> # iw wlan0 set bitrates legacy-5 vht-mcs-5 7 8 9
>> command failed: Invalid argument (-22)
>
> There's a couple of problems here:
>
>  * The syntax for VHT MCS is different: vht-mcs-<2.4|5>
> <NSS:MCSx,MCSy... | NSS:MCSx-MCSy>*
>    You used syntax from HT MCS: ht-mcs-<2.4|5> <MCS index>*
>    The correct way to express this would be:
>       iw wlan0 set bitrates legacy-5 vht-mcs-5 1:7,8,9
>    or
>       iw wlan0 set bitrates legacy-5 vht-mcs-5 1:7-9
>    assuming you wanted NSS=1 (VHT MCS don't imply NSS just like HT MCS do)
>
> * As per commit log you can't use just any VHT MCS; you're limited to
> none, 0-7, 0-8, 0-9. You can set a *single* VHT MCS as per
> 51ab1a0a09a8 ("ath10k: add set_bitrate_mask callback") though.

Thanks, I understand better now.

-- 
Kalle Valo
