Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:35944 "EHLO
	mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbbJWVRb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 17:17:31 -0400
Received: by lffz202 with SMTP id z202so97176562lff.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2015 14:17:30 -0700 (PDT)
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com> <1445323546-12807-14-git-send-email-jsitnicki@gmail.com> <wrfjtwplug7v.fsf@redhat.com>
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 13/16] rtl8xxxu: Make set_tx_power a chip-type-dependent operation
In-reply-to: <wrfjtwplug7v.fsf@redhat.com>
Date: Fri, 23 Oct 2015 23:17:28 +0200
Message-ID: <87mvv9e13r.fsf@frog.home> (sfid-20151023_231733_997013_2B5D6003)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 21, 2015 at 04:07 AM CEST, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> Jakub Sitnicki <jsitnicki@gmail.com> writes:
>> Preparatory step for adding support for RTL8188EU chips.
>>
>> Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
>> ---
>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 6 ++++--
>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 1 +
>>  2 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> index 83cdc2a..ecda799 100644
>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> @@ -4223,7 +4223,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
>>  	/*
>>  	 * Start out with default power levels for channel 6, 20MHz
>>  	 */
>> -	rtl8723a_set_tx_power(priv, 1, false);
>> +	priv->fops->set_tx_power(priv, 1, false);
>>  
>>  	/* Let the 8051 take control of antenna setting */
>>  	val8 = rtl8xxxu_read8(priv, REG_LEDCFG2);
>> @@ -5207,7 +5207,7 @@ static int rtl8xxxu_config(struct ieee80211_hw *hw, u32 changed)
>>  
>>  		channel = hw->conf.chandef.chan->hw_value;
>>  
>> -		rtl8723a_set_tx_power(priv, channel, ht40);
>> +		priv->fops->set_tx_power(priv, channel, ht40);
>>  
>>  		rtl8723au_config_channel(hw);
>>  	}
>> @@ -5781,6 +5781,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
>>  	.parse_efuse = rtl8723au_parse_efuse,
>>  	.load_firmware = rtl8723au_load_firmware,
>>  	.power_on = rtl8723au_power_on,
>> +	.set_tx_power = rtl8723a_set_tx_power,
>>  	.efuse_len = EFUSE_REAL_CONTENT_LEN_8723A,
>>  	.writeN_block_size = 1024,
>>  };
>> @@ -5789,6 +5790,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
>>  	.parse_efuse = rtl8192cu_parse_efuse,
>>  	.load_firmware = rtl8192cu_load_firmware,
>>  	.power_on = rtl8192cu_power_on,
>> +	.set_tx_power = rtl8723a_set_tx_power,
>>  	.efuse_len = EFUSE_REAL_CONTENT_LEN_8723A,
>>  	.writeN_block_size = 128,
>>  };
>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
>> index 1a767eb..427eb7e 100644
>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
>> @@ -679,6 +679,7 @@ struct rtl8xxxu_fileops {
>>  	int (*parse_efuse) (struct rtl8xxxu_priv *priv);
>>  	int (*load_firmware) (struct rtl8xxxu_priv *priv);
>>  	int (*power_on) (struct rtl8xxxu_priv *priv);
>> +	void (*set_tx_power) (struct rtl8xxxu_priv *priv, int channel, bool ht40);
>>  	int efuse_len;
>>  	int writeN_block_size;
>>  };
>
> Lets not add function pointers before we actually know we have a need
> for them.

OK, will hold on to this patch in my queue.

-Jakub
