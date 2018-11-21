Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 405D1C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 03:20:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 007292146D
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 03:20:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ouj+K6SE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 007292146D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbeKUNwo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 08:52:44 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:39933 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbeKUNwo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 08:52:44 -0500
Received: by mail-it1-f196.google.com with SMTP id m15so6903847itl.4
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2018 19:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FiCdHyIa9h0bIFMQcO0jsjWyTGYGB+3PczdquQhm+rI=;
        b=ouj+K6SENJQXFkwKw30Nr4Msrh5cI8xfES5ypVpTveAjHBqjCJ/4wtVuetO07qiqLv
         a63WAP0N++gXvyovfXDM6wipHBEJR8kCREKjuNrba7gSmxrZI4ridNZP/eL7z5i2Cb8K
         UbjLlIz8fZaiOTfsae+Lid27pqabIiQ2SJkkrn7Vb5LkfQLOOmR+KzC8G7cXIQOo4Vu0
         coYuefPogyqHaMRcL8ouS/4phBja17BoScUx/zZU/X1nIXQivaWdDLPY7lS34J/7k5hW
         1AenbF0X0jyyqiON+sDh+0S6XJVHXz22SZy6R3yFY/H5x1A1P9uALYd3sHosDUEvAUTT
         I72A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FiCdHyIa9h0bIFMQcO0jsjWyTGYGB+3PczdquQhm+rI=;
        b=VNsTjYXVS3E9Wg7a2Ugg/+67COsGfUdTptoSlAekbcR176F1vdV7K8ur5WRMDk7fzn
         LsjHcDQLR25zEpr8nz7FiGk7n0Sf3/PlvBB/jRz8ELNDJpIMwoEH60MDYNnlauvQ3eHD
         GVYu9vEe0oz5k/zsEi/gniOnhsZmecyeS/+lzL/CvH/PJ7gMGkX7lqxQLsSWv8nuYSET
         W6GO1bE4OEjotPYJ+AU1dKbbo3HpTOeXIrux4U6MNiMVO6GlQZaSmhItAhiTPW9ojZKs
         63ghBc+YVEyZ5xGAp76k7L6VnYM6z7d+v7LN5mgEOgKTH7Fp1Jz7dhKCawRZYqBlhyE8
         qJHw==
X-Gm-Message-State: AGRZ1gKtMt384xu0sFraaGgKom2uma2qgwS7bS0DdRJJtj9f4v6doo6j
        KRRLw6jJowPWro0g/K2NjGzF5qciSIQC3V+pgavocQ==
X-Google-Smtp-Source: AJdET5fXgCSb44+b6dUu/o5s62y3cnd57bgPrSMqquCEqtVz3sA4DDmjDLDvKbxBY2Fxej0UB6sy5nJeVhbBLeoJ2jM=
X-Received: by 2002:a24:db02:: with SMTP id c2mr4630454itg.137.1542770413258;
 Tue, 20 Nov 2018 19:20:13 -0800 (PST)
MIME-Version: 1.0
References: <20181004195906.201895-1-schuffelen@google.com> <20181005143323.ezyd2x6x5ymlb7rg@bars>
In-Reply-To: <20181005143323.ezyd2x6x5ymlb7rg@bars>
From:   Cody Schuffelen <schuffelen@google.com>
Date:   Tue, 20 Nov 2018 19:20:01 -0800
Message-ID: <CAAELVAF+-6F0Qvj3wU-sO0+EF5Qs0VXYqD9GEeV0ZuP-dKOoFA@mail.gmail.com>
Subject: Re: [PATCH net-next v3] wireless-drivers: rtnetlink wifi simulation device
To:     sergey.matyukevich.os@quantenna.com
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> > +       informed_bss =
> > +               cfg80211_inform_bss_data(wiphy, &mock_inform_bss,
> > +                                        CFG80211_BSS_FTYPE_PRESP,
> > +                                        fake_router_bssid,
> > +                                        mock_inform_bss.boottime_ns,
> > +                                        WLAN_CAPABILITY_ESS, 0, ssid.data,
> > +                                        sizeof(ssid), GFP_KERNEL);
>
> It is possible to simplify this part switching to cfg80211_inform_bss
> function: this function wraps your scan data in into cfg80211_inform_bss
> structure internally using some reasonable defaults, e.g. channel width.
>
> Besides, signal strength for scan entries should be passed in mBm units,
> so use DBM_TO_MBM macro. For instance, with your current code 'iw' tool
> produces the following output:
> $ sudo iw dev wlan0 scan
>         ...
>         signal: 0.-60 dBm
>         ...

Good catch, fixed.

