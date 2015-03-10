Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35376 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbbCJQCF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 12:02:05 -0400
Message-ID: <54FF157C.7090208@candelatech.com> (sfid-20150310_170209_317825_65BD2412)
Date: Tue, 10 Mar 2015 09:02:04 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: fix PMG by using AES-CMAC/IGTK software crypto
References: <1425994339-15864-1-git-send-email-bartosz.markowski@tieto.com>
In-Reply-To: <1425994339-15864-1-git-send-email-bartosz.markowski@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/10/2015 06:32 AM, Bartosz Markowski wrote:
> While testing with older supplicant, .drv_set_key() was failing due to
> higher than ath10k firmware could handle key_index (WMI_MAX_KEY_INDEX == 3).
> 
> --
> wpa_driver_nl80211_set_key: ifindex=15 alg=4 addr=0x7f02b129fbe3 key_idx=4 set_tx=0 seq_len=6 key_len=16
>     broadcast key
> nl80211: set_key failed; err=-22 Invalid argument)
> wlan0: WPA: Failed to configure IGTK to the driver
> wlan0: RSN: Failed to configure IGTK
> --
> 
> In order to fix this case (PMF: AES-CMAC/IGTK) force the AES_CMAC cipher to
> be handled by software.

How did you get firmware to allow the host to do the encryption?

Every time I've tried such a thing I end up with either nothing or garbage on
the air.

Or this this particular type of encryption treated differently by the
firmware?

Thanks,
Ben

> 
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 1138f4f8923f..5a3129010951 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -66,8 +66,8 @@ static int ath10k_send_key(struct ath10k_vif *arvif,
>  		arg.key_cipher = WMI_CIPHER_WEP;
>  		break;
>  	case WLAN_CIPHER_SUITE_AES_CMAC:
> -		/* this one needs to be done in software */
> -		return 1;
> +		WARN_ON(1);
> +		return -EINVAL;
>  	default:
>  		ath10k_warn(ar, "cipher %d is not supported\n", key->cipher);
>  		return -EOPNOTSUPP;
> @@ -3995,6 +3995,10 @@ static int ath10k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
>  	int ret = 0;
>  	u32 flags = 0;
>  
> +	/* this one needs to be done in software */
> +	if (key->cipher == WLAN_CIPHER_SUITE_AES_CMAC)
> +		return 1;
> +
>  	if (key->keyidx > WMI_MAX_KEY_INDEX)
>  		return -ENOSPC;
>  
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

