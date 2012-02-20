Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43515 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab2BTV0e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Feb 2012 16:26:34 -0500
Received: by iacb35 with SMTP id b35so7994367iac.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Feb 2012 13:26:34 -0800 (PST)
Message-ID: <4F42BA87.9080005@lwfinger.net> (sfid-20120220_222638_796926_BC1E9999)
Date: Mon, 20 Feb 2012 15:26:31 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arend van Spriel <arend@arend-vb-linux>
CC: linux-wireless@vger.kernel.org,
	Arend van Spriel <arend@broadcom.com>,
	Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC] brcm80211: smac: remove firmware requests from init_module
 syscall
References: <1329770668-6484-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1329770668-6484-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/20/2012 02:44 PM, Arend van Spriel wrote:
> As indicated in [1] on netdev mailing list drivers should not block
> on the init_module() syscall. This patch defers the actual driver
> registration to a workqueue so the init_module() syscall can complete
> without delay.
>
> [1] http://article.gmane.org/gmane.linux.network/217729/
>
> Cc: Kay Sievers<kay.sievers@vrfy.org>
> Cc: Larry Finger<Larry.Finger@lwfinger.net>
> Signed-off-by: Arend van Spriel<arend@broadcom.com>
> ---
> Here is the patch I came up with to avoid udev blocking on init_module().
> It is pretty straightforward, but maybe I am overlooking things here. So
> feel free to comment.
>
> Gr. AvS

Arend,

Despite the simplicity, this patch looks right to me. As a side benefit, I 
learned about the DECLARE_WORK macro. Handy for this purpose.

Larry

> ---
>   .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   17 ++++++++++-------
>   1 files changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> index fec0f10..fe73451 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> @@ -1173,21 +1173,24 @@ static struct bcma_driver brcms_bcma_driver = {
>    * and if so, performs a brcms_attach() on it.
>    *
>    */
> -static int __init brcms_module_init(void)
> +static void brcms_driver_init(struct work_struct *work)
>   {
>   	int error = -ENODEV;
>
> +	error = bcma_driver_register(&brcms_bcma_driver);
> +	pr_err("%s: register returned %d\n", __func__, error);
> +}
> +
> +DECLARE_WORK(brcms_driver_work, brcms_driver_init);
> +
> +static int __init brcms_module_init(void)
> +{
>   #ifdef DEBUG
>   	if (msglevel != 0xdeadbeef)
>   		brcm_msg_level = msglevel;
>   #endif				/* DEBUG */
>
> -	error = bcma_driver_register(&brcms_bcma_driver);
> -	pr_err("%s: register returned %d\n", __func__, error);
> -	if (!error)
> -		return 0;
> -
> -	return error;
> +	return schedule_work(&brcms_driver_work);
>   }
>
>   /**

