Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:41790 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbeBIQoV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Feb 2018 11:44:21 -0500
Subject: Re: [PATCH] rtlwifi: rtl8192cu: remove pointless memcpy
To: Arnd Bergmann <arnd@arndb.de>, Ping-Ke Shih <pkshih@realtek.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20180209132531.2755482-1-arnd@arndb.de>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <62048535-6455-e4ac-040a-ca2bf60fc0f7@lwfinger.net> (sfid-20180209_174511_426716_1137B0B1)
Date: Fri, 9 Feb 2018 10:44:19 -0600
MIME-Version: 1.0
In-Reply-To: <20180209132531.2755482-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2018 07:24 AM, Arnd Bergmann wrote:
> gcc-8 points out that source and destination of the memcpy() are
> always the same pointer, so the effect of memcpy() is undefined
> here (its arguments must not overlap):
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c: In function '_rtl_rx_process':
> drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c:430:2: error: 'memcpy' source argument is the same as destination [-Werror=restrict]
> 
> Most likely this is harmless, but it's easy to just remove the
> line and get rid of the warning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
> index ac4a82de40c7..9ab56827124e 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
> @@ -427,7 +427,6 @@ static void _rtl_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb)
>   		 (u32)hdr->addr1[0], (u32)hdr->addr1[1],
>   		 (u32)hdr->addr1[2], (u32)hdr->addr1[3],
>   		 (u32)hdr->addr1[4], (u32)hdr->addr1[5]);
> -	memcpy(IEEE80211_SKB_RXCB(skb), rx_status, sizeof(*rx_status));
>   	ieee80211_rx(hw, skb);
>   }

No, the warning is pointing to the wrong place. The routine in question does the 
following:

1. Loads the rx_status struct from skb->cb.
2. Overwrites the contents with 0.
3. Fills various members of the struct.
4. Writes the revised struct back into skb->cb.

Thus eliminating step 4 negates all the things done in step 3, and is wrong. The 
correct fix is to change step 1 to create a NULL-filled rx_status struct, and 
eliminate step 2.

NACK.

Larry
