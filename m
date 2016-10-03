Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39644 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbcJCHvx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 03:51:53 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Marty Faltesek <mfaltesek@google.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: cache calibration data when the core is stopped.
Date: Mon, 3 Oct 2016 07:51:45 +0000
Message-ID: <87bmz1swdr.fsf@kamboji.qca.qualcomm.com> (sfid-20161003_095156_139475_ADD72684)
References: <1473801118-103112-1-git-send-email-mfaltesek@google.com>
In-Reply-To: <1473801118-103112-1-git-send-email-mfaltesek@google.com> (Marty
        Faltesek's message of "Tue, 13 Sep 2016 17:11:58 -0400")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marty Faltesek <mfaltesek@google.com> writes:

> Caching calibration data allows it to be accessed when the
> device is not active.
>
> Signed-off-by: Marty Faltesek <mfaltesek@google.com>

[...]

> +int
> +ath10k_cal_data_alloc(struct ath10k *ar, void **buf)
> +{

[...]

> +	ath10k_cal_data_alloc(ar, &ar->cal_data);
[...]

> +	ret =3D ath10k_cal_data_alloc(ar, &file->private_data);

Pointer to pointer parameters can be a source of problems and if we
could use one shared buffer for both of these cases when it would
simplify the code and we would need the buf parameter at all.

--=20
Kalle Valo=
