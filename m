Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48502 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab2KSVmP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 16:42:15 -0500
Received: by mail-ie0-f174.google.com with SMTP id k13so7568373iea.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2012 13:42:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353343170-26516-11-git-send-email-eliad@wizery.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com> <1353343170-26516-11-git-send-email-eliad@wizery.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 19 Nov 2012 23:41:59 +0200
Message-ID: <CA+XVXfet9PT9j2TCWsK2O-P3CTn+-6kO-U+OJ=ajvRJim+8LeQ@mail.gmail.com> (sfid-20121119_224222_591338_0D092836)
Subject: Re: [PATCH 10/15] wlcore: initiate ROC/CROC on sta state updates
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 19, 2012 at 6:39 PM, Eliad Peller <eliad@wizery.com> wrote:
> Use the sta_state notifications to ROC when a station
> is about to connect, and CROC respectively on
> authorization (success) / deletion (failure).
>
> Change the wl12xx_update_sta_state() flow to bail out
> only on error, so multiple code blocks could refer
> to the same state.
>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
[...]
>
> +       /* clear ROCs on failure or authorization */
> +       if (is_sta &&
> +           (new_state == IEEE80211_STA_AUTHORIZED ||
> +            new_state == IEEE80211_STA_NOTEXIST)) {
> +               if (test_bit(wlvif->role_id, wl->roc_map))
> +                       wl12xx_croc(wl, wlvif->role_id);
> +       }
> +
> +       if (is_sta &&
> +           old_state == IEEE80211_STA_NOTEXIST &&
> +           new_state == IEEE80211_STA_NONE) {
> +               if (find_first_bit(wl->roc_map,
> +                                  WL12XX_MAX_ROLES) >= WL12XX_MAX_ROLES) {
> +                       WARN_ON(wlvif->role_id == WL12XX_INVALID_ROLE_ID);
> +                       wl12xx_roc(wl, wlvif, wlvif->role_id, wlvif->channel);
> +               }
> +       }

what about AP mode? we don't have an opportunistic ROC there as well
for connecting stations?
