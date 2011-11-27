Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34062 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab1K0QMn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 11:12:43 -0500
Received: by wwp14 with SMTP id 14so7293308wwp.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Nov 2011 08:12:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322394800.4044.33.camel@jlt3.sipsolutions.net>
References: <1322378621-14647-1-git-send-email-mar.kolya@gmail.com>
	<1322378621-14647-2-git-send-email-mar.kolya@gmail.com>
	<1322394638.4044.32.camel@jlt3.sipsolutions.net>
	<1322394800.4044.33.camel@jlt3.sipsolutions.net>
Date: Sun, 27 Nov 2011 11:12:41 -0500
Message-ID: <CALGY4fufCM2SvYLFaab1TzSr36b55bguFoZRtYZhLuXGMZLG1w@mail.gmail.com> (sfid-20111127_171249_611578_86751FAA)
Subject: Re: [PATCH v3] mac80211: fix race condition caused by late addBA response
From: Nikolay Martynov <mar.kolya@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Norbert Preining <preining@logic.at>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

2011/11/27 Johannes Berg <johannes@sipsolutions.net>:
> From: Nikolay Martynov <mar.kolya@gmail.com>
>
> If addBA responses comes in just after addba_resp_timer has
> expired mac80211 will still accept it and try to open the
> aggregation session. This causes drivers to be confused and
> in some cases even crash.
>
> This patch fixes the race condition and makes sure that if
> addba_resp_timer has expired addBA response is not longer
> accepted and we do not try to open half-closed session.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
> [some adjustments]
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> v3: adjust message
>
>  net/mac80211/agg-tx.c |   18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
>
> --- a/net/mac80211/agg-tx.c     2011-11-27 12:51:16.000000000 +0100
> +++ b/net/mac80211/agg-tx.c     2011-11-27 12:52:30.000000000 +0100
> @@ -762,11 +762,27 @@ void ieee80211_process_addba_resp(struct
>                goto out;
>        }
>
> -       del_timer(&tid_tx->addba_resp_timer);
> +       del_timer_sync(&tid_tx->addba_resp_timer);
>
>  #ifdef CONFIG_MAC80211_HT_DEBUG
>        printk(KERN_DEBUG "switched off addBA timer for tid %d\n", tid);
>  #endif
> +
> +       /*
> +        * addba_resp_timer may have fired before we got here, and
> +        * caused WANT_STOP to be set. STOPPING should not be set
> +        * as we're under the mutex, but check it anyway.
> +        */
> +       if (test_bit(HT_AGG_STATE_WANT_STOP, &tid_tx->state) ||
> +           test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {

  Just a small comment about comment :).
  If I understand correctly process of stopping tx agg looks as following:
  1) Call to ___ieee80211_stop_tx_ba_session. This removes
HT_AGG_STATE_WANT_STOP (in ht.c) and adds HT_AGG_STATE_STOPPING. It
holds mutex during duration of the call.
  2) Call to ieee80211_stop_tx_ba_cb. This destroys the actual tx_tid.
It holds mutex during duration of the call.

  But between these two calls we have HT_AGG_STATE_STOPPING and no
mutex. I think at this time we can receive addBA resp and that's why I
was checking for HT_AGG_STATE_STOPPING in my original patch.

  I'd appreciate if you could let me know if my understanding is wrong.
  Thanks!

-- 
Truthfully yours,
Martynov Nikolay.
Email: mar.kolya@gmail.com
