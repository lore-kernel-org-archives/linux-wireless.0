Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1AE0C65C22
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 13:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A727A2081F
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 13:09:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A727A2081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbeKBWQb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 18:16:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50820 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727497AbeKBWQb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 18:16:31 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 74B8C811C0;
        Fri,  2 Nov 2018 13:09:23 +0000 (UTC)
Received: from localhost (ovpn-204-43.brq.redhat.com [10.40.204.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D18615D6A9;
        Fri,  2 Nov 2018 13:09:18 +0000 (UTC)
Date:   Fri, 2 Nov 2018 14:09:17 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org,
        Cheng-Hao.Luo@mediatek.com, Ryder.Lee@mediatek.com
Subject: Re: [PATCH 2/3] mt76x0: phy: introduce tssi calibration support
Message-ID: <20181102130917.GB5247@redhat.com>
References: <cover.1540848411.git.lorenzo.bianconi@redhat.com>
 <d5d9abef3141a2809f5bf6319fcb407970b7eb19.1540848411.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5d9abef3141a2809f5bf6319fcb407970b7eb19.1540848411.git.lorenzo.bianconi@redhat.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Fri, 02 Nov 2018 13:09:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

(cc Mediatek.com engineers)

On Mon, Oct 29, 2018 at 10:31:24PM +0100, Lorenzo Bianconi wrote:
> Run mt76x0 tssi calibration process if enabled in eeprom data.
> Perform calibration procedure every 4s

I just checked the Mediatek vendor drivers for both MT7610E (at
github https://github.com/i80s/mtk-sources ) and GPL relesed MT7610U driver
are compiled without MT76x0_TSSI_CAL_COMPENSATION define.
So seems TSSI compensation is not used or tested in vendor driver.

Perhaps Cheng-Hao Luo and Ryder Lee at Mediatek could clarify if this
code is needed and is correct.

Thanks
Stanislaw


> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> ---
>  .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 355 +++++++++++++++++-
>  drivers/net/wireless/mediatek/mt76/mt76x02.h  |   3 +
>  .../wireless/mediatek/mt76/mt76x02_eeprom.h   |   2 +
>  3 files changed, 357 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> index 830ea6047f10..f0d46e7bb76a 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> @@ -503,6 +503,345 @@ mt76x0_phy_bbp_set_bw(struct mt76x02_dev *dev, enum nl80211_chan_width width)
>  	mt76x02_mcu_function_select(dev, BW_SETTING, bw, false);
>  }
>  
> +static void mt76x0_phy_tssi_dc_calibrate(struct mt76x02_dev *dev)
> +{
> +	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
> +	u32 val;
> +
> +	if (chan->band == NL80211_BAND_5GHZ)
> +		mt76x0_rf_clear(dev, MT_RF(0, 67), 0xf);
> +
> +	/* bypass ADDA control */
> +	mt76_wr(dev, MT_RF_SETTING_0, 0x60002237);
> +	mt76_wr(dev, MT_RF_BYPASS_0, 0xffffffff);
> +
> +	/* bbp sw reset */
> +	mt76_set(dev, MT_BBP(CORE, 4), BIT(0));
> +	usleep_range(500, 1000);
> +	mt76_clear(dev, MT_BBP(CORE, 4), BIT(0));
> +
> +	val = (chan->band == NL80211_BAND_5GHZ) ? 0x80055 : 0x80050;
> +	mt76_wr(dev, MT_BBP(CORE, 34), val);
> +
> +	/* enable TX with DAC0 input */
> +	mt76_wr(dev, MT_BBP(TXBE, 6), BIT(31));
> +
> +	mt76_poll_msec(dev, MT_BBP(CORE, 34), BIT(4), 0, 200);
> +	dev->cal.tssi_dc = mt76_rr(dev, MT_BBP(CORE, 35)) & 0xff;
> +
> +	/* stop bypass ADDA */
> +	mt76_wr(dev, MT_RF_BYPASS_0, 0);
> +	/* stop TX */
> +	mt76_wr(dev, MT_BBP(TXBE, 6), 0);
> +	/* bbp sw reset */
> +	mt76_set(dev, MT_BBP(CORE, 4), BIT(0));
> +	usleep_range(500, 1000);
> +	mt76_clear(dev, MT_BBP(CORE, 4), BIT(0));
> +
> +	if (chan->band == NL80211_BAND_5GHZ)
> +		mt76x0_rf_rmw(dev, MT_RF(0, 67), 0xf, 0x4);
> +}
> +
> +static int
> +mt76x0_phy_tssi_adc_calibrate(struct mt76x02_dev *dev, s16 *ltssi,
> +			      u8 *info)
> +{
> +	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
> +	u32 val;
> +
> +	val = (chan->band == NL80211_BAND_5GHZ) ? 0x80055 : 0x80050;
> +	mt76_wr(dev, MT_BBP(CORE, 34), val);
> +
> +	if (!mt76_poll_msec(dev, MT_BBP(CORE, 34), BIT(4), 0, 200)) {
> +		mt76_clear(dev, MT_BBP(CORE, 34), BIT(4));
> +		return -ETIMEDOUT;
> +	}
> +
> +	*ltssi = mt76_rr(dev, MT_BBP(CORE, 35)) & 0xff;
> +	if (chan->band == NL80211_BAND_5GHZ)
> +		*ltssi += 128;
> +
> +	/* set packet info#1 mode */
> +	mt76_wr(dev, MT_BBP(CORE, 34), 0x80041);
> +	info[0] = mt76_rr(dev, MT_BBP(CORE, 35)) & 0xff;
> +
> +	/* set packet info#2 mode */
> +	mt76_wr(dev, MT_BBP(CORE, 34), 0x80042);
> +	info[1] = mt76_rr(dev, MT_BBP(CORE, 35)) & 0xff;
> +
> +	/* set packet info#3 mode */
> +	mt76_wr(dev, MT_BBP(CORE, 34), 0x80043);
> +	info[2] = mt76_rr(dev, MT_BBP(CORE, 35)) & 0xff;
> +
> +	return 0;
> +}
> +
> +static u8 mt76x0_phy_get_rf_pa_mode(struct mt76x02_dev *dev,
> +				    int index, u8 tx_rate)
> +{
> +	u32 val, reg;
> +
> +	reg = (index == 1) ? MT_RF_PA_MODE_CFG1 : MT_RF_PA_MODE_CFG0;
> +	val = mt76_rr(dev, reg);
> +	return (val & (3 << (tx_rate * 2))) >> (tx_rate * 2);
> +}
> +
> +static int
> +mt76x0_phy_get_target_power(struct mt76x02_dev *dev, u8 tx_mode,
> +			    u8 *info, s8 *target_power,
> +			    s8 *target_pa_power)
> +{
> +	u8 tx_rate, cur_power;
> +
> +	cur_power = mt76_rr(dev, MT_TX_ALC_CFG_0) & MT_TX_ALC_CFG_0_CH_INIT_0;
> +	switch (tx_mode) {
> +	case 0:
> +		/* cck rates */
> +		tx_rate = (info[0] & 0x60) >> 5;
> +		if (tx_rate > 3)
> +			return -EINVAL;
> +
> +		*target_power = cur_power + dev->mt76.rate_power.cck[tx_rate];
> +		*target_pa_power = mt76x0_phy_get_rf_pa_mode(dev, 0, tx_rate);
> +		break;
> +	case 1: {
> +		u8 index;
> +
> +		/* ofdm rates */
> +		tx_rate = (info[0] & 0xf0) >> 4;
> +		switch (tx_rate) {
> +		case 0xb:
> +			index = 0;
> +			break;
> +		case 0xf:
> +			index = 1;
> +			break;
> +		case 0xa:
> +			index = 2;
> +			break;
> +		case 0xe:
> +			index = 3;
> +			break;
> +		case 0x9:
> +			index = 4;
> +			break;
> +		case 0xd:
> +			index = 5;
> +			break;
> +		case 0x8:
> +			index = 6;
> +			break;
> +		case 0xc:
> +			index = 7;
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +
> +		*target_power = cur_power + dev->mt76.rate_power.ofdm[index];
> +		*target_pa_power = mt76x0_phy_get_rf_pa_mode(dev, 0, index + 4);
> +		break;
> +	}
> +	case 4:
> +		/* vht rates */
> +		tx_rate = info[1] & 0xf;
> +		if (tx_rate > 9)
> +			return -EINVAL;
> +
> +		*target_power = cur_power + dev->mt76.rate_power.vht[tx_rate];
> +		*target_pa_power = mt76x0_phy_get_rf_pa_mode(dev, 1, tx_rate);
> +		break;
> +	default:
> +		/* ht rates */
> +		tx_rate = info[1] & 0x7f;
> +		if (tx_rate > 9)
> +			return -EINVAL;
> +
> +		*target_power = cur_power + dev->mt76.rate_power.ht[tx_rate];
> +		*target_pa_power = mt76x0_phy_get_rf_pa_mode(dev, 1, tx_rate);
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static s16 mt76x0_phy_lin2db(u16 val)
> +{
> +	u32 mantissa = val << 4;
> +	int ret, data;
> +	s16 exp = -4;
> +
> +	while (mantissa < BIT(15)) {
> +		mantissa <<= 1;
> +		if (--exp < -20)
> +			return -10000;
> +	}
> +	while (mantissa > 0xffff) {
> +		mantissa >>= 1;
> +		if (++exp > 20)
> +			return -10000;
> +	}
> +
> +	/* s(15,0) */
> +	if (mantissa <= 47104)
> +		data = mantissa + (mantissa >> 3) + (mantissa >> 4) - 38400;
> +	else
> +		data = mantissa - (mantissa >> 3) - (mantissa >> 6) - 23040;
> +	data = max_t(int, 0, data);
> +
> +	ret = ((15 + exp) << 15) + data;
> +	ret = (ret << 2) + (ret << 1) + (ret >> 6) + (ret >> 7);
> +	return ret >> 10;
> +}
> +
> +static int
> +mt76x0_phy_get_delta_power(struct mt76x02_dev *dev, u8 tx_mode,
> +			   s8 target_power, s8 target_pa_power,
> +			   s16 ltssi)
> +{
> +	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
> +	int tssi_target = target_power << 12, tssi_slope;
> +	int tssi_offset, tssi_db, ret;
> +	u32 data;
> +	u16 val;
> +
> +	if (chan->band == NL80211_BAND_5GHZ) {
> +		u8 bound[7];
> +		int i, err;
> +
> +		err = mt76x02_eeprom_copy(dev, MT_EE_TSSI_BOUND1, bound,
> +					  sizeof(bound));
> +		if (err < 0)
> +			return err;
> +
> +		for (i = 0; i < ARRAY_SIZE(bound); i++) {
> +			if (chan->hw_value <= bound[i] || !bound[i])
> +				break;
> +		}
> +		val = mt76x02_eeprom_get(dev, MT_EE_TSSI_SLOPE_5G + i * 2);
> +
> +		tssi_offset = val >> 8;
> +		if ((tssi_offset >= 64 && tssi_offset <= 127) ||
> +		    (tssi_offset & BIT(7)))
> +			tssi_offset -= BIT(8);
> +	} else {
> +		val = mt76x02_eeprom_get(dev, MT_EE_TSSI_SLOPE_2G);
> +
> +		tssi_offset = val >> 8;
> +		if (tssi_offset & BIT(7))
> +			tssi_offset -= BIT(8);
> +	}
> +	tssi_slope = val & 0xff;
> +
> +	switch (target_pa_power) {
> +	case 1:
> +		if (chan->band == NL80211_BAND_2GHZ)
> +			tssi_target += 29491; /* 3.6 * 8192 */
> +		/* fall through */
> +	case 0:
> +		break;
> +	default:
> +		tssi_target += 4424; /* 0.54 * 8192 */
> +		break;
> +	}
> +
> +	if (!tx_mode) {
> +		data = mt76_rr(dev, MT_BBP(CORE, 1));
> +		if (is_mt7630(dev) && mt76_is_mmio(dev)) {
> +			int offset;
> +
> +			/* 2.3 * 8192 or 1.5 * 8192 */
> +			offset = (data & BIT(5)) ? 18841 : 12288;
> +			tssi_target += offset;
> +		} else if (data & BIT(5)) {
> +			/* 0.8 * 8192 */
> +			tssi_target += 6554;
> +		}
> +	}
> +
> +	data = mt76_rr(dev, MT_BBP(TXBE, 4));
> +	switch (data & 0x3) {
> +	case 1:
> +		tssi_target -= 49152; /* -6db * 8192 */
> +		break;
> +	case 2:
> +		tssi_target -= 98304; /* -12db * 8192 */
> +		break;
> +	case 3:
> +		tssi_target += 49152; /* 6db * 8192 */
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	tssi_db = mt76x0_phy_lin2db(ltssi - dev->cal.tssi_dc) * tssi_slope;
> +	if (chan->band == NL80211_BAND_5GHZ) {
> +		tssi_db += ((tssi_offset - 50) << 10); /* offset s4.3 */
> +		tssi_target -= tssi_db;
> +		if (ltssi > 254 && tssi_target > 0) {
> +			/* upper saturate */
> +			tssi_target = 0;
> +		}
> +	} else {
> +		tssi_db += (tssi_offset << 9); /* offset s3.4 */
> +		tssi_target -= tssi_db;
> +		/* upper-lower saturate */
> +		if ((ltssi > 126 && tssi_target > 0) ||
> +		    ((ltssi - dev->cal.tssi_dc) < 1 && tssi_target < 0)) {
> +			tssi_target = 0;
> +		}
> +	}
> +
> +	if ((dev->cal.tssi_target ^ tssi_target) < 0 &&
> +	    dev->cal.tssi_target > -4096 && dev->cal.tssi_target < 4096 &&
> +	    tssi_target > -4096 && tssi_target < 4096) {
> +		if ((tssi_target < 0 &&
> +		     tssi_target + dev->cal.tssi_target > 0) ||
> +		    (tssi_target > 0 &&
> +		     tssi_target + dev->cal.tssi_target <= 0))
> +			tssi_target = 0;
> +		else
> +			dev->cal.tssi_target = tssi_target;
> +	} else {
> +		dev->cal.tssi_target = tssi_target;
> +	}
> +
> +	/* make the compensate value to the nearest compensate code */
> +	if (tssi_target > 0)
> +		tssi_target += 2048;
> +	else
> +		tssi_target -= 2048;
> +	tssi_target >>= 12;
> +
> +	ret = mt76_get_field(dev, MT_TX_ALC_CFG_1, MT_TX_ALC_CFG_1_TEMP_COMP);
> +	if (ret & BIT(5))
> +		ret -= BIT(6);
> +	ret += tssi_target;
> +
> +	ret = min_t(int, 31, ret);
> +	return max_t(int, -32, ret);
> +}
> +
> +static void mt76x0_phy_tssi_calibrate(struct mt76x02_dev *dev)
> +{
> +	s8 target_power, target_pa_power;
> +	u8 tssi_info[3], tx_mode;
> +	s16 ltssi;
> +	s8 val;
> +
> +	if (mt76x0_phy_tssi_adc_calibrate(dev, &ltssi, tssi_info) < 0)
> +		return;
> +
> +	tx_mode = tssi_info[0] & 0x7;
> +	if (mt76x0_phy_get_target_power(dev, tx_mode, tssi_info,
> +					&target_power, &target_pa_power) < 0)
> +		return;
> +
> +	val = mt76x0_phy_get_delta_power(dev, tx_mode, target_power,
> +					 target_pa_power, ltssi);
> +	mt76_rmw_field(dev, MT_TX_ALC_CFG_1, MT_TX_ALC_CFG_1_TEMP_COMP, val);
> +}
> +
>  void mt76x0_phy_set_txpower(struct mt76x02_dev *dev)
>  {
>  	struct mt76_rate_power *t = &dev->mt76.rate_power;
> @@ -532,7 +871,15 @@ void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on)
>  		mt76x02_mcu_calibrate(dev, MCU_CAL_VCO, chan->hw_value,
>  				      false);
>  		usleep_range(10, 20);
> -		/* XXX: tssi */
> +
> +		if (mt76x0_tssi_enabled(dev)) {
> +			mt76_wr(dev, MT_MAC_SYS_CTRL,
> +				MT_MAC_SYS_CTRL_ENABLE_RX);
> +			mt76x0_phy_tssi_dc_calibrate(dev);
> +			mt76_wr(dev, MT_MAC_SYS_CTRL,
> +				MT_MAC_SYS_CTRL_ENABLE_TX |
> +				MT_MAC_SYS_CTRL_ENABLE_RX);
> +		}
>  	}
>  
>  	tx_alc = mt76_rr(dev, MT_TX_ALC_CFG_0);
> @@ -761,11 +1108,13 @@ static void mt76x0_phy_calibration_work(struct work_struct *work)
>  					       cal_work.work);
>  
>  	mt76x0_phy_update_channel_gain(dev);
> -	if (!mt76x0_tssi_enabled(dev))
> +	if (mt76x0_tssi_enabled(dev))
> +		mt76x0_phy_tssi_calibrate(dev);
> +	else
>  		mt76x0_phy_temp_sensor(dev);
>  
>  	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
> -				     MT_CALIBRATE_INTERVAL);
> +				     4 * MT_CALIBRATE_INTERVAL);
>  }
>  
>  static void mt76x0_rf_patch_reg_array(struct mt76x02_dev *dev,
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
> index d599b7dddac7..de1be1529f61 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
> @@ -57,6 +57,9 @@ struct mt76x02_calibration {
>  	bool tssi_comp_pending;
>  	bool dpd_cal_done;
>  	bool channel_cal_done;
> +
> +	int tssi_target;
> +	s8 tssi_dc;
>  };
>  
>  struct mt76x02_dev {
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
> index 5db01bda64b5..e3442bc4e0a4 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.h
> @@ -56,6 +56,7 @@ enum mt76x02_eeprom_field {
>  #define MT_TX_POWER_GROUP_SIZE_5G		5
>  #define MT_TX_POWER_GROUPS_5G			6
>  	MT_EE_TX_POWER_0_START_5G =		0x062,
> +	MT_EE_TSSI_SLOPE_2G =			0x06e,
>  
>  	MT_EE_TX_POWER_0_GRP3_TX_POWER_DELTA =	0x074,
>  	MT_EE_TX_POWER_0_GRP4_TSSI_SLOPE =	0x076,
> @@ -86,6 +87,7 @@ enum mt76x02_eeprom_field {
>  	MT_EE_TSSI_BOUND5 =			0x0dc,
>  	MT_EE_TX_POWER_BYRATE_BASE =		0x0de,
>  
> +	MT_EE_TSSI_SLOPE_5G =			0x0f0,
>  	MT_EE_RF_TEMP_COMP_SLOPE_5G =		0x0f2,
>  	MT_EE_RF_TEMP_COMP_SLOPE_2G =		0x0f4,
>  
> -- 
> 2.19.1
> 
