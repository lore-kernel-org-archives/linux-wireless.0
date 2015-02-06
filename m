Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:50447 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbbBFL6r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 06:58:47 -0500
Received: by mail-wg0-f52.google.com with SMTP id y19so13041497wgg.11
        for <linux-wireless@vger.kernel.org>; Fri, 06 Feb 2015 03:58:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1423223238-17530-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1423223238-17530-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Fri, 6 Feb 2015 12:58:40 +0100
Message-ID: <CA+BoTQnwo=yXt2-57pv97KRCjw6r=0mtRVNt0jLwaeGsEfThNg@mail.gmail.com> (sfid-20150206_125851_318531_242E2F6A)
Subject: Re: [PATCH 1/2] ath10k: Bypass PLL setting on target init for QCA9888
From: Michal Kazior <michal.kazior@tieto.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 February 2015 at 12:47, Rajkumar Manoharan
<rmanohar@qti.qualcomm.com> wrote:
> Some of of qca988x solutions are having global reset issue
> during target initialization.

What kind of issue? How/when does it manifest?


> Bypassing PLL setting before
> downloading firmware and letting the SoC run on REF_CLK is fixing
> the problem. Corresponding firmware change is also needed to set
> the clock source once the target is initialized. Since 10.2.4
> firmware is having this ROM patch, applying skip_clock_init only
> for 10.2.4 firmware versions.

Which 10.2.4? There are at least two publicly available blobs. Do all
of them support this? How do other firmware revisions handle setting
skip_clock_init to 1?


> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 310e12b..3119192 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -797,6 +797,20 @@ static int ath10k_download_cal_data(struct ath10k *ar)
>         ar->cal_mode = ATH10K_CAL_MODE_OTP;
>
>  done:
> +       if ((ar->hw_rev != ATH10K_HW_QCA988X) ||
> +           (ar->wmi.op_version != ATH10K_FW_WMI_OP_VERSION_10_2_4)) {

Maybe using fw_features is a better idea, no?


> +               ath10k_dbg(ar, ATH10K_DBG_BOOT,
> +                          "boot using calibration mode %s\n",
> +                          ath10k_cal_mode_str(ar->cal_mode));

I don't really like the idea of duplicating debug prints.


> +               return 0;
> +       }
> +
> +       ret = ath10k_bmi_write32(ar, hi_skip_clock_init, 1);
> +       if (ret) {
> +               ath10k_err(ar, "could not write skip_clock_init (%d)\n", ret);
> +               return ret;
> +       }
> +
>         ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot using calibration mode %s\n",
>                    ath10k_cal_mode_str(ar->cal_mode));
>         return 0;


Michał
