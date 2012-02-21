Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49987 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab2BUMZV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 07:25:21 -0500
Received: by iacb35 with SMTP id b35so8831192iac.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2012 04:25:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20291.25241.5396.839366@gargle.gargle.HOWL>
References: <20291.25241.5396.839366@gargle.gargle.HOWL>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 21 Feb 2012 23:25:01 +1100
Message-ID: <CAGRGNgVNRR=KRXrjYFSisQisd97gGPOxy4GE0iRipk7ZCLDQOA@mail.gmail.com> (sfid-20120221_132525_086966_3246A02A)
Subject: Re: [RFC/WIP 16/22] ath9k_hw: Use CONFIG_ATH9K_BTCOEX_SUPPORT
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith,

On Tue, Feb 21, 2012 at 20:23, Sujith Manoharan
<c_manoha@qca.qualcomm.com> wrote:
> Make use of CONFIG_ATH9K_BTCOEX_SUPPORT in ath9k_hw
> to provide a clean way of compilation without BTCOEX
> support.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/Makefile     |    6 +-
>  drivers/net/wireless/ath/ath9k/ar9003_mci.h |   63 ++++++++++++++++++++++++---
>  drivers/net/wireless/ath/ath9k/btcoex.h     |    1 -
>  drivers/net/wireless/ath/ath9k/hw.c         |    3 +-
>  drivers/net/wireless/ath/ath9k/hw.h         |   12 +++++-
>  5 files changed, 71 insertions(+), 14 deletions(-)
>
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

If I recall correctly, the recommended form here is to create a inline
function that returns false, rather than the #define - this way the
type checking of the function's arguments still happens when
CONFIG_ATH9K_BTCOEX_SUPPORT is disabled.

You've done this a couple of other times in this patch too.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
