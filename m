Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38493 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389AbbDVHdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2015 03:33:07 -0400
Received: by wiun10 with SMTP id n10so46827351wiu.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Apr 2015 00:33:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87383szni2.fsf@kamboji.qca.qualcomm.com>
References: <1428672772-9275-1-git-send-email-michal.kazior@tieto.com>
	<87618v44jv.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQnNNKF7riAgcVj1LupABAGodm751jxOUuZgam8u=wthUA@mail.gmail.com>
	<87vbgpzfo0.fsf@kamboji.qca.qualcomm.com>
	<87383szni2.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 22 Apr 2015 09:33:06 +0200
Message-ID: <CA+BoTQkao3kNSCfqi5KdroHL+iHH2fYjZP=oDShjD2VEOM1KnQ@mail.gmail.com> (sfid-20150422_093314_037980_2858A0CA)
Subject: Re: [PATCH] ath10k: implement more versatile set_bitrate_mask
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 April 2015 at 08:27, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Kalle Valo <kvalo@qca.qualcomm.com> writes:
>
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>>> To reduce support questions from the users it would be nice to give few
>>>> good examples how to use this with iw. And also it makes it easier to
>>>> test the patch. If you could send something I can add it to the commit
>>>> log.
>>>
>>> Should work:
>>>
>>>   iw wlan0 set bitrates legacy 1 6 12 ht-mcs 1 2 3
>>>   iw wlan0 set bitrates legacy-5 mcs-5 7 8 9

Oh, I just noticed I typo'ed: s/mcs-5/ht-mcs-5/.


>>>   iw wlan0 set bitrates legacy-5 24 ht-mcs-5 vht-mcs-5 1:0-9
>>>
>>> Won't work:
>>>
>>>   iw wlan0 set bitrates legacy-5 ht-mcs-5 vht-mcs-5 1:0-5
>>>   iw wlan0 set bitrates vht-mcs-5 2:7-9
>>>
>>> (note the invalid VHT MCS ranges)
>>
>> Thanks, I added these to the commit log.
>
> Actually, I had some problems:
>
> # iw wlan0 set bitrates legacy-2.4 1 6 12 ht-mcs-2.4 1 2 3
> command failed: Invalid argument (-22)
> # iw wlan0 set bitrates legacy-5 1 6 12 ht-mcs-5 1 2 3
> command failed: Invalid argument (-22)

There's no 1mbps (CCK) on 5GHz. If you remove the "1" from legacy-5 it
should work.


> # iw wlan0 set bitrates legacy-5 vht-mcs-5 7 8 9
> command failed: Invalid argument (-22)

There's a couple of problems here:

 * The syntax for VHT MCS is different: vht-mcs-<2.4|5>
<NSS:MCSx,MCSy... | NSS:MCSx-MCSy>*
   You used syntax from HT MCS: ht-mcs-<2.4|5> <MCS index>*
   The correct way to express this would be:
      iw wlan0 set bitrates legacy-5 vht-mcs-5 1:7,8,9
   or
      iw wlan0 set bitrates legacy-5 vht-mcs-5 1:7-9
   assuming you wanted NSS=1 (VHT MCS don't imply NSS just like HT MCS do)

* As per commit log you can't use just any VHT MCS; you're limited to
none, 0-7, 0-8, 0-9. You can set a *single* VHT MCS as per
51ab1a0a09a8 ("ath10k: add set_bitrate_mask callback") though.


Michał
