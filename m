Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49658 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512Ab2FYNqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 09:46:43 -0400
Received: by obbuo13 with SMTP id uo13so6478665obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2012 06:46:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340117456-10154-7-git-send-email-johannes@sipsolutions.net>
References: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
	<1340117456-10154-7-git-send-email-johannes@sipsolutions.net>
Date: Mon, 25 Jun 2012 16:46:42 +0300
Message-ID: <CAB3XZEeaG2i0LBOE6Jzsy6ghxpGRcDm3wUwi=+Vcmr9NcX96cw@mail.gmail.com> (sfid-20120625_154646_777052_2016FAC8)
Subject: Re: [RFC 06/17] nl80211: prepare for non-netdev wireless devs
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 19, 2012 at 5:50 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> In order to support a P2P device abstraction and
> Bluetooth high-speed AMPs, we need to have a way
> to identify virtual interfaces that don't have a
> netdev associated.
>
> Do this by adding a NL80211_ATTR_WDEV attribute
> to identify a wdev which may or may not also be
> a netdev.
>
> To simplify things, use a 64-bit value with the
> high 32 bits being the wiphy index for this new
> wdev identifier in the nl80211 API.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
[...]

> @@ -2318,17 +2318,25 @@ struct cfg80211_internal_bss;
>  struct cfg80211_cached_keys;
>
>  /**
> - * struct wireless_dev - wireless per-netdev state
> + * struct wireless_dev - wireless device state
>  *
> - * This structure must be allocated by the driver/stack
> - * that uses the ieee80211_ptr field in struct net_device
> - * (this is intentional so it can be allocated along with
> - * the netdev.)
> + * For netdevs, this structure must be allocated by the driver
> + * that uses the ieee80211_ptr field in struct net_device (this
> + * is intentional so it can be allocated along with the netdev.)
> + * It need not be registered then as netdev registration will
> + * be intercepted by cfg80211 to see the new wireless device.
> + *
it think you meant "it needs to be registered..." ?

> @@ -2360,6 +2368,8 @@ struct wireless_dev {
>        struct list_head list;
>        struct net_device *netdev;
>
> +       u32 identifier;
> +
>        struct list_head mgmt_registrations;
>        spinlock_t mgmt_registrations_lock;
>

> --- a/net/wireless/core.h
> +++ b/net/wireless/core.h
> @@ -46,11 +46,11 @@ struct cfg80211_registered_device {
>        /* wiphy index, internal only */
>        int wiphy_idx;
>
> -       /* associate netdev list */
> +       /* associated wireless interfaces */
>        struct mutex devlist_mtx;
>        /* protected by devlist_mtx or RCU */
> -       struct list_head netdev_list;
> -       int devlist_generation;
> +       struct list_head wdev_list;
> +       int devlist_generation, wdev_id;

it doesn't really matter, but why not define wdev_id with the same
type as wdev->identifier?

> -/* internal helper: get rdev and dev */
> -static int get_rdev_dev_by_ifindex(struct net *netns, struct nlattr **attrs,
> -                                  struct cfg80211_registered_device **rdev,
> -                                  struct net_device **dev)
> +/* returns ERR_PTR values */
> +static struct wireless_dev *
> +__cfg80211_wdev_from_attrs(struct net *netns, struct nlattr **attrs)
>  {
> -       int ifindex;
> +       struct cfg80211_registered_device *rdev;
> +       struct wireless_dev *result = NULL;
> +       bool have_ifidx = attrs[NL80211_ATTR_IFINDEX];
> +       bool have_wdev_id = attrs[NL80211_ATTR_WDEV];
> +       u64 wdev_id;
> +       int wiphy_idx = -1;
> +       int ifidx = -1;
>
> -       if (!attrs[NL80211_ATTR_IFINDEX])
> -               return -EINVAL;
> +       assert_cfg80211_lock();
>
> -       ifindex = nla_get_u32(attrs[NL80211_ATTR_IFINDEX]);
> -       *dev = dev_get_by_index(netns, ifindex);
> -       if (!*dev)
> -               return -ENODEV;
> +       if (!have_ifidx && !have_wdev_id)
> +               return ERR_PTR(-EINVAL);
>
> -       *rdev = cfg80211_get_dev_from_ifindex(netns, ifindex);
> -       if (IS_ERR(*rdev)) {
> -               dev_put(*dev);
> -               return PTR_ERR(*rdev);
> +       if (have_ifidx)
> +               ifidx = nla_get_u32(attrs[NL80211_ATTR_IFINDEX]);
> +       if (have_wdev_id) {
> +               wdev_id = nla_get_u64(attrs[NL80211_ATTR_WDEV]);
> +               wiphy_idx = wdev_id >> 32;
>        }
>
> -       return 0;
> +       list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
> +               struct wireless_dev *wdev;
> +
> +               if (have_wdev_id && rdev->wiphy_idx != wiphy_idx)
> +                       continue;
> +
> +               mutex_lock(&rdev->devlist_mtx);
> +               list_for_each_entry(wdev, &rdev->wdev_list, list) {
> +                       if (have_ifidx && wdev->netdev &&
> +                           wdev->netdev->ifindex == ifidx) {
> +                               result = wdev;
> +                               break;
> +                       }
> +                       if (have_wdev_id && wdev->identifier == (u32)wdev_id) {
> +                               result = wdev;
> +                               break;
> +                       }
> +               }
> +               mutex_unlock(&rdev->devlist_mtx);
> +
> +               if (result)
> +                       break;
> +       }
> +
> +       if (result)
> +               return result;
> +       return ERR_PTR(-ENODEV);

doesn't it remove the netns checks you've just added? :)


Eliad.
