Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54650 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752124AbdATPHe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 10:07:34 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] ath9k: Add frame corruption simulator
References: <1484922570-23659-1-git-send-email-Wojciech.Dubowik@neratec.com>
        <1484922570-23659-3-git-send-email-Wojciech.Dubowik@neratec.com>
Date: Fri, 20 Jan 2017 17:07:29 +0200
In-Reply-To: <1484922570-23659-3-git-send-email-Wojciech.Dubowik@neratec.com>
        (Wojciech Dubowik's message of "Fri, 20 Jan 2017 15:29:30 +0100")
Message-ID: <8760l9n51q.fsf@kamboji.qca.qualcomm.com> (sfid-20170120_160738_128042_373C48F1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wojciech Dubowik <Wojciech.Dubowik@neratec.com> writes:

> Add debugfs entries to corrupt specified frame types
> by invering fcs field upon transmissionm with given probability.
>
> Select frames to be corrupted.
> <ath9k_debugs>/corrupt_fcs_fram_mask:
>  Bit 16 - Null function
>  Bit 15 - QoS Null function
>  Bit 14 - EAPOL
>  Bit 13 - Action
>  Bit 12 - Deauthentication
>  Bit 11 - Authentication
>  Bit 10 - Disassociation
>  Bit 9  - ATIM
>  Bit 8  - Beacon
>  Bit 5  - Probe response
>  Bit 4  - Probe request
>  Bit 3  - Reassociation response
>  Bit 2  - Reassociation request
>  Bit 1  - Association response
>  Bit 0  - Association request
>
> Select corruption probability:
> <ath9k_debugs>/corrupt_fcs_prob: 0(0%) to 255(100%)
>
> Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
> ---
>  drivers/net/wireless/ath/ath9k/Kconfig |  15 +++++
>  drivers/net/wireless/ath/ath9k/ath9k.h |   7 ++
>  drivers/net/wireless/ath/ath9k/debug.c |  51 ++++++++++++++
>  drivers/net/wireless/ath/ath9k/xmit.c  | 117 +++++++++++++++++++++++++++++++++
>  4 files changed, 190 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
> index 8f231c6..ca50f0f 100644
> --- a/drivers/net/wireless/ath/ath9k/Kconfig
> +++ b/drivers/net/wireless/ath/ath9k/Kconfig
> @@ -95,6 +95,21 @@ config ATH9K_TX99
>  	  be evaluated to meet the RF exposure limits set forth in the
>  	  governmental SAR regulations.
>  
> +config ATH9K_FRAME_LOSS_SIMULATOR
> +	bool "Atheros ath9k frame loss simulator"
> +	depends on ATH9K && ATH9K_DEBUGFS && DEBUG_FS
> +	default n
> +	---help---
> +	  Say N. This option should be used only to test fail paths
> +          and timeouts by inverting fcs field of selected frames to
> +	  be transmitted.
> +	  Which frames are corrupted is marked by bitfield in
> +	  corrupt_fcs_frame_mask debug entry and probability of
> +	  of corruption in corrupt_fcs_prob (0-255). Zero means
> +	  disabled and writing 255 makes all selected frames fail.
> +	  Management, EAPOL, and Null function frames are
> +	  supported.

Why a separate Kconfig option? Does this significantly increase memory
consumption or something? I ask because we should be conservative when
adding new Kconfig options.

-- 
Kalle Valo
