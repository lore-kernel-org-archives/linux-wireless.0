Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51348 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755817Ab0KJMrd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 07:47:33 -0500
Message-ID: <4CDA9463.2090003@openwrt.org>
Date: Wed, 10 Nov 2010 13:47:31 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Vivek Natarajan <vnatarajan@atheros.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/5] ath: Add a keycache entry if beamforming is enabled.
References: <1289391829-8577-1-git-send-email-vnatarajan@atheros.com> <1289391829-8577-2-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1289391829-8577-2-git-send-email-vnatarajan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-10 1:23 PM, Vivek Natarajan wrote:
> Keycache entry for a sta has the details of the negotiated
> beamforming parameters which is to be used by the hardware
> while trasmitting to that specific sta.
> 
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath.h |    2 ++
>  drivers/net/wireless/ath/key.c |   29 +++++++++++++++++++++++++++++
>  2 files changed, 31 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
> index 62e3dac..11f562e 100644
> --- a/drivers/net/wireless/ath/key.c
> +++ b/drivers/net/wireless/ath/key.c
> @@ -115,6 +115,7 @@ static bool ath_hw_set_keycache_entry(struct ath_common *common, u16 entry,
>  	void *ah = common->ah;
>  	u32 key0, key1, key2, key3, key4;
>  	u32 keyType;
> +	u32 txbf = 0;
>  
>  	if (entry >= common->keymax) {
>  		ath_print(common, ATH_DBG_FATAL,
> @@ -199,6 +200,9 @@ static bool ath_hw_set_keycache_entry(struct ath_common *common, u16 entry,
>  		REG_WRITE(ah, AR_KEYTABLE_KEY4(entry), key4);
>  		REG_WRITE(ah, AR_KEYTABLE_TYPE(entry), keyType);
>  
> +		REG_WRITE(ah, AR_KEYTABLE_TYPE(entry),
> +				keyType | txbf);
> +
>  		/* Write MAC address for the entry */
>  		(void) ath_hw_keysetmac(common, entry, mac);
>  
What's the point of this change, if txbf is always zero?
And why duplicate the REG_WRITE?

- Felix
