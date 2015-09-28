Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933839AbbI1SXX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 14:23:23 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: rtl8723au: Fix resource leak
References: <1443383299-2634-1-git-send-email-mateusz.kulikowski@gmail.com>
Date: Mon, 28 Sep 2015 14:23:19 -0400
In-Reply-To: <1443383299-2634-1-git-send-email-mateusz.kulikowski@gmail.com>
	(Mateusz Kulikowski's message of "Sun, 27 Sep 2015 21:48:19 +0200")
Message-ID: <wrfjr3limmi0.fsf@redhat.com> (sfid-20150928_202346_502820_C26FF084)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mateusz Kulikowski <mateusz.kulikowski@gmail.com> writes:
> Firmware was not released properly if kmemdup fails.
>
> Addresses-Coverity-Id: 1269118
> Signed-off-by: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>
> ---
>  drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>

>
> diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
> index cd014f7..ecf54ee 100644
> --- a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
> +++ b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
> @@ -249,13 +249,13 @@ int rtl8723a_FirmwareDownload(struct rtw_adapter *padapter)
>  		goto Exit;
>  	}
>  	firmware_buf = kmemdup(fw->data, fw->size, GFP_KERNEL);
> +	fw_size = fw->size;
> +	release_firmware(fw);
>  	if (!firmware_buf) {
>  		rtStatus = _FAIL;
>  		goto Exit;
>  	}
>  	buf = firmware_buf;
> -	fw_size = fw->size;
> -	release_firmware(fw);
>  
>  	/*  To Check Fw header. Added by tynli. 2009.12.04. */
>  	pFwHdr = (struct rt_8723a_firmware_hdr *)firmware_buf;
