Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46826 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab0H2TzY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Aug 2010 15:55:24 -0400
Received: by gwj17 with SMTP id 17so1748760gwj.19
        for <linux-wireless@vger.kernel.org>; Sun, 29 Aug 2010 12:55:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1282979590-31113-3-git-send-email-lrodriguez@atheros.com>
References: <1282979590-31113-1-git-send-email-lrodriguez@atheros.com> <1282979590-31113-3-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sun, 29 Aug 2010 12:55:03 -0700
Message-ID: <AANLkTinzeS=2rc5YYpOcQ6L6CoDN4jq2--zKS=NfDbEv@mail.gmail.com>
Subject: Re: [RFC 2/3] mac80211: allow drivers to specify sw scan wait constraints
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, amod.bodas@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 28, 2010 at 12:13 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:

> @@ -520,23 +521,38 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
>                /*
>                 * we're on the operating channel currently, let's
>                 * leave that channel now to scan another one
> +                * unless the driver has other wait time constraints
>                 */
> -               local->next_scan_state = SCAN_LEAVE_OPER_CHANNEL;
> +               if (drv_sw_scan_wait_constraints(local) &&
> +                   local->scan_oper_chan_waits < 2) {
> +                       local->next_scan_state = SCAN_DECISION;
> +                       local->scan_oper_chan_waits++;
> +               } else {
> +                       local->next_scan_state = SCAN_LEAVE_OPER_CHANNEL;
> +                       local->scan_oper_chan_waits = 0;
> +               }
>        }
>
> -       *next_delay = 0;
> +       if (local->next_scan_state == SCAN_DECISION)
> +               *next_delay = HZ / 5;

This needs some good review as well. As its implemented here we'll
essentially stop all TX except null data frames and probe requests as
local->scanning is set by SCAN_SW_SCANNING through
__ieee80211_start_scan(). One possible alternative is to do the
drv_sw_scan_wait_constraints() check prior to calling the sw scan and
fail the __ieee80211_start_scan() call if we need to wait. I didn't
think this was the best thing to do at first though because the user
will just get a scan busy error from userspace. It seemed more
rational to queue the request in since we just have to wait until the
driver clears its wait constraints -- or we wait too long (just a loop
counter now on the operating channel).

> @@ -544,8 +560,26 @@ static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *loca
>        else
>                *next_delay = HZ / 10;
>
> +       /*
> +        * If we're not getting ACKs for our nullfuncs we're likely in bad
> +        * shape so we should not care about missed data as we can't even
> +        * hear the AP. We want to help roam away if we can so just go
> +        * ahead and scan. Try getting the ACK just 3 times.
> +        */
> +       r = drv_sw_scan_wait_constraints(local);
> +       if (r == -EAGAIN) {
> +               local->scan_nullfunc_retries++;
> +               *next_delay = HZ / 10;

After some review I believe we need to set here
local->offchannel_ps_enabled otherwise we won't resend the nullfunc.
Also we may want to reconsider the amount of time we wait for a resend
as in that duration we will be only letting through nullfuncs and
probe requests.

  Luis
