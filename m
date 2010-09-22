Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-mx09.nokia.com ([192.100.105.134]:43816 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab0IVKZm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 06:25:42 -0400
Subject: Re: [PATCH] wl1271: Fix overflow in wl1271_boot_upload_nvs
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Ido Yariv <ido@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1285141993-3772-1-git-send-email-ido@wizery.com>
References: <1285141993-3772-1-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 13:24:42 +0300
Message-ID: <1285151082.22517.8.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-22 at 09:53 +0200, ext Ido Yariv wrote:
> Due to miscalculation of nvs_len, excessive data was sent to the
> firmware.
> Fix this by first setting nvs_ptr to point to the first NVS table,
> and computing the total size of all NVS tables accordingly.
> 
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---

This looks reasonable, thanks!

But I still want to have it briefly tested before I accept it.  Our
tester will try it out today or tomorrow and, if everything is okay,
I'll ack it.


>  drivers/net/wireless/wl12xx/wl1271_boot.c |   17 ++++++-----------
>  1 files changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
> index fc21db8..e5a7f04 100644
> --- a/drivers/net/wireless/wl12xx/wl1271_boot.c
> +++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
> @@ -274,11 +274,11 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)

[...]

> -	nvs_aligned = kmemdup(nvs_ptr, nvs_len, GFP_KERNEL); if
> -	(!nvs_aligned) return -ENOMEM;
> +	nvs_aligned = kmemdup(nvs_ptr, nvs_len, GFP_KERNEL);
> +	if (!nvs_aligned)
> +		return -ENOMEM;

This looks pretty odd.  But I checked wireless-testing and it is looking
bad there.  It's not like that in our internal tree, but git blames me
for doing it in wireless-testing. :) Thanks for fixing.

-- 
Cheers,
Luca.

