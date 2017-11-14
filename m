Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:41204 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755554AbdKNS3E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 13:29:04 -0500
Subject: Re: [PATCH] ath10k: Fix invalid STS_CAP_OFFSET_MASK.
To: greearb@candelatech.com, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <1510679819-24115-1-git-send-email-greearb@candelatech.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <675ba2e5-ac50-0910-f499-8fe15b686de0@dd-wrt.com> (sfid-20171114_192918_663472_20A481C3)
Date: Tue, 14 Nov 2017 19:29:00 +0100
MIME-Version: 1.0
In-Reply-To: <1510679819-24115-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 14.11.2017 um 18:16 schrieb greearb@candelatech.com:
> From: Ben Greear <greearb@candelatech.com>
>
> The 10.4 firmware defines this as a 3-bit field, as does the
> mac80211 stack.  The 4th bit is defined as CONF_IMPLICIT_BF
> at least in the firmware header I have seen.  This patch
> fixes the ath10k wmi header to match the firmware.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>   drivers/net/wireless/ath/ath10k/wmi.h | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
> index ff15c37..9522f22 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.h
> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
> @@ -5195,7 +5195,8 @@ enum wmi_10_4_vdev_param {
>   #define WMI_VDEV_PARAM_TXBF_MU_TX_BFER BIT(3)
>   
>   #define WMI_TXBF_STS_CAP_OFFSET_LSB	4
> -#define WMI_TXBF_STS_CAP_OFFSET_MASK	0xf0
> +#define WMI_TXBF_STS_CAP_OFFSET_MASK	0x70
> +#define WMI_TXBF_CONF_IMPLICIT_BF       BIT(7)
>   #define WMI_BF_SOUND_DIM_OFFSET_LSB	8
>   #define WMI_BF_SOUND_DIM_OFFSET_MASK	0xf00
i can validate this. good finding
>   


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
