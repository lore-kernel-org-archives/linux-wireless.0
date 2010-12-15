Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61949 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab0LOEPo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 23:15:44 -0500
Received: by iwn9 with SMTP id 9so1567210iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 20:15:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1292375879-32085-1-git-send-email-vmehta@atheros.com>
References: <1292375879-32085-1-git-send-email-vmehta@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 14 Dec 2010 20:15:24 -0800
Message-ID: <AANLkTin_fw6aRc5Rs1_BTcapTE9kgPHy7_Gex9wRtkWy@mail.gmail.com>
Subject: Re: [PATCH] staging: ath6kl: Fixing device NULL pointer dereference
To: Vipin Mehta <vmehta@atheros.com>
Cc: greg@kroah.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 14, 2010 at 5:17 PM, Vipin Mehta <vmehta@atheros.com> wrote:
> Fixing the device instance being passed to set_wiphy_dev() from
> NULL to the one being returned by the MMC stack probe callback.
>
> Signed-off-by: Vipin Mehta <vmehta@atheros.com>
> ---
>  drivers/staging/ath6kl/os/linux/ar6000_drv.c |   19 ++++++++++++-------
>  1 files changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
> index a659f70..9f3e928 100644
> --- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
> +++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
> @@ -1608,6 +1608,15 @@ ar6000_avail_ev(void *context, void *hif_handle)
>     struct wireless_dev *wdev;
>  #endif /* ATH6K_CONFIG_CFG80211 */
>     A_STATUS init_status = A_OK;
> +    HIF_DEVICE_OS_DEVICE_INFO osDevInfo;
> +
> +    A_MEMZERO(&osDevInfo, sizeof(osDevInfo));
> +    if ( A_FAILED( HIFConfigureDevice(hif_handle, HIF_DEVICE_GET_OS_DEVICE,
> +                    &osDevInfo, sizeof(osDevInfo))) )

while you are adding new code, why not use the direct Linux calls?

  Luis
