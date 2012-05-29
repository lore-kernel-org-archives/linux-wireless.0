Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39971 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab2E2ONY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 10:13:24 -0400
Received: by obbtb18 with SMTP id tb18so6918308obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 May 2012 07:13:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338203942-5667-8-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
	<1338203942-5667-8-git-send-email-michal.kazior@tieto.com>
Date: Tue, 29 May 2012 17:13:23 +0300
Message-ID: <CAB3XZEe97MkqeugFrqdjVUOhE0cifGvikwNFnB20EHokPEc5Cg@mail.gmail.com> (sfid-20120529_161339_475858_FC6AC685)
Subject: Re: [RFC 07/14] cfg80211: track monitor interfaces count
From: Eliad Peller <eliad@wizery.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Michal,

On Mon, May 28, 2012 at 2:18 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
> Implements .set_monitor_enabled(wiphy, enabled).
>
> Notifies driver upon change of interface layout.
>
> If only monitor interfaces become present it is
> called with 2nd argument being true. If
> non-monitor interface appears then 2nd argument
> is false. Driver is notified only upon change.
>
> This makes it more obvious about the fact that
> cfg80211 supports single monitor channel. Once we
> implement multi-channel we don't want to allow
> setting monitor channel while other interface
> types are running. Otherwise it would be ambiguous
> once we start considering num_different_channels.
>
> Change-Id: Ibd82a70c256c2de584eb541ea2c36663a59f09d4
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
[...]

> @@ -879,6 +895,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
>                break;
>        case NETDEV_DOWN:
>                dev_hold(dev);
> +               cfg80211_update_iface_num(rdev, wdev, -1);
>                queue_work(cfg80211_wq, &wdev->cleanup_work);
>                break;
>        case NETDEV_UP:
> @@ -986,6 +1003,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
>                ret = cfg80211_can_add_interface(rdev, wdev->iftype);
>                if (ret)
>                        return notifier_from_errno(ret);
> +               cfg80211_update_iface_num(rdev, wdev, 1);
>                break;
>        }
>

what about interface type change?

Eliad.
