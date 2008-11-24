Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:12518 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbYKXNLv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 08:11:51 -0500
Received: by ug-out-1314.google.com with SMTP id 39so732066ugf.37
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 05:11:49 -0800 (PST)
Message-ID: <f76a32050811240511x799fb9cdw9a9870e897e9bd26@mail.gmail.com> (sfid-20081124_141156_370554_897F769A)
Date: Mon, 24 Nov 2008 14:11:49 +0100
From: "Stefan Steuerwald" <salsasepp@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Fwd: p54: testing AP mode: cannot switch to master mode
Cc: "Holger Schurig" <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1227450758.3599.48.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <f76a32050811190306s6a86f46dwc245200069ff8a82@mail.gmail.com>
	 <200811201537.19047.hs4233@mail.mn-solutions.de>
	 <f76a32050811201121r27ba1d82ma788e5a55bfd422b@mail.gmail.com>
	 <200811210838.25977.hs4233@mail.mn-solutions.de>
	 <f76a32050811210037x5958de39g53b174b2d0dfd41b@mail.gmail.com>
	 <1227450758.3599.48.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes,

thank you for providing this patch. Tested, but I'm not sure about the result.
I THINK the frequency of my app-level timeouts is reduced, but I'm not
really sure. In any case it doesn't break anything for me.

I'm investigating this reason for my timeouts:

http://marc.info/?l=linux-wireless&m=122727674810057&w=2

and have better log info to post, will followup there.

Thank you,
  Stefan.



2008/11/23 Johannes Berg <johannes@sipsolutions.net>:
> Can you trhis this patch?
>
> Also, next time please don't filter the captures so much, it made it
> hard to diagnose the problem.
>
> johannes
>
>
> Subject: mac80211: only transition STAs ps->wake on data frames
>
> When a station goes to PS mode to scan, it will then send
> probe requests without the PS bit set. mac80211 will take
> that as indication that the station woke up, but it didn't.
> This patch changes mac80211 to only consider doze->wake
> transitions on data frames to to fix that issue.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/mac80211/rx.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> --- everything.orig/net/mac80211/rx.c   2008-11-23 14:58:21.000000000 +0100
> +++ everything/net/mac80211/rx.c        2008-11-23 14:59:58.000000000 +0100
> @@ -750,9 +750,11 @@ ieee80211_rx_h_sta_process(struct ieee80
>                /* Change STA power saving mode only in the end of a frame
>                 * exchange sequence */
>                if (test_sta_flags(sta, WLAN_STA_PS) &&
> -                   !ieee80211_has_pm(hdr->frame_control))
> -                       rx->sent_ps_buffered += ap_sta_ps_end(sta);
> -               else if (!test_sta_flags(sta, WLAN_STA_PS) &&
> +                   !ieee80211_has_pm(hdr->frame_control)) {
> +                       /* ignore PS bit on non-data frames */
> +                       if (ieee80211_is_data(hdr->frame_control))
> +                               rx->sent_ps_buffered += ap_sta_ps_end(sta);
> +               } else if (!test_sta_flags(sta, WLAN_STA_PS) &&
>                         ieee80211_has_pm(hdr->frame_control))
>                        ap_sta_ps_start(sta);
>        }
>
>
>
