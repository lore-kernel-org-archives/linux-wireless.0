Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64791 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab2KHPgN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 10:36:13 -0500
Received: by mail-ob0-f174.google.com with SMTP id uo13so2924771obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2012 07:36:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1352385113-21671-1-git-send-email-johannes@sipsolutions.net>
References: <1352385113-21671-1-git-send-email-johannes@sipsolutions.net>
Date: Thu, 8 Nov 2012 17:36:12 +0200
Message-ID: <CAB3XZEdBFZ+ztESgKwprLmJH+5F=x3z66trn_QRq7WJCdcsz1g@mail.gmail.com> (sfid-20121108_163627_061793_6B817A61)
Subject: Re: [PATCH] mac80211: add debugfs file for HW queues
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 8, 2012 at 4:31 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Add a debugfs file showing which HW queues were
> allocated to a virtual interface, including the
> CAB queue for AP interfaces.
>
> Change-Id: I486924e961b6ad6785a79db09620919ee644e703
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/debugfs_netdev.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
> index 3393ad5..c3f089a 100644
> --- a/net/mac80211/debugfs_netdev.c
> +++ b/net/mac80211/debugfs_netdev.c
> @@ -169,6 +169,26 @@ IEEE80211_IF_FILE(flags, flags, HEX);
>  IEEE80211_IF_FILE(state, state, LHEX);
>  IEEE80211_IF_FILE(channel_type, vif.bss_conf.channel_type, DEC);
>
> +static ssize_t
> +ieee80211_if_fmt_hw_queues(const struct ieee80211_sub_if_data *sdata,
> +                          char *buf, int buflen)
> +{
> +       int len;
> +
> +       len = scnprintf(buf, buflen, "AC queues: VO:%d VI:%d BE:%d BK:%d\n",
> +                       sdata->vif.hw_queue[IEEE80211_AC_VO],
> +                       sdata->vif.hw_queue[IEEE80211_AC_VI],
> +                       sdata->vif.hw_queue[IEEE80211_AC_BE],
> +                       sdata->vif.hw_queue[IEEE80211_AC_BK]);
> +
> +       if (sdata->vif.type == NL80211_IFTYPE_AP && len < buflen)
> +               len += scnprintf(buf + len, buflen - len, "cab queue: %d\n",
> +                                sdata->vif.cab_queue);
> +
the (len < buflen) condition is redundant (scnprintf returns the
number of chars written not including the trailing NULL, so it will
always be < buflen)

Eliad.
