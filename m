Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53204 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbaDXIoY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 04:44:24 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so677631wiv.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Apr 2014 01:44:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1398327250-12923-1-git-send-email-yeohchunyeow@gmail.com>
References: <1398327250-12923-1-git-send-email-yeohchunyeow@gmail.com>
Date: Thu, 24 Apr 2014 10:44:22 +0200
Message-ID: <CA+BoTQkBCGyKYDaOMgdCi4Yw+SXeuRS+t0rGE8o=8+x2q5N74w@mail.gmail.com> (sfid-20140424_104431_792919_3603D338)
Subject: Re: [PATCH] ath10k: don't allow stand alone monitor mode for non-AP firmware
From: Michal Kazior <michal.kazior@tieto.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 April 2014 10:14, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
> Firmware 999.999.0.636 does not allow stand alone monitor
> mode. This means that bridging the STA mode and put it into
> promiscuous mode will also cause the firmware to crash. Avoid
> this.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index e2c01dc..f640328 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -647,10 +647,15 @@ static int ath10k_monitor_vdev_delete(struct ath10k *ar)
>
>  static int ath10k_monitor_start(struct ath10k *ar)
>  {
> -       int ret;
> +       int ret = -1;
>
>         lockdep_assert_held(&ar->conf_mutex);
>
> +       if (ar->fw_version_build == 636) {
> +               ath10k_warn("stand alone monitor mode is not supported\n");
> +               return ret;
> +       }

I think Monitor operation should be performed on a best effort basis.
This means monitor_start/stop should be attempted once number of
non-monitor vdevs changes.

We should probably introduce a ath10k_recalc_monitor() for that purpose.


Michał
