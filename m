Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbcDTQG0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2016 12:06:26 -0400
Date: Wed, 20 Apr 2016 18:04:42 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, helmut.schaa@googlemail.com,
	kvalo@qca.qualcomm.com
Subject: Re: [PATCH] rt2800usb: enable MFP if hw crypt is disabled
Message-ID: <20160420160442.GA6803@redhat.com> (sfid-20160420_180630_504072_A067FEC5)
References: <1461135572-7468-1-git-send-email-yeohchunyeow@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1461135572-7468-1-git-send-email-yeohchunyeow@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 20, 2016 at 02:59:32PM +0800, Chun-Yeow Yeoh wrote:
> If rt2800usb is loaded with nohwcrypt=1, mac80211 takes
> care of the crypto with software encryption/decryption
> and thus, MFP can be used.
> 
> Tested for secured mesh using ath9k_htc and ath9k.
> 
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2800usb.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
> index 4b0bb6b..84ea329 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
> @@ -48,6 +48,7 @@ MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
> 
>  static bool rt2800usb_hwcrypt_disabled(struct rt2x00_dev *rt2x00dev)
>  {
> +	ieee80211_hw_set(rt2x00dev->hw, MFP_CAPABLE);
>  	return modparam_nohwcrypt;

You set MFP feature regardless if actually hwcrypt is disabled or not.
Beside this should not be done in function which is intended to test
if hw crypto is disabled. Please set the future in place where other
hw->flags are set.

Thanks
Stanislaw
