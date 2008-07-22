Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:7251 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbYGVLy3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 07:54:29 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2148782wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jul 2008 04:54:28 -0700 (PDT)
Message-ID: <69e28c910807220454q7c8371e1m11b1015ed8398758@mail.gmail.com> (sfid-20080722_135434_382638_40EA06C2)
Date: Tue, 22 Jul 2008 13:54:28 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] iwlwifi: Enable packet injection for iwl4965
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"Tomas Winkler" <tomasw@gmail.com>,
	"Tomas Winkler" <tomas.winkler@intel.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Marco Schuster" <marco@harddisk.is-a-geek.org>
In-Reply-To: <69e28c910807181205m6dd0cdcek83f9717bf1ac9dcc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <69e28c910807181205m6dd0cdcek83f9717bf1ac9dcc@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 18, 2008 at 9:05 PM, Stefanik G=E1bor <netrolller.3d@gmail.=
com> wrote:
> Handle station IDs of transmitted packets when in monitor mode, and
> remove the various anti-injection checks from the iwl4965 driver.
> This makes injection work on IWL4965 and hopefully IWL50xx. Tested on
> IWL4965 with aircrack-ng, IWL50xx not tested because I don't have
> access to an IWL50xx card.
>
> Note: To inject management frames with this patch, HW crypto support
> must be disabled using the "swcrypto=3D1" modparam (or "swcrypto50=3D=
1"
> for IWL50xx). Otherwise most management frames won't be transmitted.
>
> Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>
>
> ---
>
> Patch also available as an attachment on this e-mail, as Gmail tends
> to whitespace-damage patches.
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c
> b/drivers/net/wireless/iwlwifi/iwl-sta.c
> index 6d1467d..78b1315 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-sta.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
> @@ -968,6 +968,11 @@ int iwl_get_sta_id(struct iwl_priv *priv, struct
> ieee80211_hdr *hdr)
>                iwl_print_hex_dump(priv, IWL_DL_DROP, (u8 *) hdr, size=
of(*hdr));
>                return priv->hw_params.bcast_sta_id;
>
> +       /* If we are in monitor mode, use BCAST. This is required for
> +        * packet injection. */
> +       case IEEE80211_IF_TYPE_MNTR:
> +               return priv->hw_params.bcast_sta_id;
> +
>        default:
>                IWL_WARNING("Unknown mode of operation: %d", priv->iw_=
mode);
>                return priv->hw_params.bcast_sta_id;
> diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c
> b/drivers/net/wireless/iwlwifi/iwl-tx.c
> index 032641d..55149d4 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-tx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
> @@ -783,11 +783,6 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_=
buff *skb)
>                goto drop_unlock;
>        }
>
> -       if (!priv->vif) {
> -               IWL_DEBUG_DROP("Dropping - !priv->vif\n");
> -               goto drop_unlock;
> -       }
> -
>        if ((ieee80211_get_tx_rate(priv->hw, info)->hw_value & 0xFF) =3D=
=3D
>             IWL_INVALID_RATE) {
>                IWL_ERROR("ERROR: No TX rate available.\n");
> @@ -810,9 +805,11 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_=
buff *skb)
>
>        /* drop all data frame if we are not associated */
>        if (ieee80211_is_data(fc) &&
> -          (!iwl_is_associated(priv) ||
> -           ((priv->iw_mode =3D=3D IEEE80211_IF_TYPE_STA) && !priv->a=
ssoc_id) ||
> -           !priv->assoc_station_added)) {
> +           (priv->iw_mode !=3D IEEE80211_IF_TYPE_MNTR ||
> +           !(info->flags & IEEE80211_TX_CTL_INJECTED)) && /* packet =
injection */
> +           (!iwl_is_associated(priv) ||
> +            ((priv->iw_mode =3D=3D IEEE80211_IF_TYPE_STA) && !priv->=
assoc_id) ||
> +            !priv->assoc_station_added)) {
>                IWL_DEBUG_DROP("Dropping - !iwl_is_associated\n");
>                goto drop_unlock;
>        }
> @@ -822,7 +819,10 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_=
buff *skb)
>        hdr_len =3D ieee80211_get_hdrlen(le16_to_cpu(fc));
>
>        /* Find (or create) index into station table for destination s=
tation */
> -       sta_id =3D iwl_get_sta_id(priv, hdr);
> +       if (info->flags & IEEE80211_TX_CTL_INJECTED)
> +               sta_id =3D priv->hw_params.bcast_sta_id;
> +       else
> +               sta_id =3D iwl_get_sta_id(priv, hdr);
>        if (sta_id =3D=3D IWL_INVALID_STATION) {
>                DECLARE_MAC_BUF(mac);
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c
> b/drivers/net/wireless/iwlwifi/iwl4965-base.c
> index 60b7a64..380cc38 100644
> --- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
> @@ -2680,12 +2680,6 @@ static int iwl4965_mac_tx(struct ieee80211_hw
> *hw, struct sk_buff *skb)
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

What is the status of this patch? Did it get lost? Was it rejected? I
didn't get any answer on it, and I can't see it in iwlwifi-2.6.git or
wireless-testing.git.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
