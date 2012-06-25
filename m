Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f51.google.com ([209.85.213.51]:45185 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab2FYPUr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 11:20:47 -0400
Received: by yhnn12 with SMTP id n12so3444150yhn.10
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2012 08:20:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340117456-10154-16-git-send-email-johannes@sipsolutions.net>
References: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
	<1340117456-10154-16-git-send-email-johannes@sipsolutions.net>
Date: Mon, 25 Jun 2012 18:20:46 +0300
Message-ID: <CAB3XZEcWE46OHiigB24ezaDA3rRUYoKGtYcmvVxVgMizVK+d8w@mail.gmail.com> (sfid-20120625_172050_845280_CACCAB80)
Subject: Re: [RFC 15/17] cfg80211: add P2P Device abstraction
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
> In order to support using a different MAC address
> for the P2P Device address we must first have a
> P2P Device abstraction that can be assigned a MAC
> address.
>
> This abstraction will also be useful to support
> offloading P2P operations to the device, e.g.
> periodic listen for discoverability.
>
> Currently, the driver is responsible for assigning
> a MAC address to the P2P Device, but this could be
> changed by allowing a MAC address to be given to
> the NEW_INTERFACE command.
>
> As it has no associated netdev, a P2P Device can
> only be identified by its wdev identifier but the
> previous patches allowed using the wdev identifier
> in various APIs, e.g. remain-on-channel.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
[...]


> @@ -230,9 +230,24 @@ static int cfg80211_rfkill_set_block(void *data, bool blocked)
>        rtnl_lock();
>        mutex_lock(&rdev->devlist_mtx);
>
> -       list_for_each_entry(wdev, &rdev->wdev_list, list)
> -               if (wdev->netdev)
> +       list_for_each_entry(wdev, &rdev->wdev_list, list) {
> +               if (wdev->netdev) {
>                        dev_close(wdev->netdev);
> +                       continue;
> +               }
> +               /* otherwise, check iftype */
> +               switch (wdev->iftype) {
> +               case NL80211_IFTYPE_P2P_DEVICE:
> +                       if (!wdev->p2p_started)
> +                               break;
> +                       rdev->ops->stop_p2p_device(&rdev->wiphy, wdev);
> +                       wdev->p2p_started = false;
> +                       rdev->opencount--;
> +                       break;
> +               default:
> +                       break;
> +               }
> +       }
>
>        mutex_unlock(&rdev->devlist_mtx);
>        rtnl_unlock();


> +void cfg80211_unregister_wdev(struct wireless_dev *wdev)
> +{
> +       struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
> +
> +       ASSERT_RTNL();
> +
> +       if (WARN_ON(wdev->netdev))
> +               return;
> +
> +       mutex_lock(&rdev->devlist_mtx);
> +       list_del_rcu(&wdev->list);
> +       rdev->devlist_generation++;
> +
> +       switch (wdev->iftype) {
> +       case NL80211_IFTYPE_P2P_DEVICE:
> +               if (wdev->p2p_started) {
> +                       wdev->p2p_started = false;
> +                       rdev->opencount--;
> +               }
any reason not calling stop_p2p_device() here as well?


> +static int nl80211_start_p2p_device(struct sk_buff *skb, struct genl_info *info)
> +{
> +       struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +       struct wireless_dev *wdev = info->user_ptr[1];
> +       int err;
> +
> +       if (!rdev->ops->start_p2p_device)
> +               return -EOPNOTSUPP;
> +
> +       if (wdev->iftype != NL80211_IFTYPE_P2P_DEVICE)
> +               return -EOPNOTSUPP;
> +
> +       if (!(rdev->wiphy.interface_modes & BIT(NL80211_IFTYPE_P2P_DEVICE)))
> +               return -EOPNOTSUPP;
> +
nl80211_new_interface() should already check it.

Eliad.
