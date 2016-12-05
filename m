Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:36781 "EHLO
        mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751100AbcLEIWU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 03:22:20 -0500
Received: by mail-qk0-f179.google.com with SMTP id n21so338614524qka.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2016 00:22:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1480645800-2148-1-git-send-email-greearb@candelatech.com>
References: <1480645800-2148-1-git-send-email-greearb@candelatech.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 5 Dec 2016 09:13:21 +0100
Message-ID: <CA+BoTQkEaC-ZSbeK=JB=q+ucF1PWcEQXkJEp6JYv4pfOf35cHg@mail.gmail.com> (sfid-20161205_092619_855272_0854B225)
Subject: Re: [PATCH 1/2] mac80211: do not iterate active interfaces when in re-configure
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 December 2016 at 03:29,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> This appears to fix a problem where ath10k firmware would crash,
> mac80211 would start re-adding interfaces to the driver, but the
> iterate-active-interfaces logic would then try to use the half-built
> interfaces.  With a bit of extra debug to catch the problem, the
> ath10k crash looks like this:
>
> ath10k_pci 0000:05:00.0: Initializing arvif: ffff8801ce97e320 on vif: fff=
f8801ce97e1d8
>
> [the print that happens after arvif->ar is assigned is not shown, so code=
 did not make it that far before
>  the tx-beacon-nowait method was called]
>
> tx-beacon-nowait:  arvif: ffff8801ce97e320  ar:           (null)
[...]
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  net/mac80211/util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 863f2c1..abe1f64 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -705,7 +705,7 @@ static void __iterate_interfaces(struct ieee80211_loc=
al *local,
>                         break;
>                 }
>                 if (!(iter_flags & IEEE80211_IFACE_ITER_RESUME_ALL) &&
> -                   active_only && !(sdata->flags & IEEE80211_SDATA_IN_DR=
IVER))
> +                   (active_only && (local->in_reconfig || !(sdata->flags=
 & IEEE80211_SDATA_IN_DRIVER))))
>                         continue;

Doesn't this effectivelly prevent you from iterating over interfaces
completely during reconfig? As you bring up interfaces you might
need/want to iterate over others to re-adjust your own state.

I'd argue there should be another flag, IEEE80211_SDATA_RESUMING, used
with sdata->flags for resuming so that once it is re-added to the
driver it can be cleared (and therefore properly iterated over).


Micha=C5=82
