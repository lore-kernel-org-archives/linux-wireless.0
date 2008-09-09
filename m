Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:17993 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbYIIJnn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 05:43:43 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1086808yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Sep 2008 02:43:42 -0700 (PDT)
Message-ID: <1ba2fa240809090243m443c87f2xab50d7f2ec0c9d07@mail.gmail.com> (sfid-20080909_114345_890190_6ADADCC2)
Date: Tue, 9 Sep 2008 12:43:41 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 13/8] mac80211: consolidate deauth/disassoc
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1220950705.31304.121.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080908154421.216772000@sipsolutions.net>
	 <1220950705.31304.121.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 9, 2008 at 11:58 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> deauth and disassoc frames are completely identical so there's
> little point in having two functions to send them rather than
> one that gets a parameter. This same a bit of code size.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Sounds good. Ack


> ---
>  net/mac80211/mlme.c |   47 +++++++++++------------------------------------
>  1 file changed, 11 insertions(+), 36 deletions(-)
>
> --- everything.orig/net/mac80211/mlme.c 2008-09-09 09:47:27.000000000 +0200
> +++ everything/net/mac80211/mlme.c      2008-09-09 09:50:07.000000000 +0200
> @@ -416,17 +416,18 @@ static void ieee80211_send_assoc(struct
>  }
>
>
> -static void ieee80211_send_deauth(struct ieee80211_sub_if_data *sdata,
> -                                 struct ieee80211_if_sta *ifsta, u16 reason)
> +static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
> +                                          u16 stype, u16 reason)
>  {
>        struct ieee80211_local *local = sdata->local;
> +       struct ieee80211_if_sta *ifsta = &sdata->u.sta;
>        struct sk_buff *skb;
>        struct ieee80211_mgmt *mgmt;
>
>        skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*mgmt));
>        if (!skb) {
> -               printk(KERN_DEBUG "%s: failed to allocate buffer for deauth "
> -                      "frame\n", sdata->dev->name);
> +               printk(KERN_DEBUG "%s: failed to allocate buffer for "
> +                      "deauth/disassoc frame\n", sdata->dev->name);
>                return;
>        }
>        skb_reserve(skb, local->hw.extra_tx_headroom);
> @@ -436,42 +437,14 @@ static void ieee80211_send_deauth(struct
>        memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
>        memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
>        memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
> -       mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
> -                                         IEEE80211_STYPE_DEAUTH);
> +       mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT | stype);
>        skb_put(skb, 2);
> +       /* u.deauth.reason_code == u.disassoc.reason_code */
>        mgmt->u.deauth.reason_code = cpu_to_le16(reason);
>
>        ieee80211_sta_tx(sdata, skb, 0);
>  }
>
> -static void ieee80211_send_disassoc(struct ieee80211_sub_if_data *sdata,
> -                                   struct ieee80211_if_sta *ifsta, u16 reason)
> -{
> -       struct ieee80211_local *local = sdata->local;
> -       struct sk_buff *skb;
> -       struct ieee80211_mgmt *mgmt;
> -
> -       skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*mgmt));
> -       if (!skb) {
> -               printk(KERN_DEBUG "%s: failed to allocate buffer for disassoc "
> -                      "frame\n", sdata->dev->name);
> -               return;
> -       }
> -       skb_reserve(skb, local->hw.extra_tx_headroom);
> -
> -       mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
> -       memset(mgmt, 0, 24);
> -       memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
> -       memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
> -       memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
> -       mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
> -                                         IEEE80211_STYPE_DISASSOC);
> -       skb_put(skb, 2);
> -       mgmt->u.disassoc.reason_code = cpu_to_le16(reason);
> -
> -       ieee80211_sta_tx(sdata, skb, 0);
> -}
> -
>  static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *da, u16 tid,
>                                        u8 dialog_token, u16 status, u16 policy,
>                                        u16 buf_size, u16 timeout)
> @@ -920,9 +893,11 @@ static void ieee80211_set_disassoc(struc
>
>        if (self_disconnected) {
>                if (deauth)
> -                       ieee80211_send_deauth(sdata, ifsta, reason);
> +                       ieee80211_send_deauth_disassoc(sdata,
> +                               IEEE80211_STYPE_DEAUTH, reason);
>                else
> -                       ieee80211_send_disassoc(sdata, ifsta, reason);
> +                       ieee80211_send_deauth_disassoc(sdata,
> +                               IEEE80211_STYPE_DISASSOC, reason);
>        }
>
>        ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
