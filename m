Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.178]:51247 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbYETNlS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 09:41:18 -0400
Received: by el-out-1112.google.com with SMTP id s27so590479ele.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2008 06:41:18 -0700 (PDT)
Message-ID: <1ba2fa240805200641j4ccc1de4r5572e1321394a526@mail.gmail.com> (sfid-20080520_154129_076105_35D9A50A)
Date: Tue, 20 May 2008 16:41:17 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: iwlwifi injection bug
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Zhu Yi" <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Andy Green" <andy@warmcat.com>
In-Reply-To: <69e28c910805200614q2232b21ame8ff03fe4156fb3b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1210945631.6381.11.camel@johannes.berg>
	 <1211249729.2532.59.camel@debian.sh.intel.com>
	 <69e28c910805200432lbd3790vb925dacaea3aca83@mail.gmail.com>
	 <1211287111.6252.84.camel@johannes.berg>
	 <69e28c910805200614q2232b21ame8ff03fe4156fb3b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2008 at 4:14 PM, Stefanik G=E1bor <netrolller.3d@gmail.=
com> wrote:
> (Resend of previous mail, his time also sending to the list.)
> On Tue, May 20, 2008 at 8:38 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>>
>>> <snip>
>>
>> That code is completely bogus anyway IMO, it should just be removed.
>>
>>> <snip>
>>
>> Same here, why drop a frame if there's no station for it, that just
>> means you can't do hw encryption which, well, cannot happen anyway s=
ince
>> mac80211 would tell you about the station for hw crypto.
>>
>>> <snip>
>>
>> That's the code I was complaining about. Just kill it if it works th=
en.
>>
>>> <snip>
>>
>> Same code, other driver. What are you doing poking with the 802.11
>> frames you're supposed to transmit anyway?
>>
>> I wish you guys at Intel would trust mac80211 and not try to work ar=
ound
>> it all the time.
>>
>> johannes
>>
>
> Patch with nits addressed, a syslog issue fixed and also with a
> bracketing fix in 3945:
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
> 08:54:52.819664502 -0400
> @@ -2523,17 +2523,17 @@ static int iwl3945_get_sta_id(struct iwl
>        case IEEE80211_IF_TYPE_AP:
>                sta_id =3D iwl3945_hw_find_station(priv, hdr->addr1);
>                if (sta_id !=3D IWL_INVALID_STATION)
>                        return sta_id;
>                return priv->hw_setting.bcast_sta_id;
>
>        /* If this frame is going out to an IBSS network, find the sta=
tion,
>         * or create a new station table entry */
> -       case IEEE80211_IF_TYPE_IBSS: {
> +       case IEEE80211_IF_TYPE_IBSS:
>                DECLARE_MAC_BUF(mac);
>
>                /* Create new station table entry */
>                sta_id =3D iwl3945_hw_find_station(priv, hdr->addr1);
>                if (sta_id !=3D IWL_INVALID_STATION)
>                        return sta_id;
>
>                sta_id =3D iwl3945_add_station(priv, hdr->addr1, 0, CM=
D_ASYNC);
> @@ -2541,17 +2541,20 @@ static int iwl3945_get_sta_id(struct iwl
>                if (sta_id !=3D IWL_INVALID_STATION)
>                        return sta_id;
>
>                IWL_DEBUG_DROP("Station %s not in station map. "
>                               "Defaulting to broadcast...\n",
>                               print_mac(mac, hdr->addr1));
>                iwl3945_print_hex_dump(IWL_DL_DROP, (u8 *) hdr, sizeof=
(*hdr));
>                return priv->hw_setting.bcast_sta_id;
> -       }
> +
> +       /* If we are in monitor mode, use BCAST */
> +       case IEEE80211_IF_TYPE_MNTR:
> +               return priv->hw_params.bcast_sta_id;
>        default:
>                IWL_WARNING("Unknown mode of operation: %d", priv->iw_=
mode);
>                return priv->hw_setting.bcast_sta_id;
>        }
>  }
>
This seams Okay.
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

