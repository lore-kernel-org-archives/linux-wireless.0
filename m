Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f178.google.com ([209.85.210.178]:33061 "EHLO
        mail-wj0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964794AbcKXJzi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Nov 2016 04:55:38 -0500
Received: by mail-wj0-f178.google.com with SMTP id xy5so29358469wjc.0
        for <linux-wireless@vger.kernel.org>; Thu, 24 Nov 2016 01:55:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <99d0ff42e57d5f62560e72d926b4d69d5d7c418b.1479974100.git.kirtika@chromium.org>
References: <cover.1479974100.git.kirtika@chromium.org> <99d0ff42e57d5f62560e72d926b4d69d5d7c418b.1479974100.git.kirtika@chromium.org>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Thu, 24 Nov 2016 10:50:19 +0100
Message-ID: <CA+BoTQntqod=Aj7MzuU0KfmbTQb7A-zEcySWqVkycSYE-MqtDQ@mail.gmail.com> (sfid-20161124_105542_660741_D7709BDD)
Subject: Re: [PATCH 3/5] ath10k: Remove unused wmi_p2p_noa_descriptor 'noa' in wmi-tlv
To: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, Arnd Bergmann <arnd@arndb.de>,
        Network Development <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Raja Mani <rmani@qti.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 November 2016 at 09:01, Kirtika Ruchandani
<kirtika.ruchandani@gmail.com> wrote:
> Commit ca996ec56608 (ath10k: implement wmi-tlv backend)
> introduced ath10k_wmi_tlv_op_gen_vdev_start() where
> 'struct wmi_p2p_noa_descriptor *noa' is defined and set but not used.
> Compiling with W=3D1 gives the following warning, fix it.
> drivers/net/wireless/ath/ath10k/wmi-tlv.c: In function =E2=80=98ath10k_wm=
i_tlv_op_gen_vdev_start=E2=80=99:
> drivers/net/wireless/ath/ath10k/wmi-tlv.c:1647:33: warning: variable =E2=
=80=98noa=E2=80=99 set but not used [-Wunused-but-set-variable]
>
> Fixes: ca996ec56608 ("ath10k: implement wmi-tlv backend")
> Cc: Michal Kazior <michal.kazior@tieto.com>
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Kirtika Ruchandani <kirtika@chromium.org>
> ---
>  drivers/net/wireless/ath/ath10k/wmi-tlv.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wire=
less/ath/ath10k/wmi-tlv.c
> index e64f593..0e4bd29 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
> @@ -1644,7 +1644,6 @@ ath10k_wmi_tlv_op_gen_vdev_start(struct ath10k *ar,
>  {
>         struct wmi_tlv_vdev_start_cmd *cmd;
>         struct wmi_channel *ch;
> -       struct wmi_p2p_noa_descriptor *noa;
>         struct wmi_tlv *tlv;
>         struct sk_buff *skb;
>         size_t len;
> @@ -1702,7 +1701,6 @@ ath10k_wmi_tlv_op_gen_vdev_start(struct ath10k *ar,
>         tlv =3D ptr;
>         tlv->tag =3D __cpu_to_le16(WMI_TLV_TAG_ARRAY_STRUCT);
>         tlv->len =3D 0;
> -       noa =3D (void *)tlv->value;
>
>         /* Note: This is a nested TLV containing:
>          * [wmi_tlv][wmi_p2p_noa_descriptor][wmi_tlv]..

I would rather keep this one as it serves as documentation. Would
"(void) noa;" be enough satisfy the compiler?


Micha=C5=82
