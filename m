Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44119 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758910Ab2ILRyD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2012 13:54:03 -0400
Received: by lagy9 with SMTP id y9so1311483lag.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Sep 2012 10:54:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20560.11160.528440.961924@gargle.gargle.HOWL>
References: <20560.11160.528440.961924@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 12 Sep 2012 10:53:40 -0700
Message-ID: <CAB=NE6X+eyvPy+-TpU7+53u8o+B9LMLKwb1K-AWTOG79zGoMGg@mail.gmail.com> (sfid-20120912_195407_563344_0C78605D)
Subject: Re: [PATCH] qca-swiss-army-knife: Update AR9565 initvals
To: Sujith Manoharan <c_manoha@qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 11, 2012 at 11:28 PM, Sujith Manoharan
<c_manoha@qualcomm.com> wrote:
> * Set BB_tpc_1.enable_pd_calibrate to 0
>
> * Set BB_cl_cal_ctrl.enable_parallel_cal to 1
>
> * Enable "enable_dac_async_fifo" and "enable_adc_async_fifo"
>   to fix some dac/adc timing issue,
>   e.g. EVM won't degrade when setting core voltage to 1.15V.
>
>   Set BB_gen_controls.enable_dac_async_fifo=1
>   Set BB_gen_controls.enable_adc_async_fifo=1
>
> * Improve LNA2 Sensitivity ~1dB
>   Set ch0_PLLCLKMODA2WLAN.inv_clk320_adc_ch0 = 1
>
> * Correct alternate chain RSSI when doing diversity
>   Set BB_bbb_sig_detect.ant_switch_time to 63
>
> * Refer to RACK RX gain report and modify RF gain table for LNA2
>
> * Invert the phase of the root of both clocks
>   (setting flip_pllclk320 = 1) and set inv_clk320_adc back = 0.
>
>   Set ch0_PLLCLKMODA2WLAN.flip_pllclk320 to 1
>   Set ch0_PLLCLKMODA2WLAN.inv_clk320_adc_ch0 to 0
>
> * Remove MAC PCU registers MAC_PCU_TSF_L32/MAC_PCU_TSF_U32.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

thanks, applied and pushed both patches, sorry for the delay in
applying the other patch.

  Luis
