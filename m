Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E6E513554
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 11:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790681336; cv=none; b=kTingm/MGFGgYlXX+nuLjXdToIuuyYU9GzLw2EZy4cYL+neOm2BqtPeozyq2EMO8AvjTUI0KpnQXxl6wDUNzDqGN1kZQcNVM0Bk8kRuhyIiylrzaFkx84vLmA+2TPtvcTB+3TREcJdHXge63KCh4JN158PSHg0DFBC5gE8DKAg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790681336; c=relaxed/simple;
	bh=3rECaaDdvw9zHdYh7ey/aO7GO4AYepJPYKFKK3tSYbw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DYFOkMAcM2XYoi9jkHl50c4YyVjm53wZraaez3LDJQyphsJsI+wRXpnntVXCHZxt9wYQ7fgdKZSdV0MtNAEfjfSmN4QWlndPxJjy0Yuo0yy3TclRbt//2SvRYj7OeWYs2lUKTsaJeAQWZ9ybawuSpMHpJ3qThFqX4uWTK/rPxMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SryipYNi; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SryipYNi"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d391aso30573315e9.2
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 04:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790681333; x=1791286133; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jh3L4jOl68rMmEvxUQPodbuSF+NO7zAX0NywwnnROiQ=;
        b=SryipYNiaj9w1oly1YZ7hAT3/hiUxSa7KXDzGoi3HuKAehF0b13csuvvUEmFoSTXiw
         Vg3VDNA3DmVjp+fe65v1E01ui5J8Vh+aFfRVPtq/iKFq0WGf0e5GBpCmq/movBVY3vK9
         lST1iPgiYrKnDrqH2EB89peFrTJ2zwMd+Bh5AQ8jvDVB15etKy+qMIPMKeuHE2JBTc69
         W5koNcSCQ0yxGN30DNaZ4LosyOFDTJPqYjYarZrce7vCy58h8gFOYLC8Jqc2t//OBp06
         r6XmuW2gwJJitWAMiodhs5bEG9K/uocgQMcCN//hzlAm8PvpLxzKWCgrgA0U0M0WlpFg
         tm4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790681333; x=1791286133;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jh3L4jOl68rMmEvxUQPodbuSF+NO7zAX0NywwnnROiQ=;
        b=O651v95Jf++HUmvuBIvsScurb8XMoOss6Aljhg8t7p62hiwxxuhyTVRub7ZKibuLyd
         nlAQyqzFOiwqCYS5MW9J0BHTTQ482sMQrKp2AxQSPwn46z9sSmcjCPxUW6kd13pCfew6
         w5LM35qxdrZh7QcafUhW/QdrpSM76OGkQcBhCAHXLrXSKx8L9T+T7SUN8CbX4LZcoX3I
         Nqm5+AbNBCyiWQon5DGW2WIOiOgsO1duu6GD0wHLBVouB+7LvonPKnf5bXMo3p+SPCRE
         JhxRt4bO1qfm2QYzfjk6RNz3Ht2xWIEVcxwa53Xolx69fHDsT9l7W6VcPPEtm4KGTNan
         82Hw==
X-Gm-Message-State: AFuF++lRHL0Ph+b33ek4hgaT+L3Kw3mIxF1GgcAkxefglkgieDLqDRZG
	fTc13S7DMFYDMDog2eXSJAGwETyd9Ymg889B1GWgyl3RIdvUMD+i1ih9
X-Gm-Gg: AYBFou354YSwTBEVoSZe235ncY+yEmKHM08XOh4+P8DR/YYetzkzrs/wNuGeADXsEuG
	ml2kamuFD38lSRSlOSOmEVOBymEPHpce79f2fhK5mEhzhCcxY0k1mJbbFL7rXm1+eEGdlsIyBFj
	jdOshFXka3nqwZ7b5dt2jdaBSNWC8gSEAVBpCJBJgzJWdobUh609TZWgPBlpdf9O8Ld/a/O65pg
	HLfVlYF1b+gsCwW1rjyl5WS2wPabiMhzJrBbY6nNuwMxmNBbHSAtWTIBOXkNpFmREmWj2UKfkz5
	ncYkcVSQhCgfBYUmz4zKLBDYj7RItM4tQNreNwck+QlUDh1OtkUFNocrc+de2nvWhqFaTozxH7F
	8fWuva0Qcm+NuhxayilIBz5WTBukZ1H/CrMJ1vzHSP69D/UDcsjkJlWiyt5WSkfvpdGrKADbkUH
	7Z8ERj7IR6uUkAyLvhfDSr8C0s2TjI8vWStsuqw/Q+n0Gmhjb+XkUbmQUAYoaqUwUP+8cjefbUU
	cXp1w==