Not sure about this

>        if ((ctl->tx_rate->hw_value & 0xFF) =3D=3D IWL_INVALID_RATE) {
>                IWL_ERROR("ERROR: No TX rate available.\n");
>                goto drop_unlock;
>        }
>
>        unicast =3D !is_multicast_ether_addr(hdr->addr1);
>        id =3D 0;
>
> @@ -2603,37 +2601,22 @@ static int iwl3945_tx_skb(struct iwl3945
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
The thing is that mac80211 and uCode are not exactly in sync on
association time.
I'm not sure but this would be also spec violation.

>        spin_unlock_irqrestore(&priv->lock, flags);
>
>        hdr_len =3D ieee80211_get_hdrlen(fc);
>
>        /* Find (or create) index into station table for destination s=
tation */
>        sta_id =3D iwl3945_get_sta_id(priv, hdr);
> -       if (sta_id =3D=3D IWL_INVALID_STATION) {
> -               DECLARE_MAC_BUF(mac);
> -
> -               IWL_DEBUG_DROP("Dropping - INVALID STATION: %s\n",
> -                              print_mac(mac, hdr->addr1));
> -               goto drop;
> -       }
>
send packet with invalid station will certainly crash uCode.

>        IWL_DEBUG_RATE("station Id %d\n", sta_id);
>
>        qc =3D ieee80211_get_qos_ctrl(hdr);
>        if (qc) {
>                u8 tid =3D (u8)(le16_to_cpu(*qc) & 0xf);
>                seq_number =3D priv->stations[sta_id].tid[tid].seq_num=
ber &
>                                IEEE80211_SCTL_SEQ;
> @@ -6692,21 +6675,16 @@ static void iwl3945_mac_stop(struct ieee
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
> 08:55:20.689530273 -0400
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
> @@ -1808,38 +1806,22 @@ static int iwl4965_tx_skb(struct iwl_pri
>        if (ieee80211_is_auth(fc))
>                IWL_DEBUG_TX("Sending AUTH frame\n");
>        else if (ieee80211_is_assoc_request(fc))
>                IWL_DEBUG_TX("Sending ASSOC frame\n");
>        else if (ieee80211_is_reassoc_request(fc))
>                IWL_DEBUG_TX("Sending REASSOC frame\n");
>  #endif
>
> -       /* drop all data frame if we are not associated */
> -       if (((fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DATA)=
 &&
> -          (!iwl_is_associated(priv) ||
> -           ((priv->iw_mode =3D=3D IEEE80211_IF_TYPE_STA) && !priv->a=
ssoc_id) ||
> -           !priv->assoc_station_added)) {
> -               IWL_DEBUG_DROP("Dropping - !iwl_is_associated\n");
> -               goto drop_unlock;
> -       }
> -
>        spin_unlock_irqrestore(&priv->lock, flags);
>
>        hdr_len =3D ieee80211_get_hdrlen(fc);
>
>        /* Find (or create) index into station table for destination s=
tation */
>        sta_id =3D iwl4965_get_sta_id(priv, hdr);
> -       if (sta_id =3D=3D IWL_INVALID_STATION) {
> -               DECLARE_MAC_BUF(mac);
> -
> -               IWL_DEBUG_DROP("Dropping - INVALID STATION: %s\n",
> -                              print_mac(mac, hdr->addr1));
> -               goto drop;
> -       }
>
>        IWL_DEBUG_TX("station Id %d\n", sta_id);
>
>        qc =3D ieee80211_get_qos_ctrl(hdr);
>        if (qc) {
>                u8 tid =3D (u8)(le16_to_cpu(*qc) & 0xf);
>                seq_number =3D priv->stations[sta_id].tid[tid].seq_num=
ber &
>                                IEEE80211_SCTL_SEQ;
> @@ -5110,21 +5092,16 @@ static void iwl4965_mac_stop(struct ieee
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
