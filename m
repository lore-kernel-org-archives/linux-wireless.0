Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44886 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab2LMXc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 18:32:26 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so4933388ieb.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 15:32:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355439573-13206-6-git-send-email-johannes@sipsolutions.net>
References: <1355439573-13206-1-git-send-email-johannes@sipsolutions.net>
	<1355439573-13206-6-git-send-email-johannes@sipsolutions.net>
Date: Fri, 14 Dec 2012 01:32:26 +0200
Message-ID: <CAB3XZEcz-qywVdb5OFG38Kdk8Vue4bS8zxAfuKs_FxFGaisd9w@mail.gmail.com> (sfid-20121214_003230_598657_8DD463F9)
Subject: Re: [PATCH 5/5] mac80211: optimise roaming time again
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 14, 2012 at 12:59 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> The last fixes re-added the RCU synchronize penalty
> on roaming to fix the races. Split up sta_info_flush()
> now to get rid of that again, and let managed mode
> (and only it) delay the actual destruction.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
The patchset looks good. thanks for fixing it :)

> +/**
> + * sta_info_flush - flush matching STA entries from the STA table
> + *
> + * Returns the number of removed STA entries.
> + *
> + * @sdata: sdata to remove all stations from
> + */
> +static inline int sta_info_flush(struct ieee80211_sub_if_data *sdata)
> +{
> +       int ret = sta_info_flush_defer(sdata);
> +
> +       if (ret)
> +               sta_info_flush_cleanup(sdata);
> +
> +       return ret;
> +}
> +

but i think this is wrong - there might already be stations in the cleanup list.
you should always call sta_info_flush_cleanup.

Eliad.
