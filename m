Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:45190 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbYF3KHm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 06:07:42 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1478799wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2008 03:07:39 -0700 (PDT)
Message-ID: <69e28c910806300307r26ad5258wd7208a4c9d20fcbf@mail.gmail.com> (sfid-20080630_120745_093808_AA22A795)
Date: Mon, 30 Jun 2008 12:07:39 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: [PATCH 30/33] iwlwifi: enable packet injection for iwl3945
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1214817813-17639-31-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
	 <1214817813-17639-23-git-send-email-yi.zhu@intel.com>
	 <1214817813-17639-24-git-send-email-yi.zhu@intel.com>
	 <1214817813-17639-25-git-send-email-yi.zhu@intel.com>
	 <1214817813-17639-26-git-send-email-yi.zhu@intel.com>
	 <1214817813-17639-27-git-send-email-yi.zhu@intel.com>
	 <1214817813-17639-28-git-send-email-yi.zhu@intel.com>
	 <1214817813-17639-29-git-send-email-yi.zhu@intel.com>
	 <1214817813-17639-30-git-send-email-yi.zhu@intel.com>
	 <1214817813-17639-31-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 30, 2008 at 11:23 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> From: Stefanik G=E1bor <netrolller.3d@gmail.com>
>
> This patch enables packet injection on iwl3945 devices. Tested with
> packetspammer and aireplay-ng.
>
> Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |   23 +++++++++--------=
------
>  1 files changed, 9 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/ne=
t/wireless/iwlwifi/iwl3945-base.c
> index 2744b0a..73942a4 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -2539,6 +2539,11 @@ static int iwl3945_get_sta_id(struct iwl3945_p=
riv *priv, struct ieee80211_hdr *h
>                iwl3945_print_hex_dump(IWL_DL_DROP, (u8 *) hdr, sizeof=
(*hdr));
>                return priv->hw_setting.bcast_sta_id;
>        }
> +       /* If we are in monitor mode, use BCAST. This is required for
> +        * packet injection. */
> +       case IEEE80211_IF_TYPE_MNTR:
> +               return priv->hw_setting.bcast_sta_id;
> +
>        default:
>                IWL_WARNING("Unknown mode of operation: %d", priv->iw_=
mode);
>                return priv->hw_setting.bcast_sta_id;
> @@ -2578,11 +2583,6 @@ static int iwl3945_tx_skb(struct iwl3945_priv =
*priv, struct sk_buff *skb)
>                goto drop_unlock;
>        }
>
> -       if (!priv->vif) {
> -               IWL_DEBUG_DROP("Dropping - !priv->vif\n");
> -               goto drop_unlock;
> -       }
> -
>        if ((ieee80211_get_tx_rate(priv->hw, info)->hw_value & 0xFF) =3D=
=3D IWL_INVALID_RATE) {
>                IWL_ERROR("ERROR: No TX rate available.\n");
>                goto drop_unlock;
> @@ -2603,9 +2603,10 @@ static int iwl3945_tx_skb(struct iwl3945_priv =
*priv, struct sk_buff *skb)
>  #endif
>
>        /* drop all data frame if we are not associated */
> -       if ((!iwl3945_is_associated(priv) ||
> -            ((priv->iw_mode =3D=3D IEEE80211_IF_TYPE_STA) && !priv->=
assoc_id)) &&
> -           ieee80211_is_data(fc)) {
> +       if (ieee80211_is_data(fc) &&
> +           (priv->iw_mode !=3D IEEE80211_IF_TYPE_MNTR) && /* packet =
injection */
> +           (!iwl3945_is_associated(priv) ||
> +            ((priv->iw_mode =3D=3D IEEE80211_IF_TYPE_STA) && !priv->=
assoc_id))) {
>                IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated\n");
>                goto drop_unlock;
>        }
> @@ -6693,12 +6694,6 @@ static int iwl3945_mac_tx(struct ieee80211_hw =
*hw, struct sk_buff *skb)
>
>        IWL_DEBUG_MAC80211("enter\n");
>
> -       if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) {
> -               IWL_DEBUG_MAC80211("leave - monitor\n");
> -               dev_kfree_skb_any(skb);
> -               return 0;
> -       }
> -
>        IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
>                     ieee80211_get_tx_rate(hw, IEEE80211_SKB_CB(skb))-=
>bitrate);
>
> --
> 1.5.3.6
>
>

Please submit the 4965 version too in the next round, I have multiple
reports of success with that patch.

--G=E1bor

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
