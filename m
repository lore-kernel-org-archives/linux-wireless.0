Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:34381 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751021AbcJCICN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 04:02:13 -0400
Received: by mail-wm0-f51.google.com with SMTP id 197so23032365wmk.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Oct 2016 01:02:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1473801118-103112-1-git-send-email-mfaltesek@google.com>
References: <1473801118-103112-1-git-send-email-mfaltesek@google.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 3 Oct 2016 10:02:11 +0200
Message-ID: <CA+BoTQkwSX954pPEh3oYzL62H9y4Y6UuPVLSxxxCkM5AznY7NA@mail.gmail.com> (sfid-20161003_100218_842891_F05B747E)
Subject: Re: [PATCH] ath10k: cache calibration data when the core is stopped.
To: Marty Faltesek <mfaltesek@google.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 September 2016 at 23:11, Marty Faltesek <mfaltesek@google.com> wrote:
[...]
> +int
> +ath10k_cal_data_alloc(struct ath10k *ar, void **buf)
> +{
> +       u32 hi_addr;
> +       __le32 addr;
> +       int ret;
> +
> +       vfree(*buf);
> +       *buf =3D vmalloc(QCA988X_CAL_DATA_LEN);

Shouldn't you use ar->hw_params to get hw-specific caldata length?


[...]
> @@ -1714,6 +1750,12 @@ int ath10k_core_start(struct ath10k *ar, enum ath1=
0k_firmware_mode mode)
>
>         INIT_LIST_HEAD(&ar->arvifs);
>
> +       /*
> +        * We are up now, so no need to cache calibration data.
> +        */

The comment style is:

 /* comment */

If it's multi-line it should be:

 /* comment
  * comment
  */

Ditto for other instances.


[...]
> @@ -1757,6 +1799,11 @@ void ath10k_core_stop(struct ath10k *ar)
>         lockdep_assert_held(&ar->conf_mutex);
>         ath10k_debug_stop(ar);
>
> +       /*
> +        * Cache caclibration data while stopped.

typo. "calibration"


Micha=C5=82
