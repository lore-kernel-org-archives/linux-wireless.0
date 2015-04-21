Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35515 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbbDUPEY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2015 11:04:24 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: implement more versatile set_bitrate_mask
References: <1428672772-9275-1-git-send-email-michal.kazior@tieto.com>
	<87618v44jv.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQnNNKF7riAgcVj1LupABAGodm751jxOUuZgam8u=wthUA@mail.gmail.com>
Date: Tue, 21 Apr 2015 18:04:15 +0300
In-Reply-To: <CA+BoTQnNNKF7riAgcVj1LupABAGodm751jxOUuZgam8u=wthUA@mail.gmail.com>
	(Michal Kazior's message of "Fri, 17 Apr 2015 09:30:51 +0200")
Message-ID: <87vbgpzfo0.fsf@kamboji.qca.qualcomm.com> (sfid-20150421_170432_378259_FC546F5C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

>> To reduce support questions from the users it would be nice to give few
>> good examples how to use this with iw. And also it makes it easier to
>> test the patch. If you could send something I can add it to the commit
>> log.
>
> Should work:
>
>   iw wlan0 set bitrates legacy 1 6 12 ht-mcs 1 2 3
>   iw wlan0 set bitrates legacy-5 mcs-5 7 8 9
>   iw wlan0 set bitrates legacy-5 24 ht-mcs-5 vht-mcs-5 1:0-9
>
> Won't work:
>
>   iw wlan0 set bitrates legacy-5 ht-mcs-5 vht-mcs-5 1:0-5
>   iw wlan0 set bitrates vht-mcs-5 2:7-9
>
> (note the invalid VHT MCS ranges)

Thanks, I added these to the commit log.

-- 
Kalle Valo
