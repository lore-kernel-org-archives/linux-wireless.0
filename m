Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36917 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751010AbeBITKt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Feb 2018 14:10:49 -0500
Received: by mail-wm0-f65.google.com with SMTP id v71so18170977wmv.2
        for <linux-wireless@vger.kernel.org>; Fri, 09 Feb 2018 11:10:48 -0800 (PST)
Subject: Re: [PATCH] mac80211: round IEEE80211_TX_STATUS_HEADROOM up to
 multiple of 4
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
References: <20180209185100.22511-1-nbd@nbd.name>
Cc: johannes@sipsolutions.net
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A7DF237.9020803@broadcom.com> (sfid-20180209_201053_742425_D77BE3B4)
Date: Fri, 9 Feb 2018 20:10:47 +0100
MIME-Version: 1.0
In-Reply-To: <20180209185100.22511-1-nbd@nbd.name>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/9/2018 7:51 PM, Felix Fietkau wrote:
> This ensures that mac80211 allocated management frames are properly
> aligned, which makes copying them more efficient.
> For instance, mt76 uses iowrite32_copy to copy beacon frames to beacon
> template memory on the chip.
> Misaligned 32-bit accesses cause CPU exceptions on MIPS and should be
> avoided.
>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>   include/net/mac80211.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 906e90223066..d999b8c8a44b 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -4149,7 +4149,7 @@ void ieee80211_sta_uapsd_trigger(struct ieee80211_sta *sta, u8 tid);
>    * The TX headroom reserved by mac80211 for its own tx_status functions.
>    * This is enough for the radiotap header.

Hi Felix,

Maybe useful to mention the alignment requirement in this comment block.

>    */
> -#define IEEE80211_TX_STATUS_HEADROOM	14
> +#define IEEE80211_TX_STATUS_HEADROOM	16

Regards,
Arend
