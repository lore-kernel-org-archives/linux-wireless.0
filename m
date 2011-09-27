Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47507 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab1I0UvU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 16:51:20 -0400
Received: by qyk30 with SMTP id 30so1500290qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2011 13:51:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110922154849.648785480@sipsolutions.net>
References: <20110922154726.521122680@sipsolutions.net> <20110922154849.648785480@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 27 Sep 2011 13:51:00 -0700
Message-ID: <CAB=NE6Wi1EJtyW=4kCNTgdhjzzgTMT3N7xhgKu+AWd9cphcD5Q@mail.gmail.com> (sfid-20110927_225124_184480_2A5CA045)
Subject: Re: [RFC 04/15] mac80211: split PS buffers into ACs
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 22, 2011 at 8:47 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>  void sta_info_recalc_tim(struct sta_info *sta)
>  {
>        struct ieee80211_local *local = sta->local;
>        struct ieee80211_if_ap *bss = sta->sdata->bss;
>        unsigned long flags;
> -       bool have_data;
> +       bool indicate_tim = false;
> +       u8 ignore_for_tim = sta->sta.uapsd_queues;
> +       int ac;
>
>        /* No need to do anything if the driver does all */
>        if (local->hw.flags & IEEE80211_HW_AP_LINK_PS)
>                return;
>
> -       have_data = test_sta_flags(sta, WLAN_STA_PS_DRIVER_BUF) ||
> -                   !skb_queue_empty(&sta->tx_filtered) ||
> -                   !skb_queue_empty(&sta->ps_tx_buf);
> +       /*
> +        * If all ACs are delivery-enabled then we should build
> +        * the TIM bit for all ACs anyway; if only some are then
> +        * we ignore those and build the TIM bit using only the
> +        * non-enabled ones.
> +        */

As per the documentation uapsd_queues is the "bitmap of queues
configured for uapsd". As I read this we are ignoring setting the TIM
for the STA if an AC queue was marked as uapsd-enabled but had
buffered frames for it, so we'd only set the TIM if we had at least
one AC queue that did not have uapsd enabled and had buffered frames
pending. Is that accurate?

  Luis
