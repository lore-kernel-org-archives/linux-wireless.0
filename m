Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51679 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab2ADLAd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jan 2012 06:00:33 -0500
Received: by iaeh11 with SMTP id h11so32398311iae.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jan 2012 03:00:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1325672933.3339.17.camel@jlt3.sipsolutions.net>
References: <1325672933.3339.17.camel@jlt3.sipsolutions.net>
Date: Wed, 4 Jan 2012 13:00:32 +0200
Message-ID: <CAB3XZEfABhPBjD4sL369ziK8gRhuvWjHYRzM=Fxp0t=q_Ekzcg@mail.gmail.com> (sfid-20120104_120036_599865_46C531C3)
Subject: Re: [PATCH] mac80211: station state transition error handling
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 4, 2012 at 12:28 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> In the future, when we start notifying drivers,
> state transitions could potentially fail. To make
> it easier to distinguish between programming bugs
> and driver failures:
>  * rename sta_info_move_state() to
>   sta_info_pre_move_state() which can only be
>   called before the station is inserted (and
>   check this with a new station flag).
>  * rename sta_info_move_state_checked() to just
>   plain sta_info_move_state(), as it will be
>   the regular function that can fail for more
>   than just one reason (bad transition or an
>   error from the driver)
>
> This makes the programming model easier -- one of
> the functions can only be called before insertion
> and can't fail, the other can fail.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
[...]

> +       if (err) {
> +               printk(KERN_DEBUG
> +                      "%s: failed to move station %pM to desired state\n",
> +                      sdata->name, sta->sta.addr);
> +               sta_info_destroy_addr(sdata, sta->sta.addr);
> +               mutex_unlock(&sdata->local->sta_mtx);
> +               return false;
> +       }
>
sta_info_destroy_addr takes the mutex by itself, so i guess you should
either release it before or call __sta_info_destroy directly?

Eliad.
