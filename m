Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:34425 "EHLO
	mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbbJWVQS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 17:16:18 -0400
Received: by lfaz124 with SMTP id z124so97111347lfa.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2015 14:16:16 -0700 (PDT)
References: <1445323546-12807-1-git-send-email-jsitnicki@gmail.com> <1445323546-12807-9-git-send-email-jsitnicki@gmail.com> <wrfjbnbtvv6y.fsf@redhat.com>
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC 08/16] rtl8xxxu: Extract TX power fields from struct rtl8xxu_priv
In-reply-to: <wrfjbnbtvv6y.fsf@redhat.com>
Date: Fri, 23 Oct 2015 23:16:14 +0200
Message-ID: <87oafpe15t.fsf@frog.home> (sfid-20151023_231644_832382_1842AB8C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 21, 2015 at 03:58 AM CEST, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> Jakub Sitnicki <jsitnicki@gmail.com> writes:
>> Signed-off-by: Jakub Sitnicki <jsitnicki@gmail.com>
>> ---
>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 95 ++++++++++++------------
>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 30 ++++----
>>  2 files changed, 66 insertions(+), 59 deletions(-)
>
> I don't really see this patch adding any value - it just adds an
> additional layer of convolution. Unless there is a strong reason for
> applying it, I am going to drop this one.

The reasoning behind this change, which I should have had explained in
the commit description, is to later on have a union of two struct
*_tx_power's:

  	union {
  		struct rtl8723au_tx_power tx_power8723;
		struct rtl8188eu_tx_power tx_power8188;
  	} tx_power;

We arrive at this in the last patch from this series ("rtl8xxxu:
rtl8188eu: Implement parse_efuse()").

The existing *_tx_power_* fields in struct rtl8xxxu_priv don't fit the
rtl8188eu needs because the vendor driver divides the 2.4 GHz channels
into 6 as opposed to 3 groups (see the MAX_CHNL_GROUP_24G constant and
struct txpowerinfo24g in staging/rtl8188eu).

I agree that it does complicate the core structure (rtl8xxxu_priv) for
no reason until there is actually support for RTL8188EU.  However, I
gave the rtl8192eu driver a glance, and it looks like you might be
facing the same challenge there.

Cheers,
Jakub

>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> index e1f8c62..d67c668 100644
>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
>> @@ -1490,6 +1490,7 @@ static void rtl8723au_config_channel(struct ieee80211_hw *hw)
>>  static void
>>  rtl8723a_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
>>  {
>> +	struct rtl8723au_tx_power *tx_power = &priv->tx_power;
>>  	u8 cck[RTL8723A_MAX_RF_PATHS], ofdm[RTL8723A_MAX_RF_PATHS];
>>  	u8 ofdmbase[RTL8723A_MAX_RF_PATHS], mcsbase[RTL8723A_MAX_RF_PATHS];
>>  	u32 val32, ofdm_a, ofdm_b, mcs_a, mcs_b;
>> @@ -1498,27 +1499,27 @@ rtl8723a_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
>>  
>>  	group = rtl8723a_channel_to_group(channel);
>>  
>> -	cck[0] = priv->cck_tx_power_index_A[group];
>> -	cck[1] = priv->cck_tx_power_index_B[group];
>> +	cck[0] = tx_power->cck_tx_power_index_A[group];
>> +	cck[1] = tx_power->cck_tx_power_index_B[group];
>>  
>> -	ofdm[0] = priv->ht40_1s_tx_power_index_A[group];
>> -	ofdm[1] = priv->ht40_1s_tx_power_index_B[group];
>> +	ofdm[0] = tx_power->ht40_1s_tx_power_index_A[group];
>> +	ofdm[1] = tx_power->ht40_1s_tx_power_index_B[group];
>>  
>> -	ofdmbase[0] = ofdm[0] +	priv->ofdm_tx_power_index_diff[group].a;
>> -	ofdmbase[1] = ofdm[1] +	priv->ofdm_tx_power_index_diff[group].b;
>> +	ofdmbase[0] = ofdm[0] +	tx_power->ofdm_tx_power_index_diff[group].a;
>> +	ofdmbase[1] = ofdm[1] +	tx_power->ofdm_tx_power_index_diff[group].b;
>>  
>>  	mcsbase[0] = ofdm[0];
>>  	mcsbase[1] = ofdm[1];
>>  	if (!ht40) {
>> -		mcsbase[0] += priv->ht20_tx_power_index_diff[group].a;
>> -		mcsbase[1] += priv->ht20_tx_power_index_diff[group].b;
>> +		mcsbase[0] += tx_power->ht20_tx_power_index_diff[group].a;
>> +		mcsbase[1] += tx_power->ht20_tx_power_index_diff[group].b;
>>  	}
>>  
>>  	if (priv->tx_paths > 1) {
>> -		if (ofdm[0] > priv->ht40_2s_tx_power_index_diff[group].a)
>> -			ofdm[0] -=  priv->ht40_2s_tx_power_index_diff[group].a;
>> -		if (ofdm[1] > priv->ht40_2s_tx_power_index_diff[group].b)
>> -			ofdm[1] -=  priv->ht40_2s_tx_power_index_diff[group].b;
>> +		if (ofdm[0] > tx_power->ht40_2s_tx_power_index_diff[group].a)
>> +			ofdm[0] -= tx_power->ht40_2s_tx_power_index_diff[group].a;
>> +		if (ofdm[1] > tx_power->ht40_2s_tx_power_index_diff[group].b)
>> +			ofdm[1] -= tx_power->ht40_2s_tx_power_index_diff[group].b;
>>  	}
>>  
>>  	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_CHANNEL)
>> @@ -1780,39 +1781,40 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
>>  static int rtl8723au_parse_efuse(struct rtl8xxxu_priv *priv)
>>  {
>>  	struct rtl8723au_efuse *efuse = &priv->efuse_wifi.efuse8723;
>> +	struct rtl8723au_tx_power *tx_power = &priv->tx_power;
>>  
>>  	if (efuse->rtl_id != cpu_to_le16(0x8129))
>>  		return -EINVAL;
>>  
>>  	ether_addr_copy(priv->mac_addr, efuse->mac_addr);
>>  
>> -	memcpy(priv->cck_tx_power_index_A,
>> +	memcpy(tx_power->cck_tx_power_index_A,
>>  	       efuse->cck_tx_power_index_A,
>> -	       sizeof(priv->cck_tx_power_index_A));
>> -	memcpy(priv->cck_tx_power_index_B,
>> +	       sizeof(tx_power->cck_tx_power_index_A));
>> +	memcpy(tx_power->cck_tx_power_index_B,
>>  	       efuse->cck_tx_power_index_B,
>> -	       sizeof(priv->cck_tx_power_index_B));
>> +	       sizeof(tx_power->cck_tx_power_index_B));
>>  
>> -	memcpy(priv->ht40_1s_tx_power_index_A,
>> +	memcpy(tx_power->ht40_1s_tx_power_index_A,
>>  	       efuse->ht40_1s_tx_power_index_A,
>> -	       sizeof(priv->ht40_1s_tx_power_index_A));
>> -	memcpy(priv->ht40_1s_tx_power_index_B,
>> +	       sizeof(tx_power->ht40_1s_tx_power_index_A));
>> +	memcpy(tx_power->ht40_1s_tx_power_index_B,
>>  	       efuse->ht40_1s_tx_power_index_B,
>> -	       sizeof(priv->ht40_1s_tx_power_index_B));
>> +	       sizeof(tx_power->ht40_1s_tx_power_index_B));
>>  
>> -	memcpy(priv->ht20_tx_power_index_diff,
>> +	memcpy(tx_power->ht20_tx_power_index_diff,
>>  	       efuse->ht20_tx_power_index_diff,
>> -	       sizeof(priv->ht20_tx_power_index_diff));
>> -	memcpy(priv->ofdm_tx_power_index_diff,
>> +	       sizeof(tx_power->ht20_tx_power_index_diff));
>> +	memcpy(tx_power->ofdm_tx_power_index_diff,
>>  	       efuse->ofdm_tx_power_index_diff,
>> -	       sizeof(priv->ofdm_tx_power_index_diff));
>> +	       sizeof(tx_power->ofdm_tx_power_index_diff));
>>  
>> -	memcpy(priv->ht40_max_power_offset,
>> +	memcpy(tx_power->ht40_max_power_offset,
>>  	       efuse->ht40_max_power_offset,
>> -	       sizeof(priv->ht40_max_power_offset));
>> -	memcpy(priv->ht20_max_power_offset,
>> +	       sizeof(tx_power->ht40_max_power_offset));
>> +	memcpy(tx_power->ht20_max_power_offset,
>>  	       efuse->ht20_max_power_offset,
>> -	       sizeof(priv->ht20_max_power_offset));
>> +	       sizeof(tx_power->ht20_max_power_offset));
>>  
>>  	dev_info(&priv->udev->dev, "Vendor: %.7s\n",
>>  		 efuse->vendor_name);
>> @@ -1824,6 +1826,7 @@ static int rtl8723au_parse_efuse(struct rtl8xxxu_priv *priv)
>>  static int rtl8192cu_parse_efuse(struct rtl8xxxu_priv *priv)
>>  {
>>  	struct rtl8192cu_efuse *efuse = &priv->efuse_wifi.efuse8192;
>> +	struct rtl8723au_tx_power *tx_power = &priv->tx_power;
>>  	int i;
>>  
>>  	if (efuse->rtl_id != cpu_to_le16(0x8129))
>> @@ -1831,36 +1834,36 @@ static int rtl8192cu_parse_efuse(struct rtl8xxxu_priv *priv)
>>  
>>  	ether_addr_copy(priv->mac_addr, efuse->mac_addr);
>>  
>> -	memcpy(priv->cck_tx_power_index_A,
>> +	memcpy(tx_power->cck_tx_power_index_A,
>>  	       efuse->cck_tx_power_index_A,
>> -	       sizeof(priv->cck_tx_power_index_A));
>> -	memcpy(priv->cck_tx_power_index_B,
>> +	       sizeof(tx_power->cck_tx_power_index_A));
>> +	memcpy(tx_power->cck_tx_power_index_B,
>>  	       efuse->cck_tx_power_index_B,
>> -	       sizeof(priv->cck_tx_power_index_B));
>> +	       sizeof(tx_power->cck_tx_power_index_B));
>>  
>> -	memcpy(priv->ht40_1s_tx_power_index_A,
>> +	memcpy(tx_power->ht40_1s_tx_power_index_A,
>>  	       efuse->ht40_1s_tx_power_index_A,
>> -	       sizeof(priv->ht40_1s_tx_power_index_A));
>> -	memcpy(priv->ht40_1s_tx_power_index_B,
>> +	       sizeof(tx_power->ht40_1s_tx_power_index_A));
>> +	memcpy(tx_power->ht40_1s_tx_power_index_B,
>>  	       efuse->ht40_1s_tx_power_index_B,
>> -	       sizeof(priv->ht40_1s_tx_power_index_B));
>> -	memcpy(priv->ht40_2s_tx_power_index_diff,
>> +	       sizeof(tx_power->ht40_1s_tx_power_index_B));
>> +	memcpy(tx_power->ht40_2s_tx_power_index_diff,
>>  	       efuse->ht40_2s_tx_power_index_diff,
>> -	       sizeof(priv->ht40_2s_tx_power_index_diff));
>> +	       sizeof(tx_power->ht40_2s_tx_power_index_diff));
>>  
>> -	memcpy(priv->ht20_tx_power_index_diff,
>> +	memcpy(tx_power->ht20_tx_power_index_diff,
>>  	       efuse->ht20_tx_power_index_diff,
>> -	       sizeof(priv->ht20_tx_power_index_diff));
>> -	memcpy(priv->ofdm_tx_power_index_diff,
>> +	       sizeof(tx_power->ht20_tx_power_index_diff));
>> +	memcpy(tx_power->ofdm_tx_power_index_diff,
>>  	       efuse->ofdm_tx_power_index_diff,
>> -	       sizeof(priv->ofdm_tx_power_index_diff));
>> +	       sizeof(tx_power->ofdm_tx_power_index_diff));
>>  
>> -	memcpy(priv->ht40_max_power_offset,
>> +	memcpy(tx_power->ht40_max_power_offset,
>>  	       efuse->ht40_max_power_offset,
>> -	       sizeof(priv->ht40_max_power_offset));
>> -	memcpy(priv->ht20_max_power_offset,
>> +	       sizeof(tx_power->ht40_max_power_offset));
>> +	memcpy(tx_power->ht20_max_power_offset,
>>  	       efuse->ht20_max_power_offset,
>> -	       sizeof(priv->ht20_max_power_offset));
>> +	       sizeof(tx_power->ht20_max_power_offset));
>>  
>>  	dev_info(&priv->udev->dev, "Vendor: %.7s\n",
>>  		 efuse->vendor_name);
>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
>> index 622e6f5..1a0c88d 100644
>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
>> @@ -564,6 +564,22 @@ struct h2c_cmd {
>>  
>>  struct rtl8xxxu_fileops;
>>  
>> +struct rtl8723au_tx_power {
>> +	u8 cck_tx_power_index_A[3];	/* 0x10 */
>> +	u8 cck_tx_power_index_B[3];
>> +	u8 ht40_1s_tx_power_index_A[3];	/* 0x16 */
>> +	u8 ht40_1s_tx_power_index_B[3];
>> +	/*
>> +	 * The following entries are half-bytes split as:
>> +	 * bits 0-3: path A, bits 4-7: path B, all values 4 bits signed
>> +	 */
>> +	struct rtl8723au_idx ht40_2s_tx_power_index_diff[3];
>> +	struct rtl8723au_idx ht20_tx_power_index_diff[3];
>> +	struct rtl8723au_idx ofdm_tx_power_index_diff[3];
>> +	struct rtl8723au_idx ht40_max_power_offset[3];
>> +	struct rtl8723au_idx ht20_max_power_offset[3];
>> +};
>> +
>>  struct rtl8xxxu_priv {
>>  	struct ieee80211_hw *hw;
>>  	struct usb_device *udev;
>> @@ -582,19 +598,7 @@ struct rtl8xxxu_priv {
>>  
>>  	u8 mac_addr[ETH_ALEN];
>>  	char chip_name[8];
>> -	u8 cck_tx_power_index_A[3];	/* 0x10 */
>> -	u8 cck_tx_power_index_B[3];
>> -	u8 ht40_1s_tx_power_index_A[3];	/* 0x16 */
>> -	u8 ht40_1s_tx_power_index_B[3];
>> -	/*
>> -	 * The following entries are half-bytes split as:
>> -	 * bits 0-3: path A, bits 4-7: path B, all values 4 bits signed
>> -	 */
>> -	struct rtl8723au_idx ht40_2s_tx_power_index_diff[3];
>> -	struct rtl8723au_idx ht20_tx_power_index_diff[3];
>> -	struct rtl8723au_idx ofdm_tx_power_index_diff[3];
>> -	struct rtl8723au_idx ht40_max_power_offset[3];
>> -	struct rtl8723au_idx ht20_max_power_offset[3];
>> +	struct rtl8723au_tx_power tx_power;
>>  	u32 chip_cut:4;
>>  	u32 rom_rev:4;
>>  	u32 is_multi_func:1;
