Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61829 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab0H0Sgg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 14:36:36 -0400
Received: by qyk9 with SMTP id 9so934469qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 27 Aug 2010 11:36:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100827103658.361889799@sipsolutions.net>
References: <20100827103553.559128239@sipsolutions.net> <20100827103658.361889799@sipsolutions.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 27 Aug 2010 20:36:15 +0200
Message-ID: <AANLkTinDQDRZzHxjoUNWr=f6LbdRKR4nedjA-5HmKwKz@mail.gmail.com>
Subject: Re: [PATCH 3/6] mac80211: simplify zero address checks
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 27, 2010 at 12:35 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> The libertas_tf special code for zero addresses

libertas_tf? This looks like a mac80211 patch to me...

> is a bit too complex, it compares against a stack
> value instead of using is_zero_ether_addr() and
> tries to update all interfaces even if just the
> one that's being brought up needs to be changed.
> Additionally, the repeated check for a valid MAC
> address need only be done if we actually changed
> it on the fly.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/iface.c |   38 +++++++++++++-------------------------
>  1 file changed, 13 insertions(+), 25 deletions(-)
>
> --- wireless-testing.orig/net/mac80211/iface.c  2010-08-26 16:00:30.000000000 +0200
> +++ wireless-testing/net/mac80211/iface.c       2010-08-26 16:00:31.000000000 +0200
> @@ -103,10 +103,9 @@ static int ieee80211_open(struct net_dev
>        u32 changed = 0;
>        int res;
>        u32 hw_reconf_flags = 0;
> -       u8 null_addr[ETH_ALEN] = {0};
>
>        /* fail early if user set an invalid address */
> -       if (compare_ether_addr(dev->dev_addr, null_addr) &&
> +       if (!is_zero_ether_addr(dev->dev_addr) &&
>            !is_valid_ether_addr(dev->dev_addr))
>                return -EADDRNOTAVAIL;
>
> @@ -195,33 +194,22 @@ static int ieee80211_open(struct net_dev
>        }
>
>        /*
> -        * Check all interfaces and copy the hopefully now-present
> -        * MAC address to those that have the special null one.
> +        * Copy the hopefully now-present MAC address to
> +        * this interface, if it has the special null one.
>         */
> -       list_for_each_entry(nsdata, &local->interfaces, list) {
> -               struct net_device *ndev = nsdata->dev;
> -
> -               /*
> -                * No need to check running since we do not allow
> -                * it to start up with this invalid address.
> -                */
> -               if (compare_ether_addr(null_addr, ndev->dev_addr) == 0) {
> -                       memcpy(ndev->dev_addr,
> -                              local->hw.wiphy->perm_addr,
> -                              ETH_ALEN);
> -                       memcpy(ndev->perm_addr, ndev->dev_addr, ETH_ALEN);
> +       if (is_zero_ether_addr(dev->dev_addr)) {
> +               memcpy(dev->dev_addr,
> +                      local->hw.wiphy->perm_addr,
> +                      ETH_ALEN);
> +               memcpy(dev->perm_addr, dev->dev_addr, ETH_ALEN);
> +
> +               if (!is_valid_ether_addr(dev->dev_addr)) {
> +                       if (!local->open_count)
> +                               drv_stop(local);
> +                       return -EADDRNOTAVAIL;
>                }
>        }
>
> -       /*
> -        * Validate the MAC address for this device.
> -        */
> -       if (!is_valid_ether_addr(dev->dev_addr)) {
> -               if (!local->open_count)
> -                       drv_stop(local);
> -               return -EADDRNOTAVAIL;
> -       }
> -
>        switch (sdata->vif.type) {
>        case NL80211_IFTYPE_AP_VLAN:
>                /* no need to tell driver */
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
