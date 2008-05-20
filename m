Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:24054 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935515AbYETWpo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 18:45:44 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2604807waf.23
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2008 15:45:43 -0700 (PDT)
Message-ID: <1ba2fa240805201545q4084f0f3ge2c01d9537beec85@mail.gmail.com> (sfid-20080521_004758_248946_7F826B89)
Date: Wed, 21 May 2008 01:45:42 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: [PATCH] iwlwifi: Fix packet injection in iwl3945 and iwl4965
Cc: "John Linville" <linville@tuxdriver.com>,
	"Zhu Yi" <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Andy Green" <andy@warmcat.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <69e28c910805201526v233cf05brfb3fac060a28c33b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <69e28c910805201001r78d13ec5v4c7cf933edd39c10@mail.gmail.com>
	 <1ba2fa240805201441u2182071en5d557bb8f5f28504@mail.gmail.com>
	 <69e28c910805201451r3cab72bbwe9600008c9cc105d@mail.gmail.com>
	 <1ba2fa240805201518h78f9825fw389d0afd42f0130b@mail.gmail.com>
	 <69e28c910805201526v233cf05brfb3fac060a28c33b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 21, 2008 at 1:26 AM, Stefanik G=E1bor <netrolller.3d@gmail.=
com> wrote:
> On Tue, May 20, 2008 at 6:18 PM, Tomas Winkler <tomasw@gmail.com> wro=
te:
>> On Wed, May 21, 2008 at 12:51 AM, Stefanik G=E1bor
>> <netrolller.3d@gmail.com> wrote:
>>> On Tue, May 20, 2008 at 5:41 PM, Tomas Winkler <tomasw@gmail.com> w=
rote:
>>>>
>>>> This is certainly no go for 4965. Station must be present in uCode
>>>> table. Maybe this work for monitor mode but there is a race in reg=
ular
>>>> cases, when sta_id !=3D broadcast id at least priv->assoc_station_=
added
>>>> =3D=3D 1 has to be true. Have you tested it with 4965 ?
>>>>
>>>> I suggest to proceed with 3945 part only of this patch.
>>>>
>>>> Tomas
>>>
>>> Which change does this comment apply to? The "IWL_DEBUG_DROP("Dropp=
ing
>>> - !priv->vif\n");" one? Or the "drop all data frame if we are not
>>> associated" one? Also, doesn't the "if (sta_id =3D=3D
>>> IWL_INVALID_STATION)" part protect against such cases? Also, what
>>> happens if we simply pass broadcast in such a case?
>>>
>> The station can be in driver data structure but it's not guaranties
>> it's also in the uCode. It will
>> return correct station id but the table in uCode will be empty.
>> Retuning to new channel clears the station table in the uCode so it
>> must to be reapplied also you must have applied rate command (LQ).
>> Simply currently there is a window big enough for a race. It can be
>> solved but there is more coding than this patch.
>>
>> Thanks
>> Tomas
>>> --
>>> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :=
-)
>>>
>>
>
> Hmm... wouldn't this patch fix the issue? It limits the condition lis=
t
> of dropping data packets to just !priv->assoc_station_added. I don't
> know if iwl4965 injection still works with this patch though, but I
> suspect it does.
>
> ---
>
> diff -rp -U 8 compat-wireless-2008-05-20.orig/drivers/net/wireless/iw=
lwifi/iwl3945-base.c
> compat-wireless-2008-05-20/drivers/net/wireless/iwlwifi/iwl3945-base.=
c
> --- compat-wireless-2008-05-20.orig/drivers/net/wireless/iwlwifi/iwl3=
945-base.c 2008-05-20
> 05:05:29.000000000 -0400
> +++ compat-wireless-2008-05-20/drivers/net/wireless/iwlwifi/iwl3945-b=
ase.c      2008-05-20
> 11:31:15.513173847 -0400
> @@ -2542,16 +2542,19 @@ static int iwl3945_get_sta_id(struct iwl
>                        return sta_id;
>
>                IWL_DEBUG_DROP("Station %s not in station map. "
>                               "Defaulting to broadcast...\n",
>                               print_mac(mac, hdr->addr1));
>                iwl3945_print_hex_dump(IWL_DL_DROP, (u8 *) hdr, sizeof=
(*hdr));
>                return priv->hw_setting.bcast_sta_id;
>        }
> +       /* If we are in monitor mode, use BCAST */
> +       case IEEE80211_IF_TYPE_MNTR:
> +               return priv->hw_setting.bcast_sta_id;
>        default:
>                IWL_WARNING("Unknown mode of operation: %d", priv->iw_=
mode);
>                return priv->hw_setting.bcast_sta_id;
>        }
>  }
>
>  /*
>  * start REPLY_TX command process
> @@ -2579,21 +2582,16 @@ static int iwl3945_tx_skb(struct iwl3945
>        int rc;
>
>        spin_lock_irqsave(&priv->lock, flags);
>        if (iwl3945_is_rfkill(priv)) {
>                IWL_DEBUG_DROP("Dropping - RF KILL\n");
>                goto drop_unlock;
>        }
>
> -       if (!priv->vif) {
> -               IWL_DEBUG_DROP("Dropping - !priv->vif\n");
> -               goto drop_unlock;
> -       }
> -
>        if ((ctl->tx_rate->hw_value & 0xFF) =3D=3D IWL_INVALID_RATE) {
>                IWL_ERROR("ERROR: No TX rate available.\n");
>                goto drop_unlock;
>        }
>
>        unicast =3D !is_multicast_ether_addr(hdr->addr1);
>        id =3D 0;
>
> @@ -2603,24 +2601,16 @@ static int iwl3945_tx_skb(struct iwl3945
>        if (ieee80211_is_auth(fc))
>                IWL_DEBUG_TX("Sending AUTH frame\n");
>        else if (ieee80211_is_assoc_request(fc))
>                IWL_DEBUG_TX("Sending ASSOC frame\n");
>        else if (ieee80211_is_reassoc_request(fc))
>                IWL_DEBUG_TX("Sending REASSOC frame\n");
>  #endif
>
> -       /* drop all data frame if we are not associated */
> -       if ((!iwl3945_is_associated(priv) ||
> -            ((priv->iw_mode =3D=3D IEEE80211_IF_TYPE_STA) && !priv->=
assoc_id)) &&
> -           ((fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DATA)=
) {
> -               IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated\n")=
;
> -               goto drop_unlock;
> -       }
> -
>        spin_unlock_irqrestore(&priv->lock, flags);
>
>        hdr_len =3D ieee80211_get_hdrlen(fc);
>
>        /* Find (or create) index into station table for destination s=
tation */
>        sta_id =3D iwl3945_get_sta_id(priv, hdr);
>        if (sta_id =3D=3D IWL_INVALID_STATION) {
>                DECLARE_MAC_BUF(mac);
> @@ -6692,21 +6682,16 @@ static void iwl3945_mac_stop(struct ieee
>
>  static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *s=
kb,
>                      struct ieee80211_tx_control *ctl)
>  {
>        struct iwl3945_priv *priv =3D hw->priv;
>
>        IWL_DEBUG_MAC80211("enter\n");
>
> -       if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) {
> -               IWL_DEBUG_MAC80211("leave - monitor\n");
> -               return -1;
> -       }
> -
>        IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
>                     ctl->tx_rate->bitrate);
>
>        if (iwl3945_tx_skb(priv, skb, ctl))
>                dev_kfree_skb_any(skb);
>
>        IWL_DEBUG_MAC80211("leave\n");
>        return 0;
> diff -rp -U 8 compat-wireless-2008-05-20.orig/drivers/net/wireless/iw=
lwifi/iwl4965-base.c
> compat-wireless-2008-05-20/drivers/net/wireless/iwlwifi/iwl4965-base.=
c
> --- compat-wireless-2008-05-20.orig/drivers/net/wireless/iwlwifi/iwl4=
965-base.c 2008-05-20
> 05:05:29.000000000 -0400
> +++ compat-wireless-2008-05-20/drivers/net/wireless/iwlwifi/iwl4965-b=
ase.c      2008-05-20
> 18:18:58.399897940 -0400
> @@ -1746,16 +1746,19 @@ static int iwl4965_get_sta_id(struct iwl
>                        return sta_id;
>
>                IWL_DEBUG_DROP("Station %s not in station map. "
>                               "Defaulting to broadcast...\n",
>                               print_mac(mac, hdr->addr1));
>                iwl_print_hex_dump(priv, IWL_DL_DROP, (u8 *) hdr, size=
of(*hdr));
>                return priv->hw_params.bcast_sta_id;
>
> +       /* If we are in monitor mode, use BCAST */
> +       case IEEE80211_IF_TYPE_MNTR:
> +               return priv->hw_params.bcast_sta_id;
>        default:
>                IWL_WARNING("Unknown mode of operation: %d", priv->iw_=
mode);
>                return priv->hw_params.bcast_sta_id;
>        }
>  }
>
>  /*
>  * start REPLY_TX command process
> @@ -1784,21 +1787,16 @@ static int iwl4965_tx_skb(struct iwl_pri
>        int rc;
>
>        spin_lock_irqsave(&priv->lock, flags);
>        if (iwl_is_rfkill(priv)) {
>                IWL_DEBUG_DROP("Dropping - RF KILL\n");
>                goto drop_unlock;
>        }
>
> -       if (!priv->vif) {
> -               IWL_DEBUG_DROP("Dropping - !priv->vif\n");
> -               goto drop_unlock;
> -       }
> -
>        if ((ctl->tx_rate->hw_value & 0xFF) =3D=3D IWL_INVALID_RATE) {
>                IWL_ERROR("ERROR: No TX rate available.\n");
>                goto drop_unlock;
>        }
>
>        unicast =3D !is_multicast_ether_addr(hdr->addr1);
>        id =3D 0;
>
> @@ -1808,22 +1806,20 @@ static int iwl4965_tx_skb(struct iwl_pri
>        if (ieee80211_is_auth(fc))
>                IWL_DEBUG_TX("Sending AUTH frame\n");
>        else if (ieee80211_is_assoc_request(fc))
>                IWL_DEBUG_TX("Sending ASSOC frame\n");
>        else if (ieee80211_is_reassoc_request(fc))
>                IWL_DEBUG_TX("Sending REASSOC frame\n");
>  #endif
>
> -       /* drop all data frame if we are not associated */
> +       /* drop all data frame if !priv->assoc_station_added */
>        if (((fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DATA) =
&&
> -          (!iwl_is_associated(priv) ||
> -           ((priv->iw_mode =3D=3D IEEE80211_IF_TYPE_STA) && !priv->a=
ssoc_id) ||
> -           !priv->assoc_station_added)) {
> -               IWL_DEBUG_DROP("Dropping - !iwl_is_associated\n");
> +          !priv->assoc_station_added) {
> +               IWL_DEBUG_DROP("Dropping - !priv->assoc_station_added=
\n");
>                goto drop_unlock;
>        }
>
Need to add if (sta_is !=3D bcast)  otherwise this will drop all your
injected packets.

>        hdr_len =3D ieee80211_get_hdrlen(fc);
>
>        /* Find (or create) index into station table for destination s=
tation */
> @@ -5110,21 +5106,16 @@ static void iwl4965_mac_stop(struct ieee
>
>  static int iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *s=
kb,
>                      struct ieee80211_tx_control *ctl)
>  {
>        struct iwl_priv *priv =3D hw->priv;
>
>        IWL_DEBUG_MAC80211("enter\n");
>
> -       if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) {
> -               IWL_DEBUG_MAC80211("leave - monitor\n");
> -               return -1;
> -       }
> -
>        IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
>                     ctl->tx_rate->bitrate);
>
>        if (iwl4965_tx_skb(priv, skb, ctl))
>                dev_kfree_skb_any(skb);
>
>        IWL_DEBUG_MAC80211("leave\n");
>        return 0;
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
