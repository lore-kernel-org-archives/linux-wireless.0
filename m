Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41478 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab1FYNiR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2011 09:38:17 -0400
Subject: Re: [PATCH] chan.c: fix chan.c to return channel number when in
 monitor mode and on a fixed channel.
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicholas Hockey <nhockey@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTimfrcrqVxNXj_5qDYYJoz6Exnzw+w@mail.gmail.com> (sfid-20110623_224928_637415_4258C2EA)
References: <BANLkTimfrcrqVxNXj_5qDYYJoz6Exnzw+w@mail.gmail.com>
	 (sfid-20110623_224928_637415_4258C2EA)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 25 Jun 2011 15:38:13 +0200
Message-ID: <1309009093.4317.9.camel@jlt3.sipsolutions.net> (sfid-20110625_153826_090694_FA07806C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-06-23 at 16:49 -0400, Nicholas Hockey wrote:
> (sorry if this is not right, its been nearly 10 years since i
> submitted a kernel patch)

Listing cfg80211 isntead of "chan.c" would have been useful :-)

> Fixes: When monitoring a fixed channel, chan.c does not report what
> channel it is on.
> 
> Signed-off-by: Nicholas Hockey <nhockey@gmail.com>
> ---
> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
> index 17cd0c0..261ee32 100644
> --- a/net/wireless/chan.c
> +++ b/net/wireless/chan.c
> @@ -82,10 +82,12 @@ int cfg80211_set_freq(struct
> cfg80211_registered_device *rdev,
>  {
>         struct ieee80211_channel *chan;
>         int result;
> +    struct wireless_dev *mon_dev = NULL;
> 
> -       if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR)
> +       if (wdev && wdev->iftype == NL80211_IFTYPE_MONITOR) {
> +        mon_dev = wdev;
>                 wdev = NULL;
> -
> +    }
>         if (wdev) {
>                 ASSERT_WDEV_LOCK(wdev);
> 
> @@ -131,5 +133,8 @@ int cfg80211_set_freq(struct
> cfg80211_registered_device *rdev,
>         if (wdev)
>                 wdev->channel = chan;
> 
> +    if (mon_dev)
> +        mon_dev->channel = chan;
> +

This has been discussed numerous times, this change still isn't right
because monitors are slaved to others.

johannes

