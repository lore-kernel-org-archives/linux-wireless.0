Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44537 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab2F0POL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 11:14:11 -0400
Message-ID: <4FEB233D.4070604@qca.qualcomm.com> (sfid-20120627_171420_611303_CC1FA0A9)
Date: Wed, 27 Jun 2012 20:44:05 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Felix Fietkau <nbd@openwrt.org>, <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: Re: [PATCH 2/2] ath9k: Fix signedness in a MCI debug message
References: <1340807427-5774-1-git-send-email-mohammed@qca.qualcomm.com> <1340807427-5774-2-git-send-email-mohammed@qca.qualcomm.com> <4FEB1D43.7080706@openwrt.org> <4FEB201D.1020009@qca.qualcomm.com>
In-Reply-To: <4FEB201D.1020009@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 27 June 2012 08:30 PM, Mohammed Shafi Shajakhan wrote:
> Hi Felix,
>
> On Wednesday 27 June 2012 08:18 PM, Felix Fietkau wrote:
>> On 2012-06-27 4:30 PM, Mohammed Shafi Shajakhan wrote:
>>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>>
>>> seems i got a message like this
>>> ath: phy0: BT_Status_Update: is_link=0, linkId=2,
>>> state=1, SEQ=-2085766476 initially.
>>>
>>> Signed-off-by: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>> ---
>>> drivers/net/wireless/ath/ath9k/mci.c | 2 +-
>>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath9k/mci.c
>>> b/drivers/net/wireless/ath/ath9k/mci.c
>>> index c40e568..64cc782 100644
>>> --- a/drivers/net/wireless/ath/ath9k/mci.c
>>> +++ b/drivers/net/wireless/ath/ath9k/mci.c
>>> @@ -348,7 +348,7 @@ static void ath_mci_msg(struct ath_softc *sc, u8
>>> opcode, u8 *rx_payload)
>>>
>>> seq_num = *((u32 *)(rx_payload + 12));
>>> ath_dbg(common, MCI,
>>> - "BT_Status_Update: is_link=%d, linkId=%d, state=%d, SEQ=%d\n",
>>> + "BT_Status_Update: is_link=%d, linkId=%d, state=%d, SEQ=%u\n",
>>> profile_status.is_link, profile_status.conn_handle,
>>> profile_status.is_critical, seq_num);
>> What about endian here? Also, wouldn't it be better to have a struct for
>> the rx payload data with proper endian annotation instead of using the
>> weird way of dereferencing the rx_payload pointer?
>>
>
> ok, we shall fix it soon.
>
>

Hi John, please pick this patch, we shall address Felix's suggestion in 
a separate patch, i think it needs a bit of rework.


-- 
thanks,
shafi
