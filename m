Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:62416 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab3KOIjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 03:39:45 -0500
Received: by mail-ie0-f182.google.com with SMTP id e14so4351592iej.27
        for <linux-wireless@vger.kernel.org>; Fri, 15 Nov 2013 00:39:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1384461195-37185-1-git-send-email-nbd@openwrt.org>
References: <1384461195-37185-1-git-send-email-nbd@openwrt.org>
Date: Fri, 15 Nov 2013 09:39:45 +0100
Message-ID: <CAL1gcdORndm_fQ6G7uwWwuJfTyWrrHvxBA4WbDqwW8Nx7cJ0Jw@mail.gmail.com> (sfid-20131115_093949_616838_560D46A6)
Subject: Re: [PATCH] rt2x00: fix a crash bug in the HT descriptor handling fix
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 14, 2013 at 9:33 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> Commit "rt2x00: fix HT TX descriptor settings regression"
> assumes that the control parameter to rt2x00mac_tx is always non-NULL.
> There is an internal call in rt2x00lib_bc_buffer_iter where NULL is
> passed. Fix the resulting crash by adding an initialized dummy on-stack
> ieee80211_tx_control struct.
>
> Cc: stable@vger.kernel.org # 3.7+
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Good catch!

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 080b1fc..9dd92a7 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -181,6 +181,7 @@ static void rt2x00lib_autowakeup(struct work_struct *work)
>  static void rt2x00lib_bc_buffer_iter(void *data, u8 *mac,
>                                      struct ieee80211_vif *vif)
>  {
> +       struct ieee80211_tx_control control = {};
>         struct rt2x00_dev *rt2x00dev = data;
>         struct sk_buff *skb;
>
> @@ -195,7 +196,7 @@ static void rt2x00lib_bc_buffer_iter(void *data, u8 *mac,
>          */
>         skb = ieee80211_get_buffered_bc(rt2x00dev->hw, vif);
>         while (skb) {
> -               rt2x00mac_tx(rt2x00dev->hw, NULL, skb);
> +               rt2x00mac_tx(rt2x00dev->hw, &control, skb);
>                 skb = ieee80211_get_buffered_bc(rt2x00dev->hw, vif);
>         }
>  }
> --
> 1.8.3.4 (Apple Git-47)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
---
Gertjan