X-Received: by 2002:a05:600c:1c25:b0:4a0:561:d0fa with SMTP id 5b1f17b1804b1-4a00561d337mr96977135e9.18.1790681332360;
        Tue, 29 Sep 2026 04:28:52 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48af507611csm3153555f8f.22.2026.09.29.04.28.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 04:28:51 -0700 (PDT)
Message-ID: <a1ef423d-519d-47bb-be6c-d413a8421943@gmail.com>
Date: Tue, 29 Sep 2026 14:28:50 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/6] wifi: rtw88: 8723b: add the RTL8723B chip driver
To: Luka Gejak <luka.gejak@linux.dev>, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>
References: <20260923213557.186205-1-luka.gejak@linux.dev>
 <20260923213557.186205-4-luka.gejak@linux.dev>
 <6ad11268-9f09-4618-8b44-ab0744cf0a52@gmail.com>
 <845297728a153af0edb5404d88e59cc4ebe4d4cf@linux.dev>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <845297728a153af0edb5404d88e59cc4ebe4d4cf@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 29/09/2026 13:10, Luka Gejak wrote:
> September 27, 2026 at 17:21, "Bitterblue Smith" <rtl8821cerfe2@gmail.com mailto:rtl8821cerfe2@gmail.com?to=%22Bitterblue%20Smith%22%20%3Crtl8821cerfe2%40gmail.com%3E > wrote:
> 
>>
>>
>> On 24/09/2026 00:35, Luka Gejak wrote:
> 
>>> +static u8 rtw8723b_default_ofdm_index(struct rtw_dev *rtwdev)
>>> +{
>>> +	u32 val32;
>>> +	u32 swing;
>>> +	u8 i;
>>> +
>>> +	swing = rtw_read32_mask(rtwdev, REG_OFDM_0_XA_TX_IQ_IMBALANCE,
>>> +				OFDM_SWING_MASK);
>>> +
>>> +	for (i = 0; i < RTW_OFDM_SWING_TABLE_SIZE; i++) {
>>> +		val32 = rtw8723b_ofdm_swing_table[i];
>>> +
>>> +		if (val32 >= 0x100000)
>>> +			val32 >>= __ffs(OFDM_SWING_MASK);
> 
>> Isn't this the same as u32_get_bits(val32, OFDM_SWING_MASK) ?
> 
> Yes. It is u32_get_bits() now, and the if goes away with it.
> 
>>> +		if (val32 >= 0x100000)
>>> +			val32 >>= __ffs(OFDM_SWING_MASK);
> 
>> Also, every value in the table is bigger than 0x100000, so no need for if.
> 
> There is no val32 left to test.
> 
>>> +static void rtw8723b_post_enable_flow(struct rtw_dev *rtwdev)
>>> +{
>>> +	/*
>>> +	 * Enable falling edge triggered interrupts and GPIO9 interrupt mode.
>>> +	 * The power-on sequence sets both, but it runs before the firmware is
>>> +	 * downloaded, so reassert them here as the vendor driver does.
>>> +	 */
>>> +	rtw_write8_set(rtwdev, 0x0049, BIT(1));
>>> +	rtw_write8_set(rtwdev, 0x0063, BIT(1));
> 
>> This seems like bit 25 of REG_GPIO_PIN_CTRL_2.
> 
> It is. That write is rtw_write32_set(REG_GPIO_PIN_CTRL_2, BIT(25)) now.
> The write above it is bit 9 of REG_GPIO_INTM.
> 
>>> +static void rtw8723b_phy_lck(struct rtw_dev *rtwdev)
>>> +{
>>> +	rtw_write_rf(rtwdev, RF_PATH_A, 0xb0, RFREG_MASK, 0xdfbe0);
> 
>> We have a name for 0xb0: RF_SYN_PFD. Not sure if it's the right name here.
> 
> I have decided to use it.
> 
>>> +static void rtw8723b_init_tx_buffer_boundary(struct rtw_dev *rtwdev)
>>> +{
>>> +	u8 val8 = TX_TOTAL_PAGE_NUMBER_8723B + 1;
>>> +
>>> +	rtw_write8(rtwdev, REG_BCNQ_BDNY, val8);
>>> +	rtw_write8(rtwdev, REG_MGQ_BDNY, val8);
>>> +	rtw_write8(rtwdev, REG_WMAC_LBK_BF_HD, val8);
>>> +	rtw_write8(rtwdev, REG_TRXFF_BNDY, val8);
>>> +	rtw_write8(rtwdev, REG_DWBCN0_CTRL + 1, val8);
> 
>> __priority_queue_cfg_legacy() already takes care of these. Is it
>> necessary to set them again here?
> 
> No. init_tx_buffer_boundary() and init_page_boundary() are both gone.
> 
>>> +static void rtw8723b_init_transfer_page_size(struct rtw_dev *rtwdev)
>>> +{
>>> +	rtw_write8(rtwdev, REG_PBP, 0x11);
> 
>> We have some macros for this in reg.h right under REG_PBP. You can use
>> them with u8_encode_bits().
> 
> Done, u8_encode_bits(PBP_128, PBP_RX_MASK) and the same for TX.
> 
>>> +static void rtw8723b_init_driver_info_size(struct rtw_dev *rtwdev)
>>> +{
>>> +	/* NOTE: also is done in rtw_drv_info_cfg */
> 
>> If it's done there do you have to do it again here?
> 
> No. init_driver_info_size() is gone.
> 
>>> +static void rtw8723b_init_wmac_setting(struct rtw_dev *rtwdev)
>>> +{
>>> +	/*
>>> +	 * The vendor's 8723x filter value plus BIT_APP_FCS, which rtw88
>>> +	 * needs because it advertises RX_INCLUDES_FCS. It is assigned to
>>> +	 * hal.rcr and not merely written because rtw_core_start()
>>> +	 * rewrites REG_RCR from hal.rcr after power_on, which would undo
>>> +	 * a register-only write; fw.c toggles BIT_CBSSID_BCN in it.
>>> +	 */
>>> +	rtwdev->hal.rcr = WLAN_RCR_CFG;
> 
>> Is it necessary to change the default value assigned in rtw_core_init()?
> 
> No, that is where it belngs. hal.rcr is assigned in rtw_core_init() per
> chip now. It is a patch of its own at the beggining of the series.
> 
>>> +	rtw_write32(rtwdev, REG_RCR, rtwdev->hal.rcr);
>>> +
>>> +	rtw_write32(rtwdev, REG_MAR, 0xffffffff);
>>> +	rtw_write32(rtwdev, REG_MAR + 4, 0xffffffff);
>>> +
>>> +	rtw_write16(rtwdev, REG_RXFLTMAP2, WLAN_RX_FILTER2);
>>> +	rtw_write16(rtwdev, REG_RXFLTMAP1, WLAN_RX_FILTER1);
> 
>> Please also update rtwdev->hal.rxfltmap1 when you change REG_RXFLTMAP1:
>> https://lore.kernel.org/linux-wireless/2a52d718-9e46-47f2-84a1-d8e7b1ed89a8@gmail.com/
> 
> You are right, and the reuse turns out to be the fix. The chip uses
> rtw8723x_mac_init() now, which writes REG_RXFLTMAP0/1/2 and sets
> hal.rxfltmap1. rtw8723b_mac_init() and rtw8723b_init_wmac_setting() are
> both gone.
> 
>>> +static void rtw8723b_init_operation_mode(struct rtw_dev *rtwdev)
>>> +{
>>> +	rtw_write8(rtwdev, REG_BWOPMODE, BIT_BWOPMODE_20MHZ);
> 
>> I don't see this in the vendor driver v5.2.17.1.
> 
> After rechecking it myself, me neither. init_operation_mode() and the
> REG_BWOPMODE defines are gone.
> 
>>> +static void rtw8723b_init_antenna_selection(struct rtw_dev *rtwdev)
>>> +{
>>> +	rtw_write8(rtwdev, REG_LEDCFG2, WLAN_ANT_SEL);
>>> +}
>>> +
>>> +#define RF_AC	0x00
> 
>> You can use the existing RF_MODE name for this.
> 
> Done, the local RF_AC is gone.
> 
>>> +static void rtw8723b_lck(struct rtw_dev *rtwdev)
>>> +{
>>> +	u32 rf_mode = 0, lc_cal;
>>> +	int ret;
>>> +	u8 val_ctx;
>>> +	u8 rf_val;
>>> +
>>> +	val_ctx = rtw_read8(rtwdev, REG_CTX);
>>> +
>>> +	if ((val_ctx & BIT_MASK_CTX_TYPE) != 0)
> 
>> No need to compare.
> 
> Dropped.
> 
>>> +	/* 3. Read RF reg18 */
>>> +	lc_cal = rtw_read_rf(rtwdev, RF_PATH_A, RF_CFGCH, MASK12BITS);
>>> +
>>> +	/* 4. Set LC calibration begin	bit15 */
>>> +	rtw_write_rf(rtwdev, RF_PATH_A, 0xb0, RFREG_MASK, 0xdfbe0);
>>> +	rtw_write_rf(rtwdev, RF_PATH_A, RF_CFGCH, MASK12BITS, lc_cal | BIT_LCK);
>>> +
>>> +	ret = read_poll_timeout(rtw_read_rf, rf_val, rf_val != 0x1,
>>> +				10000, 1000000, false,
>>> +			 rtwdev, RF_PATH_A, RF_CFGCH, BIT_LCK);
> 
>> checkpatch should catch alignment issues like this. Please always run it.
> 
> Fixed, and I am running it. checkpatch --strict is clean except the
> MAINTAINERS reminder on the patches that add files and the comllex-macro
> report on TRANS_SEQ_END, which rtw8703b.c already has.
> 
>>> +	if (ret)
>>> +		rtw_warn(rtwdev, "failed to poll LCK status bit\n");
>>> +
>>> +	rtw_write_rf(rtwdev, RF_PATH_A, 0xb0, RFREG_MASK, 0xdffe0);
>>> +
>>> +	/* Restore original situation */
>>> +	if ((val_ctx & BIT_MASK_CTX_TYPE) != 0) {
>>> +		rtw_write8(rtwdev, REG_CTX, val_ctx);
>>> +
>>> +		rtw_write_rf(rtwdev, RF_PATH_A, RF_AC, MASK12BITS, rf_mode);
>>> +	} else {
>>> +		rtw_write8(rtwdev, REG_TXPAUSE, 0x00);
>>> +	}
> 
>> I think the vendor driver is using MASK12BITS (0xfff) by mistake in
>> this function. It doesn't make any sense, it should be RFREG_MASK
>> (0xfffff) instead.
> 
> Agreed, and that function is gone. The chip had its own lck carrying the
> shared one plus the RF_MODE standby read and write and the two RF_SYN_PFD
> writes. The RF_MODE pair only runs in the continuous TX branch, which
> this driver never enters, and rtw8723b_phy_lck() already does the
> RF_SYN_PFD pair at RF configuration. So rtw8723b calls rtw8723x_lck()
> now, the way 8703b and 8723d do, and that one reads RF_CHNLBW with
> RFREG_MASK. Test results are the same with it dropped.

Why drop this function? You don't know what RF_SYN_PFD is for.
Maybe it's required every time it does LC calibration?

> 
>>> +static u32 rtw8723b_iqk_ant_switch_path(struct rtw_dev *rtwdev)
>>> +{
>>> +	if (rtw_hci_type(rtwdev) != RTW_HCI_TYPE_SDIO)
>>> +		return rtw_hci_type(rtwdev) == RTW_HCI_TYPE_USB ? 0x280 : 0x0;
>>> +
>>> +	/* Scan and connect use the PTA mux, so calibrate the path they use. */
>>> +	return (rtwdev->efuse.bt_setting & BIT(6)) ? 0x80 : 0x200;
> 
>> This function would be clearer if you don't use the ternary
>> operator at all.
> 
> Rewritten without it.
> 
>> Not sure this logic is correct. The check in the vendor driver is
>> like this:
>>
>> bool shared_ant = bt_setting & BIT(0);
>> if (USB) {
>> 	if (shared_ant)
>> 		ant_path = RF_PATH_B;
>> 	else
>> 		ant_path = RF_PATH_A;
>> } else {
>> 	if (bt_setting & BIT(6))
>> 		ant_path = RF_PATH_B;
>> 	else
>> 		ant_path = RF_PATH_A;
>> }
>> if (!shared_ant || ant_path == RF_PATH_A)
>> 	return 0;
>> else
>> 	return 0x280;
>>
>> I didn't see 0x80 and 0x200 in the IQK code.
> 
> It follows the vendor now, shared_ant from bit 0 and ant_path from bit 6,
> returning 0 or 0x280. The 0x80 and 0x200 are gone.
> 
>>> +static void rtw8723b_set_channel_rf(struct rtw_dev *rtwdev, u8 channel, u8 bw)
>>> +{
>>> +	u32 rf_cfgch;
>>> +
>>> +	rf_cfgch = rtw_read_rf(rtwdev, RF_PATH_A, RF_CFGCH, RFREG_MASK);
>>> +
>>> +	rf_cfgch &= ~RFCFGCH_CHANNEL_MASK;
>>> +	rf_cfgch |= channel & RFCFGCH_CHANNEL_MASK;
> 
>> This is what u32(p)_replace_bits is for.
> 
> Done, now using u32p_replace_bits().
> 
>>> +
>>> +	rf_cfgch &= ~RFCFGCH_BW_MASK;
>>> +	switch (bw) {
>>> +	case RTW_CHANNEL_WIDTH_20:
>>> +		rf_cfgch |= RFCFGCH_BW_20M;
>>> +		break;
>>> +	case RTW_CHANNEL_WIDTH_40:
>>> +		rf_cfgch |= RFCFGCH_BW_40M;
>>> +		break;
>>> +	default:
>>> +		break;
>>> +	}
> 
>> bw is only going to be 20 or 40, so a simple if would be shorter.
> 
> This is the one I left alone, the bandwidth assignment is still a single
> ternary.
> 
>>> +static void rtw8723b_set_channel(struct rtw_dev *rtwdev, u8 channel,
>>> +				 u8 bw, u8 primary_chan_idx)
>>> +{
>>> +	rtw8723b_set_channel_rf(rtwdev, channel, bw);
>>> +	rtw_set_channel_mac(rtwdev, channel, bw, primary_chan_idx);
>>> +	rtw8723b_set_channel_bb(rtwdev, bw, primary_chan_idx);
> 
>> I don't think the vendor driver v5.2.17.1 does the stuff below:
> 
>>> +	rtw8723b_reassert_rx_path(rtwdev);
>>> +
>>> +	if (rtw_is_8723bs(rtwdev)) {
>>> +		bool keep_pta_owner;
>>> +
>>> +		keep_pta_owner = test_bit(RTW_FLAG_SCANNING, rtwdev->flags) ||
>>> +				 (rtw_read32(rtwdev, REG_PAD_CTRL1) &
>>> +				  BIT_PAPE_WLBT_SEL);
>>> +		rtw8723b_sdio_restore_pad_ctrl(rtwdev, keep_pta_owner);
>>> +
>>> +		rtw_write8(rtwdev, REG_RF_CTRL, WLAN_RF_CTRL_ENABLE);
>>> +		fsleep(1000);
>>> +
>>> +		/*
>>> +		 * RF_WLINT bits 0-1 gate the data path into the BB and a prior
>>> +		 * IQK or coex run can leave them blocking TX, so re-arm them.
>>> +		 */
>>> +		rtw_write_rf(rtwdev, RF_PATH_A, RF_WLINT, RFREG_MASK,
>>> +			     0x0780);
>>> +	}
> 
>> If this driver doesn't work without it, you probably have a bug
>> somewhere.
> 
> The block is still there. I did not find a bug, and I have not found a
> reason to delete it either. rtw8723b_reassert_rx_path() has a comment
> saying what it puts back, and where the PAD bits come from is in my reply
> to your other mail.

So the driver doesn't work if you delete this part?

> 
>>> +	/* enable path A PA in TX IQK mode */
>>> +	rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWE, 0x80000, 0x1);
>>> +	rtw_write_rf(rtwdev, RF_PATH_A, RF_MODE_TABLE_ADDR, RFREG_MASK,
>>> +		     sdio_iqk ? 0x18000 : 0x20000);
> 
>> Where does 0x18000 come from? The vendor driver v5.2.17.1 uses 0x20000 here.
> 
> That value was mine and it is wrong. The vendor's value is used now.
> 
>>> +	rtw_write32(rtwdev, REG_TXIQK_PI_A_11N,
>>> +		    sdio_iqk ? 0x821303ea : 0x821403ea);
> 
>> Here, too, it uses the second value.
> 
> Same, the vendor's value.
> 
>>> +	rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWE, 0x80000, 0x1);
>>> +	rtw_write_rf(rtwdev, RF_PATH_A, RF_MODE_TABLE_ADDR, RFREG_MASK,
>>> +		     sdio_iqk ? 0x18000 : 0x30000);
> 
>> Vendor driver uses the second value.
> 
> 0x30000 now.
> 
>>> +	/* IQK setting */
>>> +	rtw_write32(rtwdev, REG_TXIQK_11N, 0x01007c00);
>>> +	rtw_write32(rtwdev, REG_RXIQK_11N, 0x01004800);
>>> +
>>> +	/* path-A IQK setting */
>>> +	rtw_write32(rtwdev, REG_TXIQK_TONE_A_11N, 0x18008c1c);
>>> +	rtw_write32(rtwdev, REG_RXIQK_TONE_A_11N, 0x38008c1c);
>>> +	rtw_write32(rtwdev, REG_TX_IQK_TONE_B, 0x38008c1c);
>>> +	rtw_write32(rtwdev, REG_RX_IQK_TONE_B, 0x38008c1c);
>>> +
>>> +	rtw_write32(rtwdev, REG_TXIQK_PI_A_11N,
>>> +		    sdio_iqk ? 0x82130ff0 : 0x82160ff0);
> 
>> Here as well.
> 
> Also the vendor's value, in the RX path RF_MODE_TABLE_ADDR write.
> 
>>> +	rtw_dbg(rtwdev, RTW_DBG_RFK, "[IQK] path A RX IQK step2!\n");
>>> +
>>> +	/* modify RX IQK mode */
>>> +	rtw_write32_mask(rtwdev, REG_FPGA0_IQK_11N, MASKH3BYTES, 0x000000);
>>> +	rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWE, 0x80000, 0x1);
>>> +	rtw_write_rf(rtwdev, RF_PATH_A, RF_MODE_TABLE_ADDR, RFREG_MASK,
>>> +		     sdio_iqk ? 0x18000 : 0x30000);
> 
>> Here as well.
> 
> And in the REG_RXIQK_PI_A_11N write.
> 
>>> +	/* leave IQK mode */
>>> +	rtw_write32_mask(rtwdev, REG_FPGA0_IQK_11N, MASKH3BYTES, 0x000000);
>>> +
>>> +	/* Check failed */
> 
>> No need for a comment that just repeats what the name of the function
>> already says.
> 
>>> +	/* path-A IQK setting */
>>> +	rtw_write32(rtwdev, REG_TXIQK_TONE_A_11N, 0x38008c1c);
>>> +	rtw_write32(rtwdev, REG_RXIQK_TONE_A_11N, 0x18008c1c);
>>> +	rtw_write32(rtwdev, REG_TX_IQK_TONE_B, 0x38008c1c);
>>> +	rtw_write32(rtwdev, REG_RX_IQK_TONE_B, 0x38008c1c);
>>> +
>>> +	rtw_write32(rtwdev, REG_TXIQK_PI_A_11N, 0x82110000);
>>> +	rtw_write32(rtwdev, REG_RXIQK_PI_A_11N,
>>> +		    sdio_iqk ? 0x2813001f : 0x2816001f);
> 
>> Here as well.
> 
> All three are gone.
> 
>>> +	rtw_write32_mask(rtwdev, REG_FPGA0_IQK_11N, MASKH3BYTES, 0x000000);
>>> +	rtw_write_rf(rtwdev, RF_PATH_A, RF_LUTWE, 0x80000, 0x1);
>>> +	rtw_write_rf(rtwdev, RF_PATH_A, RF_MODE_TABLE_ADDR, RFREG_MASK, 0x30000);
>>> +	rtw_write_rf(rtwdev, RF_PATH_A, RF_MODE_TABLE_DATA0, RFREG_MASK, 0x0001f);
>>> +	rtw_write_rf(rtwdev, RF_PATH_A, RF_MODE_TABLE_DATA1, RFREG_MASK, 0xf7fb7);
>>> +	rtw_write_rf(rtwdev, RF_PATH_A, 0xed, 0x20, 0x1);
>>> +	rtw_write_rf(rtwdev, RF_PATH_A, 0x43, RFREG_MASK, 0x60fbd);
>>> +
>>> +	for (i = 0; i < PATH_IQK_RETRY; i++) {
>>> +		a_ok = rtw8723b_iqk_tx_path_a(rtwdev);
>>> +		if (a_ok == IQK_TX_OK) {
> 
>> If you invert the condition, this block with long lines can be
>> indented less.
> 
> Inverted.
> 
>>> +
>>> +	if (a_ok == 0x0)
>>> +		rtw_dbg(rtwdev, RTW_DBG_RFK, "[IQK] path A IQK fail!\n");
>>> +
>>> +	/* rtl8723b is 1T1R, so path B is not calibrated. */
> 
>> It looks like the vendor driver is calibrating path B as well
>> (phy_path_b_iqk_8723b() and phy_path_b_rx_iqk_8723b()) when the device
>> has two antennas, and only path A when the device has one antenna.
> 
> Path B is still not calibrated, so path A only. The comment now says what
> you said, that the vendor calibrates it when the board is not 1-antenna
> and that this driver does not support that case. I would rather not add
> IQK code I cannot test on a 1x1 card.
> 
>>> +	memset(result, 0, sizeof(result));
>>> +
>>> +	rtw8723b_lck(rtwdev);
>>> +	rtw8723b_inform_rfk_status(rtwdev, true);
>>> +
>>> +	/* The LTE path GNT backup that 8723d does is not needed on SDIO. */
>>> +	rtw8723x_iqk_backup_path_ctrl(rtwdev, &backup);
>>> +	rtw8723x_iqk_backup_regs(rtwdev, &backup);
>>> +
>>> +	/* save default GNT_BT */
>>> +	bt_control = rtw_read32(rtwdev, REG_BT_CONTROL_8723B);
>>> +
>>> +	for (i = IQK_ROUND_0; i <= IQK_ROUND_2; i++) {
>>> +		if (!rtw_is_8723bs(rtwdev))
>>> +			rtw8723x_iqk_config_path_ctrl(rtwdev);
> 
>> I didn't see this in the RTL8723BE or RTL8723BU drivers. I guess it was
>> copied from another chip?
> 
> It was. The iqk_config_path_ctrl() and restore calls are gone.
> 
>>> +	rtw_dbg(rtwdev, RTW_DBG_RFK, "[IQK] final_candidate is %x\n",
>>> +		final_candidate);
>>> +
>>> +	for (i = IQK_ROUND_0; i < IQK_ROUND_SIZE; i++)
>>> +		rtw_dbg(rtwdev, RTW_DBG_RFK,
>>> +			"[IQK] Result %u: rege94_s1=%x rege9c_s1=%x regea4_s1=%x regeac_s1=%x rege94_s0=%x rege9c_s0=%x regea4_s0=%x regeac_s0=%x %s\n",
>>> +			i,
>>> +			result[i][0], result[i][1], result[i][2], result[i][3],
>>> +			result[i][4], result[i][5], result[i][6], result[i][7],
>>> +			final_candidate == i ? "(final candidate)" : "");
> 
>> You can make this two calls to rtw_dbg to avoid such a long line.
> 
> Two calls now.
> 
>>> +static void rtw8723b_pwrtrack_set_cck_pwr(struct rtw_dev *rtwdev, s8 swing_idx,
>>> +					  s8 txagc_idx)
>>> +{
>>> +	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
>>> +
>>> +	dm_info->txagc_remnant_cck = txagc_idx;
>>> +
>>> +	swing_idx = clamp_t(s8, swing_idx, 0, RTW_CCK_SWING_TABLE_SIZE - 1);
>>> +
>>> +	BUILD_BUG_ON(ARRAY_SIZE(rtw8723b_cck_pwr_regs) !=
>>> +		     ARRAY_SIZE(rtw8723b_cck_swing_table_ch1_ch13[0]));
>>> +
>>> +	/* Only ch1-13 is wired up; channel 14 is Japan-only and unreachable. */
> 
>> If I change my country code to JP and trigger a scan, rtw88 visits
>> channel 14.
> 
> Right. Channel 14 selects rtw8723b_cck_swing_table_ch14 now.
> 
>>> +	for (int i = 0; i < ARRAY_SIZE(rtw8723b_cck_pwr_regs); i++)
>>> +		rtw_write8(rtwdev, rtw8723b_cck_pwr_regs[i],
> 
>> These register addresses are consecutive values, there is no need
>> to put them in an array.
> 
> The array is gone, it loops over the eight consecutive registers from
> 0x0a22.
> 
>>> +	delta = rtw_phy_pwrtrack_get_delta(rtwdev, RF_PATH_A);
>>> +
>>> +	/* NOTE: also done in rtw_phy_pwrtrack_get_delta */
> 
>> Is it necessary to do it again?
> 
> No. The clamp is only in rtw_phy_pwrtrack_get_delta() now.
> 
>>> +iqk:
>>> +	if (do_iqk)
>>> +		rtw8723b_phy_calibration(rtwdev);
> 
>> The vendor driver doesn't redo IQK here.
> 
> 8723d and 8703b in rtw88 both call phy_calibration() from phy_pwrtrack()
> when rtw_phy_pwrtrack_need_iqk() returns true, so I kept it and match the
> other chips.

Different chips can have different needs...

> 
>>> +static void rtw8723b_pwr_track(struct rtw_dev *rtwdev)
>>> +{
>>> +	struct rtw_efuse *efuse = &rtwdev->efuse;
>>> +	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
>>> +
>>> +	if (efuse->power_track_type != 0) {
>>> +		rtw_warn(rtwdev, "unsupported power track type\n");
> 
>> This function runs every two seconds, forever. Please put this
>> warning elsewhere, like rtw8723b_read_efuse(), to avoid filling
>> the kernel log. (Or create rtw_warn_once()).
> 
> Moved to rtw8723b_read_efuse().
> 
>>> +static void rtw8723b_coex_cfg_ant_buffer(struct rtw_dev *rtwdev)
>>> +{
>>> +	u8 sys_func_before;
>>> +
>>> +	sys_func_before = rtw_read8(rtwdev, REG_SYS_FUNC_EN);
>>> +	if ((sys_func_before & WLAN_SYS_FUNC_BB_ENABLE) !=
>>> +	    WLAN_SYS_FUNC_BB_ENABLE) {
>>> +		rtw_write8_set(rtwdev, REG_SYS_FUNC_EN,
>>> +			       WLAN_SYS_FUNC_BB_ENABLE);
>>> +		usleep_range(10, 11);
>>> +	}
> 
>> Not sure why you need to touch REG_SYS_FUNC_EN here. The vendor
>> driver doesn't do it.
> 
> That is gone from rtw8723b_coex_cfg_ant_buffer().
> 
>>> +	rtw_write8_set(rtwdev, REG_PWR_DATA + 1,
>>> +		       BIT_EEPRPAD_RFE_CTRL_EN >> 8);
>>> +	rtw8723b_coex_write8_verify(rtwdev, REG_RFE_CTRL_E, 0xff);
> 
>> The vendor driver uses a normal rtw_write8() here.
> 
> coex_write8_verify() is gone and the call is a plain rtw_write8() now.
> 
>>> +		rtw_write8_set(rtwdev, REG_SYS_FUNC_EN,
>>> +			       WLAN_SYS_FUNC_BB_ENABLE);
>>> +		usleep_range(10, 11);
>>> +	}
>>> +
>>> +	rtw_write32(rtwdev, REG_BB_SEL_BTG, value);
>>> +	readback = rtw_read32(rtwdev, REG_BB_SEL_BTG);
>>> +	if (readback == value)
>>> +		return readback;
>>> +
>>> +	rtw_write8_set(rtwdev, REG_SYS_FUNC_EN, WLAN_SYS_FUNC_BB_ENABLE);
>>> +	usleep_range(10, 11);
>>> +	rtw_write32(rtwdev, REG_BB_SEL_BTG, value);
>>> +
>>> +	return rtw_read32(rtwdev, REG_BB_SEL_BTG);
> 
>> All this looks strange too. What happens if you eliminate this function
>> and write REG_BB_SEL_BTG with a simple rtw_write32()?
> 
> Nothing, it works. The function is gone and every call site does a plain
> rtw_write32() now.
> 
>>> +	.query_phy_status	= rtw8723b_query_phy_status,
>>> +	.read_rf		= rtw_phy_read_rf_sipi,
>>> +	.write_rf		= rtw_phy_write_rf_reg_sipi,
>>> +	.set_tx_power_index	= rtw8723x_set_tx_power_index,
>>> +	.rsvd_page_dump		= NULL,
>>> +	.set_antenna		= NULL,
>>> +	.cfg_ldo25		= rtw8723b_cfg_ldo25,
>>> +	.efuse_grant		= rtw8723b_efuse_grant,
>>> +	.set_ampdu_factor	= NULL,
>>> +	.false_alarm_statistics	= rtw8723x_false_alarm_statistics,
>>> +	.phy_calibration	= rtw8723b_phy_calibration,
>>> +	.dpk_track		= NULL,
>>> +	/* REG_CSRATIO does not exist on this chip generation. */
>>> +	.cck_pd_set		= NULL,
> 
>> You can use rtw88xxa_phy_cck_pd_set() from rtw88xxa.c for this
>> chip too.
> 
> Done, and it has a consequence you should know about. The chip driver
> calls into rtw88xxa.c now, so RTW88_8723B selects RTW88_88XXA, which makes
> rtw88_8723b.ko depend on rtw88_88xxa.ko and pulls that PCI chip module
> into an SDIO only build. 8821A and 8812A select it the same way, it
> builds and loads clean, and it was on the card for a suite and a soak.
> Say so if you would rather not have the dependency and I will put the
> function in the chip driver instead. The same file carries the adaptive
> control and EDCA init now as well, because the chip was writing the same
> values, so the dependency does more than that one call.
> 

A better idea: move rtw88xxa_phy_cck_pd_set() to phy.c and don't depend
on rtw88_88xxa. That can be a separate patch, of course.

>>> +	.txgi_factor = 1,
>>> +	.is_pwr_by_rate_dec = true,
>>> +	.max_power_index = 0x3f,
>>> +	.csi_buf_pg_num = 0,
>>> +	.band = RTW_BAND_2G,
>>> +	.page_size = TX_PAGE_SIZE,
>>> +	.dig_min = 0x20,
>>> +	.usb_tx_agg_desc_num = 1,
> 
>> The RTL8723BU vendor driver v5.2.17 sets this to 6.
> 
> usb_tx_agg_desc_num is 6 now.
> 
>>> +	/* same shared table as the sibling rtw8703b and rtw8723d */
>>> +	.prioq_addrs = &rtw8723x_common.prioq_addrs,
>>> +	/* used only in pci.c, not needed for SDIO devices */
>>> +	.intf_table = NULL,
>>> +	.dig = rtw8723x_common.dig,
>>> +	.dig_cck = rtw8723x_common.dig_cck,
> 
>> This chip doesn't have dig_cck.
> 
> You are right, and I had to reread the vendor tree to figure out why.
> ODM_IC_PHY_STATUE_NEW_TYPE is 8197F | 8822B | 8723D | 8821C | 8710B, no
> 8723B in it, so that write never runs here. dig_cck is NULL.
> 
> Best regards,
> Luka Gejak

