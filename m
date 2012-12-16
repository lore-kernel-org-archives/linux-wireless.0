Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56083 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2LPJCE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2012 04:02:04 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so7936486ieb.19
        for <linux-wireless@vger.kernel.org>; Sun, 16 Dec 2012 01:02:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355486368-14563-4-git-send-email-johannes@sipsolutions.net>
References: <1355486368-14563-1-git-send-email-johannes@sipsolutions.net>
	<1355486368-14563-4-git-send-email-johannes@sipsolutions.net>
Date: Sun, 16 Dec 2012 11:02:03 +0200
Message-ID: <CAB3XZEf5eSQVPPdTz0ZA_X2S51bkHCtkoerJCERFdXUEcwVyDg@mail.gmail.com> (sfid-20121216_100215_530383_B5172593)
Subject: Re: [PATCH 3/3] mac80211: fix channel context iteration
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 14, 2012 at 1:59 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> During suspend/resume channel contexts might be
> iterated even if they haven't been re-added to
> the driver, keep track of this and skip them in
> iteration. Also use the new status for sanity
> checks.
>
> Change-Id: Ibac29191dcc24578d56565c36a543d7a9733be10
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/chan.c        |  3 ++-
>  net/mac80211/driver-ops.h  | 15 ++++++++++++---
>  net/mac80211/ieee80211_i.h |  1 +
>  3 files changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
> index 80e5552..1bfe0a8 100644
> --- a/net/mac80211/chan.c
> +++ b/net/mac80211/chan.c
> @@ -381,7 +381,8 @@ void ieee80211_iter_chan_contexts_atomic(
>
>         rcu_read_lock();
>         list_for_each_entry_rcu(ctx, &local->chanctx_list, list)
> -               iter(hw, &ctx->conf, iter_data);
> +               if (ctx->driver_present)
> +                       iter(hw, &ctx->conf, iter_data);
>         rcu_read_unlock();
>  }
this will behave differently on hw restart (as ctx->driver_present
will remain true).
at least worth documenting :)

Eliad.
