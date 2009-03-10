Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:22230 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbZCJMof (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 08:44:35 -0400
Received: by fk-out-0910.google.com with SMTP id f33so708866fkf.5
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2009 05:44:32 -0700 (PDT)
Message-ID: <49B660AE.80502@gmail.com> (sfid-20090310_134439_890358_FFC1424E)
Date: Tue, 10 Mar 2009 13:44:30 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org
Subject: Re: [PATCH 2/3] ath5k: Convert chip specific calibration data to
 a generic format
References: <20090310103344.GC3341@makis>
In-Reply-To: <20090310103344.GC3341@makis>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10.3.2009 11:33, Nick Kossifidis wrote:
> --- a/drivers/net/wireless/ath5k/eeprom.c
> +++ b/drivers/net/wireless/ath5k/eeprom.c
...
> +static int
> +ath5k_eeprom_convert_pcal_info_5111(struct ath5k_hw *ah, int mode,
> +				struct ath5k_chan_pcal_info *chinfo)
> +{
> +	struct ath5k_eeprom_info *ee =&ah->ah_capabilities.cap_eeprom;
> +	struct ath5k_chan_pcal_info_rf5111 *pcinfo;
> +	struct ath5k_pdgain_info *pd;
> +	u8 pier, point, idx;
> +	u8 *pdgain_idx = ee->ee_pdc_to_idx[mode];
> +
> +	/* Fill raw data for each calibration pier */
> +	for (pier = 0; pier<  ee->ee_n_piers[mode]; pier++) {
> +
> +		pcinfo =&chinfo[pier].rf5111_info;
> +
> +		/* Allocate pd_curves for this cal pier */
> +		chinfo[pier].pd_curves =
> +			kzalloc(sizeof(struct ath5k_pdgain_info) *
> +				AR5K_EEPROM_N_PD_CURVES, GFP_KERNEL);
...
> +		/* Allocate pd points for this curve */
> +		pd->pd_step = kzalloc(sizeof(u8) *
> +					AR5K_EEPROM_N_PWR_POINTS_5111,
> +					GFP_KERNEL);
> +		if (!pd->pd_step)
> +			return -ENOMEM;
> +
> +		pd->pd_pwr = kzalloc(sizeof(s16) *
> +					AR5K_EEPROM_N_PWR_POINTS_5111,
> +					GFP_KERNEL);

Just a nit, these 3 may be kcalloc. (and in other places too)

>   static int
>   ath5k_eeprom_read_pcal_info_5112(struct ath5k_hw *ah, int mode)
>   {
>   	struct ath5k_eeprom_info *ee =&ah->ah_capabilities.cap_eeprom;
>   	struct ath5k_chan_pcal_info_rf5112 *chan_pcal_info;
>   	struct ath5k_chan_pcal_info *gen_chan_info;
> +	u8 *pdgain_idx = ee->ee_pdc_to_idx[mode];
>   	u32 offset;
> -	unsigned int i, c;
> +	u8 i, c;
>   	u16 val;
>   	int ret;
> +	u8 pd_gains = 0;
> +
> +	/* Count how many curves we have and
> +	 * identify them (which one of the 4
> +	 * available curves we have on each count).
> +	 * Curves are stored from lower (x0) to
> +	 * higher (x3) gain */
> +	memset(pdgain_idx, 0, sizeof(pdgain_idx));

Note, that sizeof(pdgain_idx) == 4 or 8 (pointer size) depending on 
arch, this is likely not what you want :).

(and the other memsets too)
