Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbbJZRpY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2015 13:45:24 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Jakub Sitnicki <jsitnicki@gmail.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 16/16] rtl8xxxu: rtl8188eu: Implement parse_efuse()
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com>
	<1445323546-12807-17-git-send-email-jsitnicki@gmail.com>
	<wrfjpp09ufv3.fsf@redhat.com> <87lhatdzhn.fsf@frog.home>
Date: Mon, 26 Oct 2015 13:45:23 -0400
In-Reply-To: <87lhatdzhn.fsf@frog.home> (Jakub Sitnicki's message of "Fri, 23
	Oct 2015 23:52:20 +0200")
Message-ID: <wrfjh9ld34ng.fsf@redhat.com> (sfid-20151026_184531_491440_27D0E262)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Sitnicki <jsitnicki@gmail.com> writes:
> On Wed, Oct 21, 2015 at 04:15 AM CEST, Jes Sorensen
> <Jes.Sorensen@redhat.com> wrote:
>> Jakub Sitnicki <jsitnicki@gmail.com> writes:
>>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
>>> index 79f47e3..ec49504 100644
>>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
>>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
>>> @@ -507,6 +507,22 @@ struct rtl8192cu_efuse {
>>>  	u8 customer_id;
>>>  };
>>>  
>>> +struct rtl8188eu_efuse {
>>> +	__le16 rtl_id;
>>> +	u8 res0[0x0e];
>>> +	struct {						/* 0x10 */
>>> +		u8 cck_index_A[6];
>>> +		u8 ht40_1s_index_A[5];
>>> +		struct nibble_pair ht20_ofdm_index_diff[1];
>>> +	} tx_power;
>>> +	u8 res1[0xbb];
>>> +	u8 mac_addr[ETH_ALEN];					/* 0xd7 */
>>> +	u8 res2[0x02];
>>> +	u8 vendor_name[7];					/* 0xdf */
>>> +	u8 res3[0x02];
>>> +	u8 device_name[11];					/* 0xe8 */
>>> +};
>>
>> This is incomplete - I think it should look more like this:
>>
>> struct rtl8188eu_efuse {
>> 	__le16 rtl_id;
>> 	u8 res0[0x0e];
>> 	u8 cck_tx_power_index_A[3];	/* 0x10 */
>> 	u8 cck_tx_power_index_B[3];
>> 	u8 ht40_1s_tx_power_index_A[3];	/* 0x16 */
>> 	u8 ht40_1s_tx_power_index_B[3];
>> 	u8 res1[0x9c];
>> 	u8 channel_plan;		/* 0xb8 */
>> 	u8 xtal_k;
>> 	u8 thermal_meter;
>> 	u8 iqk_lck;
>> 	u8 res2[5];
>> 	u8 rf_board_option;
>> 	u8 rf_feature_option;
>> 	u8 rf_bt_setting;
>> 	u8 eeprom_version;
>> 	u8 eeprom_customer_id;
>> 	u8 res3[3];
>> 	u8 rf_antenna_option;		/* 0xc9 */
>> 	u8 res4[6];
>> 	u8 vid;				/* 0xd0 */
>> 	u8 res5[1];
>> 	u8 pid;				/* 0xd2 */
>> 	u8 res6[1];
>> 	u8 usb_optional_function;
>> 	u8 res7[2];
>> 	u8 mac_addr[ETH_ALEN];		/* 0xd7 */
>> 	u8 res8[2];
>> 	u8 vendor_name[7];
>> 	u8 res9[2];
>> 	u8 device_name[0x0b];		/* 0xe8 */
>> 	u8 res10[2];
>> 	u8 serial[0x0b];		/* 0xf5 */
>> 	u8 res11[0x30];
>> 	u8 unknown[0x0d];		/* 0x130 */
>> 	u8 res12[0xc3];
>> };
>
> The approach I took here was to add only the fields that I needed so
> far.  But you're right, in full, it should like that, apart from the
> tx_power fields.  My understanding of the vendor driver is that these
> should look like so:
>
>         /* RF path A */
> 	u8 cck_tx_power_index_A[6];
> 	u8 ht40_1s_tx_power_index_A[5];
> 	struct rtl8723au_idx ht20_ofdm_tx_power_index_diff_A;
>         struct {
>         	struct rtl8723au_idx ht40_ht20;
>                 struct rtl8723au_idx ofdm_cck;
>         } tx_power_index_diff_A[3];
>         /* RF path B */
> 	u8 cck_tx_power_index_B[6];
> 	u8 ht40_1s_tx_power_index_B[5];
> 	struct rtl8723au_idx ht20_ofdm_tx_power_index_diff_B;
>         struct {
>         	struct rtl8723au_idx ht40_ht20;
>                 struct rtl8723au_idx ofdm_cck;
>         } tx_power_index_diff_B[3];
>         /* RF path C */
>         [...]
>         /* RF path D */
>         [...]
>
> ... but RTL8188EU has only RF path A, so I stopped at that.
>
> It's not pretty how these 4-bit signed values (nibbles?) are laid out,
> so I hope that I'm just getting it wrong :-)

It's pretty gross, I agree. I prefer to try to build a complete image of
the image. Down the line we tend to need the additional fields. The
EFUSE tends to map to a given power of 2 size.

My array was not complete either, I didn't get far enough to have to
deal with the power values. If you want to complete the struct and send
me a patch, that would be cool.

Cheers,
Jes
