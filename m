Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:61556 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbYLSGSC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 01:18:02 -0500
Received: by bwz14 with SMTP id 14so3075509bwz.13
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2008 22:17:59 -0800 (PST)
Message-ID: <8e92b4100812182217q6f8e6014s3f28ab79c5bc2ba3@mail.gmail.com> (sfid-20081219_071826_616352_BF25C29B)
Date: Fri, 19 Dec 2008 11:47:59 +0530
From: "Vivek Natarajan" <vivek.natraj@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: [PATCH v6 3/3] mac80211: implement dynamic power save
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081218213527.7248.65697.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081218213306.7248.64398.stgit@tikku>
	 <20081218213527.7248.65697.stgit@tikku>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 19, 2008 at 3:05 AM, Kalle Valo <kalle.valo@nokia.com> wrote:
> @@ -872,6 +878,9 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
>        local->oper_channel_type = NL80211_CHAN_NO_HT;
>        config_changed |= IEEE80211_CONF_CHANGE_HT;
>
> +       del_timer_sync(&local->dynamic_ps_timer);
> +       cancel_work_sync(&local->dynamic_ps_enable_work);

In addition, shouldn't we have this 'cancel_work'  in ieee80211_stop
or where ever in the stop/detach path since the ps timer may be
triggered even after the interface is brought down.

I need your thoughts on having null frame being sent from mac80211(
the RFC I submitted earlier).
Do you feel a state machine is necessary to go to power save? ( like
awake, sleep, pending_sleep if the AP hasn't acked the null frame with
a timer or a work queue to send null frame periodically in the pending
state). Or altogether you want that to be part of the driver and not
in mac80211?

Thanks,
Vivek.
