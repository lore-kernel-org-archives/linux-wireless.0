Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:37423 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707AbbDTIZU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2015 04:25:20 -0400
Received: by igblo3 with SMTP id lo3so54163387igb.0
        for <linux-wireless@vger.kernel.org>; Mon, 20 Apr 2015 01:25:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1429283751-5104-1-git-send-email-johannes@sipsolutions.net>
References: <1429283751-5104-1-git-send-email-johannes@sipsolutions.net>
Date: Mon, 20 Apr 2015 11:25:20 +0300
Message-ID: <CAB3XZEeraicUA4Vo4tT93yFn7uN4-FapHOu_5wVutBvtJZP+jQ@mail.gmail.com> (sfid-20150420_102534_975801_8A6FAA58)
Subject: Re: [PATCH 01/11] mac80211: add TX fastpath
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 17, 2015 at 6:15 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> In order to speed up mac80211's TX path, add the "fast-xmit" cache
> that will cache the data frame 802.11 header and other data to be
> able to build the frame more quickly. This cache is rebuilt when
> external triggers imply changes, but a lot of the checks done per
> packet today are simplified away to the check for the cache.
>
> There's also a more detailed description in the code.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
[...]

> +       build.key = rcu_access_pointer(sta->ptk[sta->ptk_idx]);
> +       if (!build.key)
> +               build.key = rcu_access_pointer(sdata->default_unicast_key);
don't you need rcu_dereference here? (and you don't seem to be inside
rcu section here)

Eliad.
