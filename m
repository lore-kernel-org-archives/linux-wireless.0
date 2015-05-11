Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34673 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbbEKGFL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 02:05:11 -0400
Received: by wgic8 with SMTP id c8so91246389wgi.1
        for <linux-wireless@vger.kernel.org>; Sun, 10 May 2015 23:05:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1431093663-15206-1-git-send-email-c_mpubbi@qti.qualcomm.com>
References: <1431093663-15206-1-git-send-email-c_mpubbi@qti.qualcomm.com>
Date: Mon, 11 May 2015 08:05:10 +0200
Message-ID: <CA+BoTQ=480Wg4WmL0eBZ7CS9aVHjH8Lt-2x-FzAuGwsAuNA8-w@mail.gmail.com> (sfid-20150511_080516_901438_005D40C5)
Subject: Re: [PATCH] ath10k: new debugfs interface to enable adaptive CCA
From: Michal Kazior <michal.kazior@tieto.com>
To: c_mpubbi@qti.qualcomm.com
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 May 2015 at 16:01,  <c_mpubbi@qti.qualcomm.com> wrote:
> From: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>
>
> For devices working in 2.4 GHz to be ETSI compliant,
> it is required to support adaptive CCA. Some firmwares
> support adaptive CCA and is disabled by default.
>
> The patch is an attempt to add a new debugfs interface to enable
> adaptive cca on supported firmwares. Support for this feature is
> advertised with a new firmware feature flag.

I guess this should be configured automatically depending on DFS
domain. You can't expect users to configure their devices via debugfs,
can you? This should just work.


> Signed-off-by: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.h    |  9 ++++--
>  drivers/net/wireless/ath/ath10k/debug.c   | 52 +++++++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath10k/wmi-ops.h | 21 +++++++++++++
>  drivers/net/wireless/ath/ath10k/wmi.c     | 31 ++++++++++++++++++
>  drivers/net/wireless/ath/ath10k/wmi.h     | 10 ++++++
>  5 files changed, 121 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index 827b3d7..89176f1 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -461,10 +461,13 @@ enum ath10k_fw_features {
>         ATH10K_FW_FEATURE_WOWLAN_SUPPORT = 6,
>
>         /* Don't trust error code from otp.bin */
> -       ATH10K_FW_FEATURE_IGNORE_OTP_RESULT,
> +       ATH10K_FW_FEATURE_IGNORE_OTP_RESULT = 7,
> +
> +       /* Firmware has support for adaptive CCA */
> +       ATH10K_FW_FEATURE_HAS_ADAPTIVE_CCA = 8,
>
>         /* keep last */
> -       ATH10K_FW_FEATURE_COUNT,
> +       ATH10K_FW_FEATURE_COUNT

There's no need to remove the comma, is there?


>  };
>
>  enum ath10k_dev_flags {
> @@ -726,6 +729,8 @@ struct ath10k {
>         struct ath10k_thermal thermal;
>         struct ath10k_wow wow;
>
> +       bool ath10k_adaptive_cca_enable;
> +

Maybe just adaptive_cca?


[...]
> diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
> index 47fe2e7..eb7991e 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
> +++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
> @@ -174,6 +174,10 @@ struct wmi_ops {
>                                                 const struct wmi_tdls_peer_capab_arg *cap,
>                                                 const struct wmi_channel_arg *chan);
>         struct sk_buff *(*gen_adaptive_qcs)(struct ath10k *ar, bool enable);
> +       struct sk_buff *(*gen_pdev_enable_adaptive_cca)(struct ath10k *ar,
> +                                                       u8 enable,
> +                                                       int detect_level,
> +                                                       u32 detect_margin);

I'm just picky here - but you could probably use "s32" for signed
values instead of "int". This way function argument types would be
more unified/consistent.


Michał
