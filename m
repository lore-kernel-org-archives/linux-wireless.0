Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:34611 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbbJWVwY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 17:52:24 -0400
Received: by lfaz124 with SMTP id z124so97786425lfa.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2015 14:52:22 -0700 (PDT)
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com> <1445323546-12807-17-git-send-email-jsitnicki@gmail.com> <wrfjpp09ufv3.fsf@redhat.com>
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 16/16] rtl8xxxu: rtl8188eu: Implement parse_efuse()
In-reply-to: <wrfjpp09ufv3.fsf@redhat.com>
Date: Fri, 23 Oct 2015 23:52:20 +0200
Message-ID: <87lhatdzhn.fsf@frog.home> (sfid-20151023_235228_450555_33C7E00D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 21, 2015 at 04:15 AM CEST, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> Jakub Sitnicki <jsitnicki@gmail.com> writes:
>> As opposed to the vendor driver (rtl8188eu), extract from efuse only
>> these TX power values that are going to be of use later on.
>>
>> Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
>> ---
>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 35 +++++++++++++++++++++++-
>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 24 ++++++++++++++++
>>  2 files changed, 58 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> index 344161b..90da707 100644
>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> @@ -1900,7 +1900,40 @@ static int rtl8192cu_parse_efuse(struct rtl8xxxu_priv *priv)
>>  
>>  static int rtl8188eu_parse_efuse(struct rtl8xxxu_priv *priv)
>>  {
>> -	return -EOPNOTSUPP; /* Not implemented */
>> +	struct rtl8188eu_efuse *efuse = &priv->efuse_wifi.efuse8188;
>> +	struct rtl8188eu_tx_power *tx_power = &priv->tx_power.tx_power8188;
>> +
>> +	if (efuse->rtl_id != cpu_to_le16(0x8129))
>> +		return -EINVAL;
>> +
>> +	ether_addr_copy(priv->mac_addr, efuse->mac_addr);
>> +
>> +	memcpy(tx_power->cck_index_A,
>> +	       efuse->tx_power.cck_index_A,
>> +	       sizeof(tx_power->cck_index_A));
>> +
>> +	memcpy(tx_power->ht40_1s_index_A,
>> +	       efuse->tx_power.ht40_1s_index_A,
>> +	       sizeof(tx_power->ht40_1s_index_A));
>> +
>> +	memcpy(tx_power->ht20_ofdm_index_diff,
>> +	       efuse->tx_power.ht20_ofdm_index_diff,
>> +	       sizeof(tx_power->ht20_ofdm_index_diff));
>> +
>> +	dev_info(&priv->udev->dev, "Vendor: %.7s\n",
>> +		 efuse->vendor_name);
>> +	dev_info(&priv->udev->dev, "Product: %.11s\n",
>> +		 efuse->device_name);
>> +
>> +	/* XXX: Do we need to read the rf_regulatory flag? */
>> +
>> +	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_EFUSE) {
>> +		print_hex_dump_bytes("rtl8xxxu: ", DUMP_PREFIX_OFFSET,
>> +				     priv->efuse_wifi.raw,
>> +				     sizeof(priv->efuse_wifi.raw));
>> +	}
>> +
>> +	return 0;
>>  }
>>  
>>  static int
>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
>> index 79f47e3..ec49504 100644
>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
>> @@ -507,6 +507,22 @@ struct rtl8192cu_efuse {
>>  	u8 customer_id;
>>  };
>>  
>> +struct rtl8188eu_efuse {
>> +	__le16 rtl_id;
>> +	u8 res0[0x0e];
>> +	struct {						/* 0x10 */
>> +		u8 cck_index_A[6];
>> +		u8 ht40_1s_index_A[5];
>> +		struct nibble_pair ht20_ofdm_index_diff[1];
>> +	} tx_power;
>> +	u8 res1[0xbb];
>> +	u8 mac_addr[ETH_ALEN];					/* 0xd7 */
>> +	u8 res2[0x02];
>> +	u8 vendor_name[7];					/* 0xdf */
>> +	u8 res3[0x02];
>> +	u8 device_name[11];					/* 0xe8 */
>> +};
>
> This is incomplete - I think it should look more like this:
>
> struct rtl8188eu_efuse {
> 	__le16 rtl_id;
> 	u8 res0[0x0e];
> 	u8 cck_tx_power_index_A[3];	/* 0x10 */
> 	u8 cck_tx_power_index_B[3];
> 	u8 ht40_1s_tx_power_index_A[3];	/* 0x16 */
> 	u8 ht40_1s_tx_power_index_B[3];
> 	u8 res1[0x9c];
> 	u8 channel_plan;		/* 0xb8 */
> 	u8 xtal_k;
> 	u8 thermal_meter;
> 	u8 iqk_lck;
> 	u8 res2[5];
> 	u8 rf_board_option;
> 	u8 rf_feature_option;
> 	u8 rf_bt_setting;
> 	u8 eeprom_version;
> 	u8 eeprom_customer_id;
> 	u8 res3[3];
> 	u8 rf_antenna_option;		/* 0xc9 */
> 	u8 res4[6];
> 	u8 vid;				/* 0xd0 */
> 	u8 res5[1];
> 	u8 pid;				/* 0xd2 */
> 	u8 res6[1];
> 	u8 usb_optional_function;
> 	u8 res7[2];
> 	u8 mac_addr[ETH_ALEN];		/* 0xd7 */
> 	u8 res8[2];
> 	u8 vendor_name[7];
> 	u8 res9[2];
> 	u8 device_name[0x0b];		/* 0xe8 */
> 	u8 res10[2];
> 	u8 serial[0x0b];		/* 0xf5 */
> 	u8 res11[0x30];
> 	u8 unknown[0x0d];		/* 0x130 */
> 	u8 res12[0xc3];
> };

