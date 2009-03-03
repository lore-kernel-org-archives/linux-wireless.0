Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:31636 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbZCCA5Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 19:57:24 -0500
Received: by wf-out-1314.google.com with SMTP id 28so2997706wfa.4
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2009 16:57:22 -0800 (PST)
Subject: Re: [PATCH] ath9k: Remove unused key xoring
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090302130728.GB30293@jm.kir.nu>
References: <20090302130728.GB30293@jm.kir.nu>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 16:57:20 -0800
Message-Id: <1236041840.5756.34.camel@brick> (sfid-20090303_015728_031453_05BF2552)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-03-02 at 15:07 +0200, Jouni Malinen wrote:
> This is not used anywhere in ath9k and is just making the code more
> confusing.
> 
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
> 
> ---
>  drivers/net/wireless/ath9k/hw.c   |   15 ++++++---------
>  drivers/net/wireless/ath9k/hw.h   |    2 +-
>  drivers/net/wireless/ath9k/main.c |    2 +-
>  drivers/net/wireless/ath9k/phy.h  |    2 --
>  4 files changed, 8 insertions(+), 13 deletions(-)
> 
> --- wireless-testing.orig/drivers/net/wireless/ath9k/hw.c	2009-03-02 14:23:07.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/ath9k/hw.c	2009-03-02 14:23:09.000000000 +0200
> @@ -2415,14 +2415,11 @@ bool ath9k_hw_keysetmac(struct ath_hw *a
>  
>  bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
>  				 const struct ath9k_keyval *k,
> -				 const u8 *mac, int xorKey)
> +				 const u8 *mac)
>  {
>  	const struct ath9k_hw_capabilities *pCap = &ah->caps;
>  	u32 key0, key1, key2, key3, key4;
>  	u32 keyType;
> -	u32 xorMask = xorKey ?
> -		(ATH9K_KEY_XOR << 24 | ATH9K_KEY_XOR << 16 | ATH9K_KEY_XOR << 8
> -		 | ATH9K_KEY_XOR) : 0;
>  
>  	if (entry >= pCap->keycache_size) {
>  		DPRINTF(ah->ah_sc, ATH_DBG_KEYCACHE,
> @@ -2474,11 +2471,11 @@ bool ath9k_hw_set_keycache_entry(struct 
>  		return false;
>  	}
>  
> -	key0 = get_unaligned_le32(k->kv_val + 0) ^ xorMask;
> -	key1 = (get_unaligned_le16(k->kv_val + 4) ^ xorMask) & 0xffff;
> -	key2 = get_unaligned_le32(k->kv_val + 6) ^ xorMask;
> -	key3 = (get_unaligned_le16(k->kv_val + 10) ^ xorMask) & 0xffff;
> -	key4 = get_unaligned_le32(k->kv_val + 12) ^ xorMask;
> +	key0 = get_unaligned_le32(k->kv_val + 0);
> +	key1 = get_unaligned_le16(k->kv_val + 4);
> +	key2 = get_unaligned_le32(k->kv_val + 6);
> +	key3 = get_unaligned_le16(k->kv_val + 10) & 0xffff;
> +	key4 = get_unaligned_le32(k->kv_val + 12);

No longer need the 0xffff here

Harvey

