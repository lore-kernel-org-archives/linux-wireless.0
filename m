Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:34029 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2KGNvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 08:51:09 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so1610214oag.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Nov 2012 05:51:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1352294684-19266-4-git-send-email-johannes@sipsolutions.net>
References: <1352294684-19266-1-git-send-email-johannes@sipsolutions.net>
	<1352294684-19266-4-git-send-email-johannes@sipsolutions.net>
Date: Wed, 7 Nov 2012 15:51:08 +0200
Message-ID: <CAB3XZEd+HYmH5vROd0n2YhBz=LYRDtZjtqTcGn=Vn5U9Fu2qrQ@mail.gmail.com> (sfid-20121107_145121_500916_5A14A715)
Subject: Re: [PATCH 3/3] mac80211: reassign channel contexts before stations
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 7, 2012 at 3:24 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Since channel contexts are usually present before
> stations can be added to an interface, reassign
> before stations them in reconfiguration as well.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

>         /* Finally also reconfigure all the BSS information */
>         list_for_each_entry(sdata, &local->interfaces, list) {
> -               struct ieee80211_chanctx_conf *ctx_conf;
>                 u32 changed;
>
> -               if (!ieee80211_sdata_running(sdata))
> -                       continue;
> -
i think you want to copy it rather than move it.

Eliad.
