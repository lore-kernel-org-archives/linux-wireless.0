Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21132 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab1IBI4D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 04:56:03 -0400
Message-ID: <4E609A1D.4070104@qca.qualcomm.com> (sfid-20110902_105609_222321_5E6F3A52)
Date: Fri, 2 Sep 2011 11:55:57 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath6kl: Fix endianness with chip register values
References: <1314785895-18808-1-git-send-email-vthiagar@qca.qualcomm.com> <20110831114907.GA1958@vasanth-laptop> <20110901100814.GA13679@vasanth-laptop>
In-Reply-To: <20110901100814.GA13679@vasanth-laptop>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/01/2011 01:08 PM, Vasanthakumar Thiagarajan wrote:
> On Wed, Aug 31, 2011 at 05:19:08PM +0530, Vasanthakumar Thiagarajan wrote:
>> On Wed, Aug 31, 2011 at 03:48:14PM +0530, Vasanthakumar Thiagarajan wrote:
>>> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
>>> ---
>>>  drivers/net/wireless/ath/ath6kl/main.c |   14 ++++++++++----
>>>  1 files changed, 10 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
>>> index 5e807a9..0bcfd46 100644
>>> --- a/drivers/net/wireless/ath/ath6kl/main.c
>>> +++ b/drivers/net/wireless/ath/ath6kl/main.c
>>> @@ -234,6 +234,7 @@ static int ath6kl_set_addrwin_reg(struct ath6kl *ar, u32 reg_addr, u32 addr)
>>>  int ath6kl_diag_read32(struct ath6kl *ar, u32 address, u32 *value)
>>>  {
>>>  	int ret;
>>> +	__le32 reg_val = 0;
>>>  
>>>  	/* set window register to start read cycle */
>>>  	ret = ath6kl_set_addrwin_reg(ar, WINDOW_READ_ADDR_ADDRESS, address);
>>> @@ -241,8 +242,10 @@ int ath6kl_diag_read32(struct ath6kl *ar, u32 address, u32 *value)
>>>  		return ret;
>>>  
>>>  	/* read the data */
>>> -	ret = hif_read_write_sync(ar, WINDOW_DATA_ADDRESS, (u8 *) value,
>>> -				  sizeof(*value), HIF_RD_SYNC_BYTE_INC);
>>> +	ret = hif_read_write_sync(ar, WINDOW_DATA_ADDRESS, (u8 *) &reg_val,
>>> +				  sizeof(reg_val), HIF_RD_SYNC_BYTE_INC);
>>> +	*value = le32_to_cpu(reg_val);
>>> +
>>
>> This would break your fw_log patch where it is assumed that
>> the register value read through ath6kl_diag_read32() is LE.
>> Shall I remove endian conversion from your patch and send it
>> as a separate one which would be part of this series?.
>> Having endian conversion in a single place would be simple
>> and bug free.
> 
> I think we should leave endian conversion to the caller during
> register read/write. So this patch can be dropped. But i still think
> my other patch which takes care of endianness for register address
> is needed as the address is again processed on host in
> ath6kl_set_addrwin_reg().

Ok, I'm dropping this patch.

Kalle
