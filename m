Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52978 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932721AbbDVG1Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2015 02:27:25 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: implement more versatile set_bitrate_mask
References: <1428672772-9275-1-git-send-email-michal.kazior@tieto.com>
	<87618v44jv.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQnNNKF7riAgcVj1LupABAGodm751jxOUuZgam8u=wthUA@mail.gmail.com>
	<87vbgpzfo0.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 22 Apr 2015 09:27:17 +0300
In-Reply-To: <87vbgpzfo0.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Tue, 21 Apr 2015 18:04:15 +0300")
Message-ID: <87383szni2.fsf@kamboji.qca.qualcomm.com> (sfid-20150422_082735_227012_E4320E89)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Michal Kazior <michal.kazior@tieto.com> writes:
>
>>> To reduce support questions from the users it would be nice to give few
>>> good examples how to use this with iw. And also it makes it easier to
>>> test the patch. If you could send something I can add it to the commit
>>> log.
>>
>> Should work:
>>
>>   iw wlan0 set bitrates legacy 1 6 12 ht-mcs 1 2 3
>>   iw wlan0 set bitrates legacy-5 mcs-5 7 8 9
>>   iw wlan0 set bitrates legacy-5 24 ht-mcs-5 vht-mcs-5 1:0-9
>>
>> Won't work:
>>
>>   iw wlan0 set bitrates legacy-5 ht-mcs-5 vht-mcs-5 1:0-5
>>   iw wlan0 set bitrates vht-mcs-5 2:7-9
>>
>> (note the invalid VHT MCS ranges)
>
> Thanks, I added these to the commit log.

Actually, I had some problems:

# iw wlan0 set bitrates legacy-2.4 1 6 12 ht-mcs-2.4 1 2 3
command failed: Invalid argument (-22)
# iw wlan0 set bitrates legacy-5 1 6 12 ht-mcs-5 1 2 3
command failed: Invalid argument (-22)
# iw wlan0 set bitrates legacy-5 vht-mcs-5 7 8 9
command failed: Invalid argument (-22)
# iw wlan0 set bitrates legacy-5 24 ht-mcs-5 vht-mcs-5 1:0-9
# 

The first one I understand as this CUS223 board only supports 5G. But
why did the second and third command fail?

-- 
Kalle Valo
