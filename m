Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57236 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0EYIKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 May 2010 04:10:55 -0400
Subject: Re: Path for fixed channel issue in aircrack-ng suite
From: Johannes Berg <johannes@sipsolutions.net>
To: Joker Joker <jokesareonyou@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTinAnMwY0ZCetUmUbuhsp3rB360xvlaGM5ifdFHz@mail.gmail.com>
References: <AANLkTinAnMwY0ZCetUmUbuhsp3rB360xvlaGM5ifdFHz@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 May 2010 10:11:11 +0200
Message-ID: <1274775071.3635.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-05-25 at 01:07 -0400, Joker Joker wrote:
> Below is a patch to fix monitor mode channel issue for aircrack-ng suit
> (fixed channel mon0: -1)
> 
> diff --git a/net/wireless/chan.c b/net/wireless/chan.c
> index d92d088..93f6c19 100644
> --- a/net/wireless/chan.c
> +++ b/net/wireless/chan.c
> @@ -48,6 +48,7 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
>                       enum nl80211_channel_type channel_type)
>  {
>         struct ieee80211_channel *chan;
> +       struct wireless_dev *old_wdev = wdev;
>         int result;
> 
>         if (wdev->iftype == NL80211_IFTYPE_MONITOR)
> @@ -73,8 +74,8 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
>         if (result)
>                 return result;
> 
> -       if (wdev)
> -               wdev->channel = chan;
> +       wdev = old_wdev;
> +       wdev->channel = chan;

NACK. That will crash when there really is no interface being passed in.

johannes

