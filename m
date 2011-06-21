Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63271 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1FUEzO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 00:55:14 -0400
Received: by gwaa18 with SMTP id a18so620415gwa.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jun 2011 21:55:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1308425533-20854-1-git-send-email-arik@wizery.com>
References: <1308425533-20854-1-git-send-email-arik@wizery.com>
Date: Tue, 21 Jun 2011 10:25:13 +0530
Message-ID: <BANLkTikB3egX4YikC1JdgEr-E-7Dm13_CA@mail.gmail.com> (sfid-20110621_065518_510146_474A03D3)
Subject: Re: [RFC] mac80211: dynamic PS - don't enter PS when TX frames are pending
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 19, 2011 at 1:02 AM, Arik Nemtsov <arik@wizery.com> wrote:
> Use the tx_frames_pending() driver callback to determine if Tx frames are
> pending for its internal queues. If so postpone the dynamic PS timeout
> to avoid interrupting Tx traffic.
>
> The commit e8306f989483e4b97a8b37dd268de6c8c6f35e75 enabled this
> behavior for drivers with IEEE80211_HW_PS_NULLFUNC_STACK. We enable this
> for all drivers supporting dynamic PS.
>
> This patch helps improve performance in noisy environments.
>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
>  net/mac80211/mlme.c |   22 +++++++++++++---------
>  1 files changed, 13 insertions(+), 9 deletions(-)
>
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index a41f234..3a1699b 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -758,19 +758,23 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
>        if (local->hw.conf.flags & IEEE80211_CONF_PS)
>                return;
>
> +       /* don't enter PS if dynamic PS is enabled and TX frames are pending */
> +       if (local->hw.conf.dynamic_ps_timeout > 0 &&
> +           !local->disable_dynamic_ps && drv_tx_frames_pending(local)) {

netif_tx_stop_all_queues has to be called before checking
frames_pending(), so that we can make sure no data is transmitted in
the time between checking frames_pending and transmitting null data
frames. If it is not done, this might cause some power save states
mismatch between the AP and the station in some corner cases.

Vivek.