> > +static void virt_wifi_connect_complete(struct work_struct *work)
> > +{
> > +       struct virt_wifi_priv *priv =
> > +               container_of(work, struct virt_wifi_priv, connect.work);
> > +       u8 *requested_bss = priv->connect_requested_bss;
> > +       bool has_addr = !is_zero_ether_addr(requested_bss);
> > +       bool right_addr = ether_addr_equal(requested_bss, fake_router_bssid);
> > +       u16 status = WLAN_STATUS_SUCCESS;
> > +
> > +       rtnl_lock();
> > +       if (!priv->netdev_is_up || (has_addr && !right_addr))
> > +               status = WLAN_STATUS_UNSPECIFIED_FAILURE;
> > +       else
> > +               priv->is_connected = true;
> > +
> > +       cfg80211_connect_result(priv->netdev, requested_bss, NULL, 0, NULL, 0,
> > +                               status, GFP_KERNEL);
> > +       rtnl_unlock();
> > +}
>
> Carrier state for wireless device depends on its connection state.
> E.g., carrier is set when wireless connection succeeds and cleared
> when device disconnects. So use netif_carrier_on/netif_carrier_off
> calls in connect/disconnect handlers to set correct carrier state.
> IIUC the following locations look reasonable:
>  - netif_carrier_off on init
>  - netif_carrier_on in virt_wifi_connect_complete on success
>  - netif_carrier_off in virt_wifi_disconnect

Thanks, added.

> > +static void virt_wifi_disconnect_complete(struct work_struct *work)
> > +{
> > +       struct virt_wifi_priv *priv =
> > +               container_of(work, struct virt_wifi_priv, disconnect.work);
> > +
> > +       cfg80211_disconnected(priv->netdev, priv->disconnect_reason, NULL, 0,
> > +                             true, GFP_KERNEL);
> > +       priv->is_connected = false;
> > +}
>
> Why do you need delayed disconnect processing ? IIUC it can be dropped
> and cfg80211_disconnected call can be moved to virt_wifi_disconnect.

Done.

> > +
> > +static int virt_wifi_get_station(struct wiphy *wiphy,
> > +                                struct net_device *dev,
> > +                                const u8 *mac,
> > +                                struct station_info *sinfo)
> > +{
> > +       wiphy_debug(wiphy, "get_station\n");
> > +
> > +       if (!ether_addr_equal(mac, fake_router_bssid))
> > +               return -ENOENT;
> > +
> > +       sinfo->filled = BIT(NL80211_STA_INFO_TX_PACKETS) |
> > +               BIT(NL80211_STA_INFO_TX_FAILED) | BIT(NL80211_STA_INFO_SIGNAL) |
> > +               BIT(NL80211_STA_INFO_TX_BITRATE);
>
> Recently some of NL80211_STA_INFO_ attribute types has been modified to
> use BIT_ULL macro. Could you please check commit 22d0d2fafca93ba1d92a
> for details and modify your coded if needed.

Thanks for the the reference, updated to use BIT_ULL with the station commands.

> > +       sinfo->tx_packets = 1;
>
> Only one packet, really ? Not sure if you plan to use the output of 'iw'
> or any other tool. If yes, then it probably makes sense to use stats
> from the original network link. Otherwise, your 'iw' output is
> going to look like this:
>
> $ iw dev wlan0 station dump
>         ...
>         tx packets:     1
>         ...
>
> > +       sinfo->tx_failed = 0;
>
> ...

Added bookkeeping to the net_device packet forwarded to track how many
packets were sent, and how many failed being sent due to no
connection.

> > +static int virt_wifi_dump_station(struct wiphy *wiphy,
> > +                                 struct net_device *dev,
> > +                                 int idx,
> > +                                 u8 *mac,
> > +                                 struct station_info *sinfo)
> > +{
> > +       wiphy_debug(wiphy, "dump_station\n");
> > +
> > +       if (idx != 0)
> > +               return -ENOENT;
> > +
> > +       ether_addr_copy(mac, fake_router_bssid);
> > +       return virt_wifi_get_station(wiphy, dev, fake_router_bssid, sinfo);
> > +}
>
> Callback dump_station should return AP data only when STA is connected.
> Currently your driver returns fake AP data even when it is not
> connected.

Thanks, fixed.

> > +static const struct cfg80211_ops virt_wifi_cfg80211_ops = {
> > +       .scan = virt_wifi_scan,
> > +
> > +       .connect = virt_wifi_connect,
> > +       .disconnect = virt_wifi_disconnect,
> > +
> > +       .get_station = virt_wifi_get_station,
> > +       .dump_station = virt_wifi_dump_station,
> > +};
>
> Hey, this minimal cfg80211 implementation works fine with wpa_supplicant
> and open AP config. By the way, if you plan to add more features, then
> I would suggest to consider the following cfg80211 callbacks:
> - change_station, get_channel
>   to provide more info in connected state, e.g. compare the output
>   of the following commands between your virtual interface and
>   actual wireless interface:
>   $ iw dev wlan0 link
>   $ iw dev wlan0 info
>
> - stubs for add_key, del_key to enable encrypted AP simulation

Thanks for testing it out!

I've uploaded the new version here: https://lkml.org/lkml/2018/11/21/251