The approach I took here was to add only the fields that I needed so
far.  But you're right, in full, it should like that, apart from the
tx_power fields.  My understanding of the vendor driver is that these
should look like so:

        /* RF path A */
	u8 cck_tx_power_index_A[6];
	u8 ht40_1s_tx_power_index_A[5];
	struct rtl8723au_idx ht20_ofdm_tx_power_index_diff_A;
        struct {
        	struct rtl8723au_idx ht40_ht20;
                struct rtl8723au_idx ofdm_cck;
        } tx_power_index_diff_A[3];
        /* RF path B */
	u8 cck_tx_power_index_B[6];
	u8 ht40_1s_tx_power_index_B[5];
	struct rtl8723au_idx ht20_ofdm_tx_power_index_diff_B;
        struct {
        	struct rtl8723au_idx ht40_ht20;
                struct rtl8723au_idx ofdm_cck;
        } tx_power_index_diff_B[3];
        /* RF path C */
        [...]
        /* RF path D */
        [...]

... but RTL8188EU has only RF path A, so I stopped at that.

It's not pretty how these 4-bit signed values (nibbles?) are laid out,
so I hope that I'm just getting it wrong :-)

Cheers,
Jakub

>> +
>>  struct rtl8xxxu_reg8val {
>>  	u16 reg;
>>  	u8 val;
>> @@ -587,6 +603,12 @@ struct rtl8723au_tx_power {
>>  	struct nibble_pair ht20_max_offset[3];
>>  };
>>  
>> +struct rtl8188eu_tx_power {
>> +	u8 cck_index_A[6];
>> +	u8 ht40_1s_index_A[5];
>> +	struct nibble_pair ht20_ofdm_index_diff[1];
>> +};
>> +
>>  struct rtl8xxxu_priv {
>>  	struct ieee80211_hw *hw;
>>  	struct usb_device *udev;
>> @@ -607,6 +629,7 @@ struct rtl8xxxu_priv {
>>  	char chip_name[8];
>>  	union {
>>  		struct rtl8723au_tx_power tx_power8723;
>> +		struct rtl8188eu_tx_power tx_power8188;
>>  	} tx_power;
>>  	u32 chip_cut:4;
>>  	u32 rom_rev:4;
>> @@ -659,6 +682,7 @@ struct rtl8xxxu_priv {
>>  		u8 raw[EFUSE_MAP_LEN];
>>  		struct rtl8723au_efuse efuse8723;
>>  		struct rtl8192cu_efuse efuse8192;
>> +		struct rtl8188eu_efuse efuse8188;
>>  	} efuse_wifi;
>>  	u32 adda_backup[RTL8XXXU_ADDA_REGS];
>>  	u32 mac_backup[RTL8XXXU_MAC_REGS];
>
> There is a lot of conflict with the last couple of patches - please
> rebase them against current.
>
> Thanks,
> Jes
