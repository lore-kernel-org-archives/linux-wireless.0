Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0158.hostedemail.com ([216.40.44.158]:49471 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752292AbeBIQYv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Feb 2018 11:24:51 -0500
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave08.hostedemail.com (Postfix) with ESMTP id 1C44B1802B41C
        for <linux-wireless@vger.kernel.org>; Fri,  9 Feb 2018 16:16:54 +0000 (UTC)
Message-ID: <1518193009.14014.6.camel@perches.com> (sfid-20180209_172458_561118_9554322B)
Subject: Re: [PATCH] rtlwifi: rtl8192cu: remove pointless memcpy
From: Joe Perches <joe@perches.com>
To: Arnd Bergmann <arnd@arndb.de>, Ping-Ke Shih <pkshih@realtek.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 09 Feb 2018 08:16:49 -0800
In-Reply-To: <20180209132531.2755482-1-arnd@arndb.de>
References: <20180209132531.2755482-1-arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-02-09 at 14:24 +0100, Arnd Bergmann wrote:
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
>  drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
> index ac4a82de40c7..9ab56827124e 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
> @@ -427,7 +427,6 @@ static void _rtl_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb)
>  		 (u32)hdr->addr1[0], (u32)hdr->addr1[1],
>  		 (u32)hdr->addr1[2], (u32)hdr->addr1[3],
>  		 (u32)hdr->addr1[4], (u32)hdr->addr1[5]);
> -	memcpy(IEEE80211_SKB_RXCB(skb), rx_status, sizeof(*rx_status));
>  	ieee80211_rx(hw, skb);
>  }

trivia:

The RT_TRACE above this should probably use %pM too.
Not submitted as it would just cause a conflict.

---

 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
index ac4a82de40c7..61da667ed8ba 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
@@ -422,11 +422,8 @@ static void _rtl_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (ieee80211_is_data(fc))
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "Got data frame\n");
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		 "Fram: fc = 0x%X addr1 = 0x%02X:0x%02X:0x%02X:0x%02X:0x%02X:0x%02X\n",
-		 fc,
-		 (u32)hdr->addr1[0], (u32)hdr->addr1[1],
-		 (u32)hdr->addr1[2], (u32)hdr->addr1[3],
-		 (u32)hdr->addr1[4], (u32)hdr->addr1[5]);
+		 "Fram: fc = 0x%X addr1 = %pM\n",
+		 fc, hdr->addr1);
 	memcpy(IEEE80211_SKB_RXCB(skb), rx_status, sizeof(*rx_status));
 	ieee80211_rx(hw, skb);
 }
