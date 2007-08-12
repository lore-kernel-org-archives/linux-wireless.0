Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.230]:2507 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184AbXHLK6W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Aug 2007 06:58:22 -0400
Received: by wx-out-0506.google.com with SMTP id h31so950057wxd
        for <linux-wireless@vger.kernel.org>; Sun, 12 Aug 2007 03:58:22 -0700 (PDT)
Message-ID: <1ba2fa240708120358rb22a2f9me1a1020e669406e7@mail.gmail.com>
Date: Sun, 12 Aug 2007 13:58:21 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] hostapd: use eapol frames from ethernet device
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Jiri Benc" <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	"Jouni Malinen" <j@w1.fi>
In-Reply-To: <1186790012.4862.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1186789737.4862.3.camel@johannes.berg>
	 <1186790012.4862.8.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/11/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> Now that the kernel no longer sends them to the management device, grab
> them from ethernet instead.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>
> ---
> Maybe the ieee802_1x_receive there should be commented out completely? I
> had it commented out for testing but then only added the comment...
>
>  hostapd/driver_devicescape.c |    1 +
>  hostapd/hostapd.c            |   30 ++++++++++++++++++++++++------
>  hostapd/hostapd.h            |    3 ++-
>  3 files changed, 27 insertions(+), 7 deletions(-)
>
> --- hostap.orig/hostapd/driver_devicescape.c    2007-08-11 01:06:26.000000000 +0200
> +++ hostap/hostapd/driver_devicescape.c 2007-08-11 01:52:46.000000000 +0200
> @@ -1224,6 +1224,7 @@ static void handle_data(struct hostapd_d
>         pos += 2;
>         left -= 2;
>         switch (ethertype) {
> +       /* when we run on older wireless-dev kernels we might get this */
>         case ETH_P_PAE:
>                 ieee802_1x_receive(hapd, sa, pos, left);
>                 break;
> --- hostap.orig/hostapd/hostapd.c       2007-08-11 01:20:03.000000000 +0200
> +++ hostap/hostapd/hostapd.c    2007-08-11 01:39:00.000000000 +0200
> @@ -574,8 +574,10 @@ static void hostapd_cleanup(struct hosta
>         radius_server_deinit(hapd->radius_srv);
>         hapd->radius_srv = NULL;
>
> +       l2_packet_deinit(hapd->l2_eapol);
> +
>  #ifdef CONFIG_IEEE80211R
> -       l2_packet_deinit(hapd->l2);
> +       l2_packet_deinit(hapd->l2_rrb);
>  #endif /* CONFIG_IEEE80211R */
>
>         hostapd_wireless_event_deinit(hapd);
> @@ -906,9 +908,9 @@ static int hostapd_wpa_auth_send_ether(v
>                 return hapd->driver->send_ether(hapd->drv_priv, dst,
>                                                 hapd->own_addr, proto,
>                                                 data, data_len);
> -       if (hapd->l2 == NULL)
> +       if (hapd->l2_rrb == NULL)
>                 return -1;
> -       return l2_packet_send(hapd->l2, dst, proto, data, data_len);
> +       return l2_packet_send(hapd->l2_rrb, dst, proto, data, data_len);
>  }
>
>
> @@ -1080,6 +1082,13 @@ static int mac_in_conf(struct hostapd_co
>         return 0;
>  }
>
> +static void hostapd_eapol_receive(void *ctx, const u8 *src_addr,
> +                                 const u8 *buf, size_t len)
> +{
> +       struct hostapd_data *hapd = ctx;
> +
> +       ieee802_1x_receive(hapd, src_addr, buf, len);
> +}
>
>  /**
>   * hostapd_setup_bss - Per-BSS setup (initialization)
> @@ -1252,6 +1261,15 @@ static int hostapd_setup_bss(struct host
>                                "failed.\n");
>                         return -1;
>                 }
> +
> +               hapd->l2_eapol = l2_packet_init(hapd->conf->iface, NULL,
> +                                               ETH_P_EAPOL,
> +                                               hostapd_eapol_receive,
> +                                               hapd, 0);
> +               if (!hapd->l2_eapol) {
> +                       printf("Failed to open l2_packet interface\n");
> +                       return -1;
> +               }
>         }
>
>         if (accounting_init(hapd)) {
> @@ -1278,9 +1296,9 @@ static int hostapd_setup_bss(struct host
>         }
>
>  #ifdef CONFIG_IEEE80211R
> -       hapd->l2 = l2_packet_init(hapd->conf->iface, NULL, ETH_P_RRB,
> -                                 hostapd_rrb_receive, hapd, 0);
> -       if (hapd->l2 == NULL &&
> +       hapd->l2_rrb = l2_packet_init(hapd->conf->iface, NULL, ETH_P_RRB,
> +                                     hostapd_rrb_receive, hapd, 0);
> +       if (hapd->l2_rrb == NULL &&
>             (hapd->driver == NULL || hapd->driver->send_ether == NULL)) {
>                 printf("Failed to open l2_packet interface\n");
>                 return -1;
> --- hostap.orig/hostapd/hostapd.h       2007-08-11 01:19:29.000000000 +0200
> +++ hostap/hostapd/hostapd.h    2007-08-11 01:19:56.000000000 +0200
> @@ -167,7 +167,8 @@ struct hostapd_data {
>         struct full_dynamic_vlan *full_dynamic_vlan;
>  #endif /* CONFIG_FULL_DYNAMIC_VLAN */
>
> -       struct l2_packet_data *l2;
> +       struct l2_packet_data *l2_rrb;
> +       struct l2_packet_data *l2_eapol;
>  };
>
>
>
>
Isn't the removal of management interface a bit premature?  I didn't
see any proposal how to move management packets to the application
level?  If not I would prefer eapol packets be treated on management
path. No data should be received on data interface till security
negotiation is done.

Thanks
Tomas

> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
