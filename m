Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:33077 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbcDKBkL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2016 21:40:11 -0400
MIME-Version: 1.0
In-Reply-To: <1460287531-17385-1-git-send-email-colin.king@canonical.com>
References: <1460287531-17385-1-git-send-email-colin.king@canonical.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 11 Apr 2016 11:39:50 +1000
Message-ID: <CAGRGNgVgd-_wcvdJz-yh_ugQeJidMK1B8=NuSec1wjn__6AFwA@mail.gmail.com> (sfid-20160411_034058_741709_67599C4B)
Subject: Re: [PATCH] ath9k: remove duplicate assignment of variable ah
To: Colin King <colin.king@canonical.com>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org, netdev <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

On Sun, Apr 10, 2016 at 9:25 PM, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> ah is written twice with the same value, remove one of the
> redundant assignments to ah.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Looks right to me.

Signed-off-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

> ---
>  drivers/net/wireless/ath/ath9k/init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
> index 77ace8d..fb702c4 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -477,7 +477,7 @@ static void ath9k_eeprom_request_cb(const struct firmware *eeprom_blob,
>  static int ath9k_eeprom_request(struct ath_softc *sc, const char *name)
>  {
>         struct ath9k_eeprom_ctx ec;
> -       struct ath_hw *ah = ah = sc->sc_ah;
> +       struct ath_hw *ah = sc->sc_ah;
>         int err;
>
>         /* try to load the EEPROM content asynchronously */
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
