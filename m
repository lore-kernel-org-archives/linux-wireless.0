Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35793 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab0GaHf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jul 2010 03:35:59 -0400
Received: by qwh6 with SMTP id 6so534276qwh.19
        for <linux-wireless@vger.kernel.org>; Sat, 31 Jul 2010 00:35:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AFAAC7F.8000903@openwrt.org>
References: <4AFAAC7F.8000903@openwrt.org>
From: Javier Cardona <javier@cozybit.com>
Date: Sat, 31 Jul 2010 09:35:38 +0200
Message-ID: <AANLkTi=GDPWjj6zB4iCH2rFMWLL=8i5OD=oPfkoSkths@mail.gmail.com>
Subject: Re: [PATCH] iw: add a command for moving a STA into an AP VLAN
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix,

This patch apparently broke the plink_action commands.  Any chance you
could rework it?

Thanks,

Javier

On Wed, Nov 11, 2009 at 2:22 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>
> --- a/station.c
> +++ b/station.c
> @@ -196,7 +196,7 @@ COMMAND(station, del, "<MAC address>",
>        NL80211_CMD_DEL_STATION, 0, CIB_NETDEV, handle_station_get,
>        "Remove the given station entry (use with caution!)");
>
> -static int handle_station_set(struct nl80211_state *state,
> +static int handle_station_set_plink(struct nl80211_state *state,
>                              struct nl_cb *cb,
>                              struct nl_msg *msg,
>                              int argc, char **argv)
> @@ -241,9 +241,56 @@ static int handle_station_set(struct nl8
>        return -ENOBUFS;
>  }
>  COMMAND(station, set, "<MAC address> plink_action <open|block>",
> -       NL80211_CMD_SET_STATION, 0, CIB_NETDEV, handle_station_set,
> +       NL80211_CMD_SET_STATION, 0, CIB_NETDEV, handle_station_set_plink,
>        "Set mesh peer link action for this station (peer).");
>
> +static int handle_station_set_vlan(struct nl80211_state *state,
> +                             struct nl_cb *cb,
> +                             struct nl_msg *msg,
> +                             int argc, char **argv)
> +{
> +       unsigned char mac_addr[ETH_ALEN];
> +       unsigned long sta_vlan = 0;
> +       char *err = NULL;
> +
> +       if (argc < 3)
> +               return 1;
> +
> +       if (mac_addr_a2n(mac_addr, argv[0])) {
> +               fprintf(stderr, "invalid mac address\n");
> +               return 2;
> +       }
> +       argc--;
> +       argv++;
> +
> +       if (strcmp("vlan", argv[0]) != 0)
> +               return 1;
> +       argc--;
> +       argv++;
> +
> +       sta_vlan = strtoul(argv[0], &err, 0);
> +       if (err && *err) {
> +               fprintf(stderr, "invalid vlan id\n");
> +               return 2;
> +       }
> +       argc--;
> +       argv++;
> +
> +       if (argc)
> +               return 1;
> +
> +       NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
> +       NLA_PUT_U32(msg, NL80211_ATTR_STA_VLAN, sta_vlan);
> +
> +       return 0;
> + nla_put_failure:
> +       return -ENOBUFS;
> +}
> +COMMAND(station, set, "<MAC address> vlan <ifindex>",
> +       NL80211_CMD_SET_STATION, 0, CIB_NETDEV, handle_station_set_vlan,
> +       "Set an AP VLAN for this station.");
> +
> +
>  static int handle_station_dump(struct nl80211_state *state,
>                               struct nl_cb *cb,
>                               struct nl_msg *msg,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
