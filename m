Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbaHMPmZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2014 11:42:25 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Raphael Silva <rapphil@gmail.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8723au:type casting corrections
References: <1407897034-28134-1-git-send-email-rapphil@gmail.com>
Date: Wed, 13 Aug 2014 17:42:20 +0200
In-Reply-To: <1407897034-28134-1-git-send-email-rapphil@gmail.com> (Raphael
	Silva's message of "Tue, 12 Aug 2014 23:30:34 -0300")
Message-ID: <wrfj7g2cgzvn.fsf@redhat.com> (sfid-20140813_174230_868741_3C8A1A5F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Raphael Silva <rapphil@gmail.com> writes:
>  Type casting corrections in order to solve warnings of the sparce static analyser.
>
> Signed-off-by: Raphael Silva <rapphil@gmail.com>
> ---
>  drivers/staging/rtl8723au/hal/usb_halinit.c       | 4 ++--
>  drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)

In the future, staging patches must have 'staging: rtl8723au: ....' in
the subject, and you need to CC devel@driverdev.osuosl.org as well.

Cheers,
Jes


>
> diff --git a/drivers/staging/rtl8723au/hal/usb_halinit.c b/drivers/staging/rtl8723au/hal/usb_halinit.c
> index b49bf33..969e4f3 100644
> --- a/drivers/staging/rtl8723au/hal/usb_halinit.c
> +++ b/drivers/staging/rtl8723au/hal/usb_halinit.c
> @@ -1228,9 +1228,9 @@ static void Hal_EfuseParsePIDVID_8723AU(struct rtw_adapter *pAdapter,
>  	} else {
>  		/*  VID, PID */
>  		pHalData->EEPROMVID =
> -			le16_to_cpu(*(u16 *)&hwinfo[EEPROM_VID_8723AU]);
> +			le16_to_cpu(*(__le16 *)&hwinfo[EEPROM_VID_8723AU]);
>  		pHalData->EEPROMPID =
> -			le16_to_cpu(*(u16 *)&hwinfo[EEPROM_PID_8723AU]);
> +			le16_to_cpu(*(__le16 *)&hwinfo[EEPROM_PID_8723AU]);
>  	}
>  
>  	MSG_8723A("EEPROM VID = 0x%4x\n", pHalData->EEPROMVID);
