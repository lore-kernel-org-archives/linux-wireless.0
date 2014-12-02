Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:33013 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaLBG6L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 01:58:11 -0500
Received: by mail-wg0-f53.google.com with SMTP id l18so15906233wgh.26
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2014 22:58:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141201144458.18248.28568.stgit@potku.adurom.net>
References: <20141201144400.18248.62714.stgit@potku.adurom.net>
	<20141201144458.18248.28568.stgit@potku.adurom.net>
Date: Tue, 2 Dec 2014 07:58:09 +0100
Message-ID: <CA+BoTQkrqeWcr2vrd-b18HezZhyBkfvOYE3SgF39oYu54BX-Fw@mail.gmail.com> (sfid-20141202_075814_731735_9E08D1B4)
Subject: Re: [PATCH v3 1/7] ath10k: create ath10k_core_init_features()
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 December 2014 at 15:44, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
[...]
>  int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
> @@ -1046,7 +1047,12 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
>                 return ret;
>         }
>
> -       ath10k_core_init_max_sta_count(ar);
> +       ret = ath10k_core_init_firmware_features(ar);
> +       if (ret) {
> +               ath10k_err(ar, "fatal problem with firmware features: %d\n",
> +                          ret);
> +               return ret;

I think you should call ath10k_core_free_firmware_files() and
ath10k_hif_power_down() before returning (similar to how
ath10k_core_start() failure is handled).


Michał
