Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:33618 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751740AbdBUJoa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 04:44:30 -0500
Received: by mail-qt0-f182.google.com with SMTP id b16so57167784qte.0
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2017 01:44:29 -0800 (PST)
Subject: Re: [PATCH] ath10k: Remove return statement from a void function
To: Marcin Rokicki <marcin.rokicki@tieto.com>,
        ath10k@lists.infradead.org
References: <1487667873-3493-1-git-send-email-marcin.rokicki@tieto.com>
Cc: linux-wireless@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <145513d5-e8d7-c7e4-810b-fc278cea3ace@broadcom.com> (sfid-20170221_104444_388404_325F2422)
Date: Tue, 21 Feb 2017 10:44:26 +0100
MIME-Version: 1.0
In-Reply-To: <1487667873-3493-1-git-send-email-marcin.rokicki@tieto.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 21-2-2017 10:04, Marcin Rokicki wrote:
> The empty 'return;' statement in a void function should be
> used to return from somewhere else then the end.
> 
> Signed-off-by: Marcin Rokicki <marcin.rokicki@tieto.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 59729aa..d65850e 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -2268,7 +2268,7 @@ static void ath10k_core_register_work(struct work_struct *work)
>  	status = ath10k_core_probe_fw(ar);
>  	if (status) {
>  		ath10k_err(ar, "could not probe fw (%d)\n", status);
> -		goto err;
> +		return;

The subject seems misleading as you add a return here. Also removing the
goto will break the desired behavior as expressed in the TODO below.

>  	}
>  
>  	status = ath10k_mac_register(ar);
> @@ -2307,11 +2307,10 @@ static void ath10k_core_register_work(struct work_struct *work)
>  	ath10k_mac_unregister(ar);
>  err_release_fw:
>  	ath10k_core_free_firmware_files(ar);
> -err:
> -	/* TODO: It's probably a good idea to release device from the driver
> -	 * but calling device_release_driver() here will cause a deadlock.
> -	 */
> -	return;

So to me removing this return statement and no more is sufficient for
this patch. Just leave the label and TODO comment in place or fix it
properly by scheduling a "release driver" work here or whatever is
needed to prevent the deadlock.

Regards,
Arend

> +
> +/* TODO: It's probably a good idea to release device from the driver
> + * but calling device_release_driver() here will cause a deadlock.
> + */
>  }
>  
>  int ath10k_core_register(struct ath10k *ar, u32 chip_id)
> 
