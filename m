Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:63200 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaATPlX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 10:41:23 -0500
Received: by mail-bk0-f42.google.com with SMTP id 6so448471bkj.15
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 07:41:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390227670-19030-6-git-send-email-michal.kazior@tieto.com>
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	<1390227670-19030-6-git-send-email-michal.kazior@tieto.com>
Date: Mon, 20 Jan 2014 16:41:21 +0100
Message-ID: <CA+BoTQmcogdOMxX8TUb=+-UuzYDzR-a7WbpNywtT03kTcV0N2A@mail.gmail.com> (sfid-20140120_164129_803443_751F43FF)
Subject: Re: [PATCH 5/7] mac80211: improve CSA locking
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 January 2014 15:21, Michal Kazior <michal.kazior@tieto.com> wrote:
> The patch improves channel switch related locking
> (STA, IBSS, AP, mesh).
>
> Now read access to sdata->vif.csa_active is
> protected by wdev.mtx and local->mtx so holding
> either is enough for read access but both are
> required for write access. Keep in mind sdata lock
> must be taken before local->mtx. Taking them in
> reverse order creates a deadlock situation.
>
> The only exception is ieee80211_beacon_get_tim()
> but it's safe to leave it as is and it doesn't
> influence mac80211 state in any way.
>
> The patch adds a few lockdep assertions along for
> easier code/locking maintenance.
>
> This also prepares for multi-interface CSA.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>  net/mac80211/cfg.c   | 22 +++++++++++++++++++---
>  net/mac80211/ibss.c  | 18 ++++++++++++++----
>  net/mac80211/iface.c | 28 ++++++++++++++++++++++++++--
>  net/mac80211/mesh.c  | 18 ++++++++++++++++--
>  net/mac80211/mlme.c  | 20 ++++++++++++++------
>  5 files changed, 89 insertions(+), 17 deletions(-)
>

[..]

> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index bfb81cb..d898dc9 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1987,10 +1988,9 @@ static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
>         u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
>
>         sdata_lock(sdata);
> -       if (!ifmgd->associated) {
> -               sdata_unlock(sdata);
> -               return;
> -       }
> +       mutex_lock(&sdata->local->mtx);
> +       if (!ifmgd->associated)
> +               goto out;
>
>         ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
>                                WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,

Just noticed ths deadlocks STA CSA failpath. This deadlocks with
ieee80211_set_disassoc() -> ieee80211_stop_poll() and mutex around
ieee80211_vif_release_channel(). I suppose
s/ieee80211_stop_poll/__ieee80211_stop/ and removing explicit
local->mtx lock around ieee80211_vif_relase_channel() should be
enough.


Michał
