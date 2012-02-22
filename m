Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43132 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab2BVK6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 05:58:44 -0500
Received: by iacb35 with SMTP id b35so10168172iac.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Feb 2012 02:58:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20292.38178.132196.432415@gargle.gargle.HOWL>
References: <20292.38178.132196.432415@gargle.gargle.HOWL>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 22 Feb 2012 21:58:23 +1100
Message-ID: <CAGRGNgUTDAuncGyoXp5Y3pNPvVjPWWppsnH_qj+4HWrJWX-thw@mail.gmail.com> (sfid-20120222_115847_534964_DCD3E4C5)
Subject: Re: [PATCH 16/26] ath9k_hw: Use CONFIG_ATH9K_BTCOEX_SUPPORT
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith,

On Wed, Feb 22, 2012 at 18:11, Sujith Manoharan
<c_manoha@qca.qualcomm.com> wrote:
> Make use of CONFIG_ATH9K_BTCOEX_SUPPORT in ath9k_hw
> to provide a clean way of compilation without BTCOEX
> support.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
> index 507527b..de94f69 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
> @@ -272,13 +288,46 @@ int ar9003_mci_end_reset(struct ath_hw *ah, struct ath9k_channel *chan,
>                         struct ath9k_hw_cal_data *caldata);
>  void ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
>                      bool is_full_sleep);
> -void ar9003_mci_get_interrupt(struct ath_hw *ah, u32 *raw_intr,
> -                             u32 *rx_msg_intr);
>  void ar9003_mci_get_isr(struct ath_hw *ah, enum ath9k_int *masked);
>
> -static inline bool ar9003_mci_is_ready(struct ath_hw *ah)
> +#else
> +
> +#define ar9003_mci_is_ready(...) false

You missed one =)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
