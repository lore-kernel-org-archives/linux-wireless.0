Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37656 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933782AbbBQLD1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2015 06:03:27 -0500
Message-ID: <54E31F04.80303@qti.qualcomm.com> (sfid-20150217_120330_355745_8F8B43F0)
Date: Tue, 17 Feb 2015 16:29:16 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 2/2] ath10k: Fix interrupt storm
References: <1424158996-8830-1-git-send-email-vthiagar@qti.qualcomm.com>	<1424158996-8830-2-git-send-email-vthiagar@qti.qualcomm.com> <CA+BoTQm9-VyEu3D2tR0EHJ-kh15z8WB4h-NzC6uZGCPPxM7NXA@mail.gmail.com>
In-Reply-To: <CA+BoTQm9-VyEu3D2tR0EHJ-kh15z8WB4h-NzC6uZGCPPxM7NXA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Tuesday 17 February 2015 02:53 PM, Michal Kazior wrote:
> On 17 February 2015 at 08:43, Vasanthakumar Thiagarajan
> <vthiagar@qti.qualcomm.com> wrote:
>> Promiscuous mode is enabled when wlan interface is added to
>> bridge. ath10k creates a monitor mode when promiscuous mode
>> is enabled. When monitor vdev is runing along with other
>> vdev(s) there is a huge number of interrupts generated
>> especially in noisy condition. Fix this by not enabling
>> promiscuous(monitor) mode when already a vdev is running.
>> This does not change the support of virtual interface of
>> type monitor along with other vdevs.
>>
>> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/mac.c |   16 ++++++++++++++++
>>   1 file changed, 16 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>> index 3b5aaa3..66cc0a8 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -969,6 +969,15 @@ static int ath10k_vdev_start_restart(struct ath10k_vif *arvif, bool restart)
>>          ar->num_started_vdevs++;
>>          ath10k_recalc_radar_detection(ar);
>>
>> +       if (ar->filter_flags & FIF_PROMISC_IN_BSS) {
>> +               ar->filter_flags &= ~FIF_PROMISC_IN_BSS;
>> +               ath10k_dbg(ar, ATH10K_DBG_MAC,
>> +                          "mac disabling promiscuous mode because vdev is started\n");
>> +               ret = ath10k_monitor_recalc(ar);
>
> The entire logic should go to ath10k_monitor_recalc().

Sure.

>
> Also I'm pretty sure this breaks 4addr station briding for main 636
> fw. I can't fully test this now though (there seems to be a regression
> against fw 636 and it keeps crashing with monitor vdev over and over
> again).

Ok. Can we make this change specific to non-sta mode?.

Vasanth
>
> Michał
>
