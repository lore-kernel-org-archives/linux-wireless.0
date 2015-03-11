Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbbCKSXi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 14:23:38 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: Fix sparse warning cast to restricted __le16
References: <1426094490-17065-1-git-send-email-marcus.folkesson@gmail.com>
Date: Wed, 11 Mar 2015 14:23:29 -0400
In-Reply-To: <1426094490-17065-1-git-send-email-marcus.folkesson@gmail.com>
	(Marcus Folkesson's message of "Wed, 11 Mar 2015 18:21:30 +0100")
Message-ID: <wrfjsidb1jha.fsf@ultrasam.lan.trained-monkey.org> (sfid-20150311_192354_176754_55E3C15A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcus Folkesson <marcus.folkesson@gmail.com> writes:
> This patch fixes the following sparse warnings:
>
>   CHECK   drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
>   drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c:265:37: warning:
>   cast to restricted __le16
>   drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c:267:39: warning:
>   cast to restricted __le16
>
> Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
> ---
>  drivers/staging/rtl8723au/include/rtl8723a_hal.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/include/rtl8723a_hal.h b/drivers/staging/rtl8723au/include/rtl8723a_hal.h
> index e146336..f642b11 100644
> --- a/drivers/staging/rtl8723au/include/rtl8723a_hal.h
> +++ b/drivers/staging/rtl8723au/include/rtl8723a_hal.h
> @@ -255,10 +255,10 @@ struct hal_data_8723a {
>  	struct hal_version		VersionID;
>  	enum rt_customer_id CustomerID;
>  
> -	u16	FirmwareVersion;
> -	u16	FirmwareVersionRev;
> -	u16	FirmwareSubVersion;
> -	u16	FirmwareSignature;
> +	__le16	FirmwareVersion;
> +	__le16	FirmwareVersionRev;
> +	__le16	FirmwareSubVersion;
> +	__le16	FirmwareSignature;

Ehm I am pretty sure it doesn't:

rtl8723au_hal_init.c:265
        pHalData->FirmwareVersion = le16_to_cpu(pFwHdr->Version);
	pHalData->FirmwareSubVersion = pFwHdr->Subversion;
	pHalData->FirmwareSignature = le16_to_cpu(pFwHdr->Signature);

If anything, the second assignment there should be changed to use
le16_to_cpu(), but your conversion is definitely wrong.

NACK

Jes
