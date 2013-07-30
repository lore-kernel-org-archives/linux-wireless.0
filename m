Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:63257 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab3G3Sg4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 14:36:56 -0400
Received: by mail-ob0-f176.google.com with SMTP id v19so12547313obq.7
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jul 2013 11:36:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1374826090-17322-1-git-send-email-johannes@sipsolutions.net>
References: <1374826090-17322-1-git-send-email-johannes@sipsolutions.net>
Date: Tue, 30 Jul 2013 21:36:55 +0300
Message-ID: <CAB3XZEfy_ts00HnEgaLYQqzMhLR2KbZsn1KVH6eOMYUiTSjD-g@mail.gmail.com> (sfid-20130730_203658_499745_F25D9647)
Subject: Re: [PATCH] mac80211: implement critical protocol protection
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

On Fri, Jul 26, 2013 at 11:08 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>
> This new API add in cfg80211 wasn't implemented in mac80211.
> Advertise the capabilities based on the device's
> implementation (possibly NULL) of crit_prot mac80211 ops.
>
> This callback will be called by cfg80211 when hinted by
> userspace that a critical protocol is happening, e.g. it can
> be EAPOL, DHCP.
>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

> +static void ieee80211_crit_prot_timeout(struct work_struct *wk)
> +{
> +       struct ieee80211_sub_if_data *sdata;
> +
> +       sdata = container_of(wk, struct ieee80211_sub_if_data,
> +                            crit_prot_end_wk.work);
> +
> +       drv_crit_proto(sdata->local, sdata, NL80211_CRIT_PROTO_UNSPEC, false);
> +}
> +

i think you should call cfg80211_crit_proto_stopped()?
and even better, maybe provide some callback to let/require the driver
indicate completion (and implicitly call cfg80211_crit_proto_stopped()
there).

Eliad.
