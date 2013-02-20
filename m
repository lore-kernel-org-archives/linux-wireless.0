Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:49873 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933799Ab3BTGXs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 01:23:48 -0500
Received: by mail-wg0-f49.google.com with SMTP id 15so5993729wgd.28
        for <linux-wireless@vger.kernel.org>; Tue, 19 Feb 2013 22:23:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1361326267-16847-1-git-send-email-greearb@candelatech.com>
References: <1361326267-16847-1-git-send-email-greearb@candelatech.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 20 Feb 2013 17:23:26 +1100
Message-ID: <CAGRGNgVY+v9ko0MicEp5ozjrv38TG87sTw78SZhLLEqaK=XQ8Q@mail.gmail.com> (sfid-20130220_072352_487552_078AC10A)
Subject: Re: [PATCH] mac80211: Clean up work-queues on disassociation.
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

On Wed, Feb 20, 2013 at 1:11 PM,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> The monitor_work and beacon_connection_loss_work items were
> not being canceled on disassociation (and not on deletion
> either).  This leads to work-items trying to run after memory
> has been deleted.
>
> I could not find a cleaner way to do this because the
> cancel_work_sync for these items must be done outside
> of the ifmgd->mtx.
>
> In addition, re-order the quiesce code so that timers are
> always stopped before work-items are flushed.  This was
> not the problem I saw, but I think it may still be more
> correct.
>
> This fixes the crashes we see in 3.7.9+.  The crash stack
> trace itself isn't so helpful, but this warning gives
> more useful info:

[snip]

> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>
> NOTE:  Please do not apply this until it is reviewed by Johannes,
> at least.
>
>  net/mac80211/mlme.c |   68 +++++++++++++++++++++++++++++++++++++++++++++-----
>  1 files changed, 61 insertions(+), 7 deletions(-)
>
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 164ecf0..5a65144 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2954,19 +2978,15 @@ void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata)
>
>         cancel_work_sync(&ifmgd->request_smps_work);
>
> +       sdata_err(sdata, "Cancel-work-sync monitor_work, sta_quiesce.\n");

Debug code?

>         cancel_work_sync(&ifmgd->monitor_work);
>         cancel_work_sync(&ifmgd->beacon_connection_loss_work);
>         cancel_work_sync(&ifmgd->csa_connection_drop_work);
>         if (del_timer_sync(&ifmgd->timer))
>                 set_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running);
>
> -       cancel_work_sync(&ifmgd->chswitch_work);
>         if (del_timer_sync(&ifmgd->chswitch_timer))
>                 set_bit(TMR_RUNNING_CHANSW, &ifmgd->timers_running);
> -
> -       /* these will just be re-established on connection */
> -       del_timer_sync(&ifmgd->conn_mon_timer);
> -       del_timer_sync(&ifmgd->bcn_mon_timer);
>  }
>
>  void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
> @@ -3262,6 +3282,8 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
>         struct ieee80211_mgd_auth_data *auth_data;
>         u16 auth_alg;
>         int err;
> +       bool maybe_cancel_work = false;
> +       bool hit_err_clear = false;

You could replace these with a single variable.

>
>         /* prepare auth data structure */
>
> @@ -3319,8 +3341,10 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
>         /* prep auth_data so we don't go into idle on disassoc */
>         ifmgd->auth_data = auth_data;
>
> -       if (ifmgd->associated)
> +       if (ifmgd->associated) {
> +               maybe_cancel_work = true;
>                 ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
> +       }
>
>         sdata_info(sdata, "authenticate with %pM\n", req->bss->bssid);
>
> @@ -3340,6 +3364,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
>         goto out_unlock;
>
>   err_clear:
> +       hit_err_clear = true;
>         memset(ifmgd->bssid, 0, ETH_ALEN);
>         ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
>         ifmgd->auth_data = NULL;
> @@ -3348,6 +3373,12 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
>   out_unlock:
>         mutex_unlock(&ifmgd->mtx);
>
> +       if (maybe_cancel_work && hit_err_clear) {
> +               /* Have to do this outside the ifmgd->mtx lock. */
> +               cancel_work_sync(&ifmgd->monitor_work);
> +               cancel_work_sync(&ifmgd->beacon_connection_loss_work);
> +       }
> +
>         return err;
>  }
>
> @@ -3361,6 +3392,8 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
>         struct ieee80211_supported_band *sband;
>         const u8 *ssidie, *ht_ie;
>         int i, err;
> +       bool maybe_cancel_work = false;
> +       bool hit_err_state = false;

ditto.

>
>         ssidie = ieee80211_bss_get_ie(req->bss, WLAN_EID_SSID);
>         if (!ssidie)
> @@ -3372,8 +3405,10 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
>
>         mutex_lock(&ifmgd->mtx);
>
> -       if (ifmgd->associated)
> +       if (ifmgd->associated) {
> +               maybe_cancel_work = true;
>                 ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
> +       }
>
>         if (ifmgd->auth_data && !ifmgd->auth_data->done) {
>                 err = -EBUSY;
> @@ -3555,9 +3590,16 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
>         ifmgd->assoc_data = NULL;
>   err_free:
>         kfree(assoc_data);
> +       hit_err_state = true;
>   out:
>         mutex_unlock(&ifmgd->mtx);
>
> +       if (maybe_cancel_work && hit_err_state) {
> +               /* Have to do this outside the ifmgd->mtx lock. */
> +               cancel_work_sync(&ifmgd->monitor_work);
> +               cancel_work_sync(&ifmgd->beacon_connection_loss_work);
> +       }
> +
>         return err;
>  }
>

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
