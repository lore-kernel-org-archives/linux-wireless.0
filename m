Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:35701 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966504AbcKOKTW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 05:19:22 -0500
Received: by mail-wm0-f49.google.com with SMTP id a197so156779985wmd.0
        for <linux-wireless@vger.kernel.org>; Tue, 15 Nov 2016 02:19:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1479141222-8493-5-git-send-email-erik.stromdahl@gmail.com>
References: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com> <1479141222-8493-5-git-send-email-erik.stromdahl@gmail.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Tue, 15 Nov 2016 11:19:20 +0100
Message-ID: <CA+BoTQnTkwQjmNBdr8a+YauXffWGNBNyPTZ=RByoviTSp+1ZYQ@mail.gmail.com> (sfid-20161115_111932_665747_ECC4B5B6)
Subject: Re: [RFC 04/12] ath10k: htc: refactorization
To: Erik Stromdahl <erik.stromdahl@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 November 2016 at 17:33, Erik Stromdahl <erik.stromdahl@gmail.com> wro=
te:
> Code refactorization:
>
> Moved the code for ep 0 in ath10k_htc_rx_completion_handler
> to ath10k_htc_control_rx_complete.
>
> This eases the implementation of SDIO/mbox significantly since
> the ep_rx_complete cb is invoked directly from the SDIO/mbox
> hif layer.
>
> Since the ath10k_htc_control_rx_complete already is present
> (only containing a warning message) there is no reason for not
> using it (instead of having a special case for ep 0 in
> ath10k_htc_rx_completion_handler).

This should be squashed with Patch 3 since it's inseparable part of
the same refactorization.


Micha=C5=82
