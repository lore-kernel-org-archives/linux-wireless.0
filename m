Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:33433 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbcG0MnM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2016 08:43:12 -0400
Received: by mail-wm0-f47.google.com with SMTP id p129so30925859wmp.0
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jul 2016 05:43:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1469623006-13178-3-git-send-email-vthiagar@qti.qualcomm.com>
References: <1469623006-13178-1-git-send-email-vthiagar@qti.qualcomm.com> <1469623006-13178-3-git-send-email-vthiagar@qti.qualcomm.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Wed, 27 Jul 2016 14:43:09 +0200
Message-ID: <CA+BoTQ=kUP-Qtw1EWKKfM_aGtJS_4oQdz4tqD5tiJkF_k3-vOA@mail.gmail.com> (sfid-20160727_144316_227483_3A0D640B)
Subject: Re: [PATCH 2/4] ath10k: Add provision for Rx descriptor abstraction
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 July 2016 at 14:36, Vasanthakumar Thiagarajan
<vthiagar@qti.qualcomm.com> wrote:
> There are slight differences in Rx hw descriptor information
> among different chips. So far driver does not use those new
> information for any functionalities, but there is one important
> information which is available from QCA99X0 onwards to indicate
> the number of bytes that hw padded at the begining of the rx
> payload and this information is needed to undecap the rx
> packet. Add an abstraction for Rx desc to make use of the
> new desc information available. The callback that this patch
> defines to retrieve the padding bytes will be used in follow-up
> patch.
>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.c | 12 ++++++++++++
>  drivers/net/wireless/ath/ath10k/hw.c   | 13 +++++++++++++
>  drivers/net/wireless/ath/ath10k/hw.h   | 12 ++++++++++++
>  3 files changed, 37 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index e889829..9c5e93b 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -68,6 +68,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
>                         .board_size = QCA988X_BOARD_DATA_SZ,
>                         .board_ext_size = QCA988X_BOARD_EXT_DATA_SZ,
>                 },
> +               .hw_rx_desc_ops = &qca988x_rx_desc_ops,
[...]
> +struct ath10k_hw_rx_desc_ops {
> +       int (*rx_desc_get_l3_pad_bytes)(struct htt_rx_desc *rxd);
> +};

Benjamin is trying to implement coverage class by poking hw registers
over firmware's head [1]. I'm thinking the hw_rx_desc_ops could be
generalized to hw_ops so it can be used for doing hw-specific hacks as
well. What do you think?

[1]: http://lists.infradead.org/pipermail/ath10k/2016-July/008107.html


Michał
