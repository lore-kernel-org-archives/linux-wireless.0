Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50252 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab1J0WoY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 18:44:24 -0400
Received: by ggnb1 with SMTP id b1so3112758ggn.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 Oct 2011 15:44:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1319743973.32221.4.camel@jlt3.sipsolutions.net>
References: <20111021142322.229128720@sipsolutions.net>
	<1319743973.32221.4.camel@jlt3.sipsolutions.net>
Date: Fri, 28 Oct 2011 00:44:23 +0200
Message-ID: <CAB3XZEd1Mg6sYiW4tfaeaoAL8OoRRysKg-U6RU1SucE08hdfJQ@mail.gmail.com> (sfid-20111028_004427_680089_265F142E)
Subject: Re: [RFC v2 13/12] cfg80211/mac80211: allow management TX to not wait
 for ACK
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 27, 2011 at 9:32 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> For probe responses it can be useful to not wait for ACK
> to save airtime, so allow userspace to request not waiting
> with a new nl80211 flag.
>
> Since mac80211 needs to be updated for the new function
> prototype anyway implement it right away -- it's just a
> few lines of code.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
[RFC v2 13/12] ? :)

>        struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>        struct ieee80211_local *local = sdata->local;
> @@ -1944,10 +1944,15 @@ static int ieee80211_mgmt_tx(struct wiph
>        struct sta_info *sta;
>        struct ieee80211_work *wk;
>        const struct ieee80211_mgmt *mgmt = (void *)buf;
> -       u32 flags = IEEE80211_TX_INTFL_NL80211_FRAME_TX |
> -                   IEEE80211_TX_CTL_REQ_TX_STATUS;
> +       u32 flags;
>        bool is_offchan = false;
>
> +       if (!dont_wait_for_ack)
> +               flags = IEEE80211_TX_CTL_NO_ACK;
> +       else
> +               flags = IEEE80211_TX_INTFL_NL80211_FRAME_TX |
> +                       IEEE80211_TX_CTL_REQ_TX_STATUS;
> +

shouldn't it be the other way around? (i.e. set NO_ACK if dont_wait_for_ack)

Eliad.
