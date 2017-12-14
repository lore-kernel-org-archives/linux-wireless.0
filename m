Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36612 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753353AbdLNQU2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 11:20:28 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Colin Ian King <colin.king@canonical.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, nbd@nbd.name,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x2: eeprom: fix typo in mt76x2_get_power_info_5g()
References: <cover.1513248071.git.lorenzo.bianconi@redhat.com>
        <2ae397aff0b058615a558a2352067fad2c9201e6.1513248071.git.lorenzo.bianconi@redhat.com>
        <68bc67c3-9c9a-e059-2a2a-1e8ccd5b92f5@canonical.com>
Date: Thu, 14 Dec 2017 18:20:19 +0200
In-Reply-To: <68bc67c3-9c9a-e059-2a2a-1e8ccd5b92f5@canonical.com> (Colin Ian
        King's message of "Thu, 14 Dec 2017 15:42:43 +0000")
Message-ID: <87bmj1cmd8.fsf@purkki.adurom.net> (sfid-20171214_172317_872287_87CA4491)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> writes:

> On 14/12/17 10:46, Lorenzo Bianconi wrote:
>> Fix typo in 5GHz power vs channel eeprom parsing
>> 
>> Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
>> ---
>>  drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
>> index 440b7e7d73a9..29dc52ef629d 100644
>> --- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
>> +++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
>> @@ -524,7 +524,7 @@ mt76x2_get_power_info_5g(struct mt76x2_dev *dev, struct mt76x2_tx_power_info *t,
>>  
>>  	if (channel >= 192)
>>  		delta_idx = 4;
>> -	else if (channel >= 484)
>> +	else if (channel >= 184)
>>  		delta_idx = 3;
>>  	else if (channel < 44)
>>  		delta_idx = 3;
>> 
> any possibility of adding:
>
> Reported-by: Colin Ian King <colin.king@canonical.com>

Sure, I'll add that during commit.

-- 
Kalle Valo
