Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:2054 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbYF3KWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 06:22:45 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1483996wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2008 03:22:45 -0700 (PDT)
Message-ID: <69e28c910806300322i5ac6e123h23ed5c0419d087c1@mail.gmail.com> (sfid-20080630_122249_095634_8EEAD4BA)
Date: Mon, 30 Jun 2008 12:22:45 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: [PATCH 29/33] iwlwifi: drop skb silently for Tx request in monitor mode
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1214817813-17639-30-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
	 <1214817813-17639-22-git-send-email-yi.zhu@intel.com>
	 <1214817813-17639-23-git-send-email-yi.zhu@intel.com>
	 <1214817813-17639-24-git-send-email-yi.zhu@intel.com>
	 <1214817813-17639-25-git-send-email-yi.zhu@intel.com>
	 <1214817813-17639-26-git-send-email-yi.zhu@intel.com>
	 <1214817813-17639-27-git-send-email-yi.zhu@intel.com>
	 <1214817813-17639-28-git-send-email-yi.zhu@intel.com>
	 <1214817813-17639-29-git-send-email-yi.zhu@intel.com>
	 <1214817813-17639-30-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 30, 2008 at 11:23 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> This patch fixes the problem to keep mac80211 resubmitting SKBs
> when Tx request cannot be met in monitor mode.
>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ++-
>  drivers/net/wireless/iwlwifi/iwl4965-base.c |    3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index 4f0a18a..2744b0a 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -6695,7 +6695,8 @@ static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>
>        if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
>                IWL_DEBUG_MAC80211("leave - monitor\n");
> -               return -1;
> +               dev_kfree_skb_any(skb);
> +               return 0;
>        }
>
>        IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
> diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
> index ba0f289..60b7a64 100644
> --- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
> @@ -2682,7 +2682,8 @@ static int iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>
>        if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
>                IWL_DEBUG_MAC80211("leave - monitor\n");
> -               return -1;
> +               dev_kfree_skb_any(skb);
> +               return 0;
>        }
>
>        IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
> --
> 1.5.3.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

NACK.

This blocks packet injection for not only 4965/5000, but also 3945.
Also, I have multiple records of injection working with 4965 cards
with your original patch.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
