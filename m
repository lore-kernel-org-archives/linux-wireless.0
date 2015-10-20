Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:33183 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbbJTUUB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 16:20:01 -0400
Received: by iodv82 with SMTP id v82so35356953iod.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2015 13:20:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1445280550-13673-1-git-send-email-mfaltesek@google.com>
References: <1445280550-13673-1-git-send-email-mfaltesek@google.com>
Date: Tue, 20 Oct 2015 13:20:00 -0700
Message-ID: <CAJwzM1k-hzyu+49zk5JwB91kAFVbCDRo6vM4UZ=bpj2_cFB4xQ@mail.gmail.com> (sfid-20151020_222007_381522_4473827E)
Subject: Re: [PATCH] mwifiex: toggle carrier state in start_ap/stop_ap.
From: Avinash Patil <avinashapatil@gmail.com>
To: Marty Faltesek <mfaltesek@google.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Denton Gentry <dgentry@google.com>,
	Avery Pennarun <apenwarr@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Marty,


On Mon, Oct 19, 2015 at 11:49 AM, Marty Faltesek <mfaltesek@google.com> wrote:
>
> In uap mode the carrier is not enabled until after the first STA joins.
> The carrier triggers the bridge to start its state machine, and if STP
> is enabled, it takes 4 seconds as it transitions from disabled to
> forwarding. During this time the bridge drops all traffic, and the EAPOL
> handshake times out after 3 seconds, preventing stations from joining.
>
> Follow the logic used in mac80211 and start the carrier in start_ap
> and disable it in stop_ap. This has a nice benefit of allowing the
> first station connection time to be reduced by up to 75% when STP is
> in use.
>
> Signed-off-by: Martin Faltesek <mfaltesek@google.com>
> ---
>  drivers/net/wireless/mwifiex/cfg80211.c  | 12 ++++++++++++
>  drivers/net/wireless/mwifiex/uap_event.c | 11 -----------
>  2 files changed, 12 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
> index 495621f..275ce3c 100644
> --- a/drivers/net/wireless/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/mwifiex/cfg80211.c
> @@ -1765,6 +1765,13 @@ static int mwifiex_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
>                 return -1;
>         }
>
> +       priv->media_connected = false;
> +       if (netif_carrier_ok(priv->netdev))
> +               netif_carrier_off(priv->netdev);
> +       mwifiex_stop_net_dev_queue(priv->netdev, priv->adapter);
> +       mwifiex_clean_txrx(priv);
> +       mwifiex_del_all_sta_list(priv);
> +
>         return 0;
>  }
>
> @@ -1863,6 +1870,11 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
>         if (mwifiex_set_mgmt_ies(priv, &params->beacon))
>                 return -1;
>
> +       priv->media_connected = true;
> +       if (!netif_carrier_ok(priv->netdev))
> +               netif_carrier_on(priv->netdev);
> +       mwifiex_wake_up_net_dev_queue(priv->netdev, priv->adapter);
> +
>         memcpy(&priv->bss_cfg, bss_cfg, sizeof(priv->bss_cfg));
>         kfree(bss_cfg);
>         return 0;
> diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
> index f4794cd..c5bb6ee 100644
> --- a/drivers/net/wireless/mwifiex/uap_event.c
> +++ b/drivers/net/wireless/mwifiex/uap_event.c
> @@ -113,19 +113,8 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
>                 mwifiex_del_sta_entry(priv, deauth_mac);
>                 break;
>         case EVENT_UAP_BSS_IDLE:
> -               priv->media_connected = false;
> -               if (netif_carrier_ok(priv->netdev))
> -                       netif_carrier_off(priv->netdev);
> -               mwifiex_stop_net_dev_queue(priv->netdev, adapter);
> -
> -               mwifiex_clean_txrx(priv);
> -               mwifiex_del_all_sta_list(priv);
>                 break;
>         case EVENT_UAP_BSS_ACTIVE:
> -               priv->media_connected = true;

I remember we have encountered an issue if we download packets to
interface/FW before bss has become active. I think media_connected
cannot be set to true in start_ap; this may cause issues.

Amit,
I would suggest running some tests to see that FW does not crash if we
set media_connected before BSS_ACTIVE event.

Also, this patch has side-effect of cleaning TXRX and station list
data structures only in stop_ap. This is not correct. There is no
point in holding these structures/memory if no stations are connected.

> -               if (!netif_carrier_ok(priv->netdev))
> -                       netif_carrier_on(priv->netdev);
> -               mwifiex_wake_up_net_dev_queue(priv->netdev, adapter);
>                 break;
>         case EVENT_UAP_BSS_START:
>                 dev_dbg(adapter->dev, "AP EVENT: event id: %#x\n", eventcause);
> --
> 2.6.0.rc2.230.g3dd15c0
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks,
Avinash
