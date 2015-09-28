Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36490 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297AbbI1LYH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 07:24:07 -0400
Date: Mon, 28 Sep 2015 16:53:46 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>
Cc: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: Fix resource leak
Message-ID: <20150928112346.GB10335@sudip-pc> (sfid-20150928_132425_264132_3ED7A31F)
References: <1443382254-7358-1-git-send-email-mateusz.kulikowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443382254-7358-1-git-send-email-mateusz.kulikowski@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 27, 2015 at 09:30:54PM +0200, Mateusz Kulikowski wrote:
> Firmware was not released properly if kmemdup fails.
> 
> Addresses-Coverity-Id: 1269118
> Signed-off-by: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>
> ---
>  drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
> index cd014f7..87bb87f 100644
> --- a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
> +++ b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
> @@ -249,13 +249,13 @@ int rtl8723a_FirmwareDownload(struct rtw_adapter *padapter)
>  		goto Exit;
>  	}
>  	firmware_buf = kmemdup(fw->data, fw->size, GFP_KERNEL);
> +	release_firmware(fw);
>  	if (!firmware_buf) {
>  		rtStatus = _FAIL;
>  		goto Exit;
>  	}
>  	buf = firmware_buf;
>  	fw_size = fw->size;
> -	release_firmware(fw);
You are releasing the firmware and then accessing fw->size here. That
just introduced a NULL pointer dereference.

regards
sudip
