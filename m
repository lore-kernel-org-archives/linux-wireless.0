Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53558 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab2GGWjI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jul 2012 18:39:08 -0400
Received: by obbuo13 with SMTP id uo13so17615127obb.19
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jul 2012 15:39:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341608733-7503-4-git-send-email-johannes@sipsolutions.net>
References: <1341608733-7503-1-git-send-email-johannes@sipsolutions.net>
	<1341608733-7503-4-git-send-email-johannes@sipsolutions.net>
Date: Sun, 8 Jul 2012 01:39:07 +0300
Message-ID: <CAB3XZEdmBi4gb=HMnwXRq4wygoQ6Gi=eTkocTA_NGNZLusWj_Q@mail.gmail.com> (sfid-20120708_003917_834855_5B818BFC)
Subject: Re: [RFC 3/3] mac80211: redesign scan RX
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 7, 2012 at 12:05 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Scan receive is rather inefficient when there are
> multiple virtual interfaces. We iterate all of the
> virtual interfaces and then notify cfg80211 about
> each beacon many times.
>
> Redesign scan RX to happen before everything else.
> Then we can also get rid of IEEE80211_RX_IN_SCAN
> since we don't have to accept frames into the RX
> handlers for scanning or scheduled scanning any
> more. Overall, this simplifies the code.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
[...]

> +       sdata1 = rcu_dereference(local->scan_sdata);
> +       sdata2 = rcu_dereference(local->sched_scan_sdata);
>
> -       if (skb->len < 24)
> -               return RX_CONTINUE;
> +       if (likely(!sdata1 && !sdata2))
> +               return;
>
> -       presp = ieee80211_is_probe_resp(fc);
> -       if (presp) {
> +       if (ieee80211_is_probe_resp(mgmt->frame_control)) {
>                 /* ignore ProbeResp to foreign address */
> -               if (!ether_addr_equal(mgmt->da, sdata->vif.addr))
> -                       return RX_DROP_MONITOR;
> +               if (!ether_addr_equal(mgmt->da, sdata1->vif.addr) &&
> +                   !ether_addr_equal(mgmt->da, sdata2->vif.addr))
> +                       return;

you should check sdata1 and sdata2 before dereferencing them.

other than that, looks good to me.

Eliad.
