Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36783 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbYKJUOq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 15:14:46 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 10 Nov 2008 12:14:46 -0800
Date: Mon, 10 Nov 2008 12:14:44 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Kalle Valo <kalle.valo@nokia.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 2/2] mac80211: implement dynamic power save
Message-ID: <20081110201444.GI6918@tesla> (sfid-20081110_211451_516334_3EF91993)
References: <1226245439-30329-1-git-send-email-kalle.valo@nokia.com> <1226245439-30329-3-git-send-email-kalle.valo@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1226245439-30329-3-git-send-email-kalle.valo@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 09, 2008 at 07:43:59AM -0800, Kalle Valo wrote:
> Enable power save only after an idle transmit timeout. The timeout can
> be enabled with:
> 
> iwconfig wlan0 power timeout 500m
> 
> Thanks to Johannes Berg for the help with the design.
> 
> Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
> ---
>  net/mac80211/ieee80211_i.h |    9 +++++++++
>  net/mac80211/main.c        |    5 +++++
>  net/mac80211/mlme.c        |   43 +++++++++++++++++++++++++++++++++++++++++--
>  net/mac80211/tx.c          |   18 ++++++++++++++++++
>  net/mac80211/wext.c        |    8 ++++++--
>  5 files changed, 79 insertions(+), 4 deletions(-)
> 
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 3f25955..ab0e2df 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -688,7 +688,12 @@ struct ieee80211_local {
>                                 */
>         int wifi_wme_noack_test;
>         unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
> +
>         bool powersave;
> +       int dynamic_ps_timeout;
> +       struct work_struct ps_enable_work;
> +       struct work_struct ps_disable_work;
> +       struct timer_list dynamic_ps_timer;
> 
>  #ifdef CONFIG_MAC80211_DEBUGFS
>         struct local_debugfsdentries {
> @@ -973,6 +978,10 @@ int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freq);
>  u64 ieee80211_mandatory_rates(struct ieee80211_local *local,
>                               enum ieee80211_band band);
> 
> +void ieee80211_ps_enable_work(struct work_struct *work);
> +void ieee80211_ps_disable_work(struct work_struct *work);

Should these also be prefixed with _dynamic ? May confuse other people
working on regular ps mode I think.

Also can you elaborate a bit in the patch/log as to what dynamic power save
concept is, what drivers who implement it are expected to do as well?

Thanks,

  Luis
