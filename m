Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:58945 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbbAODOv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 22:14:51 -0500
Received: by mail-lb0-f179.google.com with SMTP id z11so11199040lbi.10
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 19:14:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1421202189-4020-1-git-send-email-masashi.honma@gmail.com>
References: <1421202189-4020-1-git-send-email-masashi.honma@gmail.com>
Date: Wed, 14 Jan 2015 22:14:49 -0500
Message-ID: <CAEKwDSDPTiZH1NO8Hi-bdPp=25yARr1iUFK7ntnnS6Ae05ULaA@mail.gmail.com> (sfid-20150115_041457_567058_92504709)
Subject: Re: [PATCH] mesh: Skip STA expiration on user_mpm mode
From: Bob Copeland <me@bobcopeland.com>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 13, 2015 at 9:23 PM, Masashi Honma <masashi.honma@gmail.com> wrote:
> The mesh STA expiration processing works even if user_mpm mode. This causes
> unexpected STA disconnection.
>
> This patch skips STA expiration processing on user_mpm mode.
>
> Signed-off-by: Masashi Honma <masashi.honma@gmail.com>

>
> -       ieee80211_sta_expire(sdata, ifmsh->mshcfg.plink_timeout * HZ);
> +       if (!ifmsh->user_mpm)
> +               ieee80211_sta_expire(sdata, ifmsh->mshcfg.plink_timeout * HZ);

I took a look at what authsae is doing, and it looks like it's just
prepared to handle the NL80211_CMD_DEL_STATION events generated from
cfg80211_del_sta() -- is there a reason that couldn't work for wpa_s
too?  Then you'd only need the patch to configure that timeout on the
client, and you can simplify it by not caring about user_mpm.

-- 
Bob Copeland %% www.bobcopeland.com
