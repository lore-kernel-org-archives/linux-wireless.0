Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38802 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755484AbcKOKba (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 05:31:30 -0500
Received: by mail-wm0-f48.google.com with SMTP id f82so159348925wmf.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Nov 2016 02:31:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1479141222-8493-10-git-send-email-erik.stromdahl@gmail.com>
References: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com> <1479141222-8493-10-git-send-email-erik.stromdahl@gmail.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Tue, 15 Nov 2016 11:31:28 +0100
Message-ID: <CA+BoTQnohNffDOt_mYRuATv9wBAvOy=t6hGdS9MVRkZuwRE1nA@mail.gmail.com> (sfid-20161115_113134_277662_69596DBA)
Subject: Re: [RFC 09/12] ath10k: Mailbox address definitions
To: Erik Stromdahl <erik.stromdahl@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 November 2016 at 17:33, Erik Stromdahl <erik.stromdahl@gmail.com> wro=
te:
> Address definitions for SDIO/mbox based chipsets.
>
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> ---
>  drivers/net/wireless/ath/ath10k/hw.h |   53 ++++++++++++++++++++++++++++=
++++++
>  1 file changed, 53 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/=
ath/ath10k/hw.h
> index 883547f..46142e9 100644
> --- a/drivers/net/wireless/ath/ath10k/hw.h
> +++ b/drivers/net/wireless/ath/ath10k/hw.h
> @@ -814,6 +814,59 @@ struct ath10k_hw_ops {
>  #define QCA9887_EEPROM_ADDR_LO_MASK            0x00ff0000
>  #define QCA9887_EEPROM_ADDR_LO_LSB             16
>
> +#define MBOX_RESET_CONTROL_ADDRESS             0x00000000
> +#define MBOX_HOST_INT_STATUS_ADDRESS           0x00000800
> +#define MBOX_HOST_INT_STATUS_ERROR_LSB         7
> +#define MBOX_HOST_INT_STATUS_ERROR_MASK                0x00000080

I would again suggest using Jakub's bitfield GET_FIELD stuff to get
rid of MASK+LSB and just have single define per register field. Kalle,
thoughts?


Micha=C5=82
