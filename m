Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60432 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab2EOOR6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 10:17:58 -0400
Date: Tue, 15 May 2012 10:00:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Soumik DAS <soumik.das@stericsson.com>
Cc: "linux-wireless (linux-wireless@vger.kernel.org)"
	<linux-wireless@vger.kernel.org>,
	"Johannes Berg (johannes@sipsolutions.net)"
	<johannes@sipsolutions.net>,
	"Kalle Valo (kvalo@adurom.com)" <kvalo@adurom.com>
Subject: Re: [PATCH] mac80211: Remove race condition in sending null frame to
 check AP status
Message-ID: <20120515140053.GD24572@tuxdriver.com> (sfid-20120515_161802_285127_15F64AF5)
References: <2E48302EED53D048A7BA72B0A307FB511FB906BC9A@EXDCVYMBSTM005.EQ1STM.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2E48302EED53D048A7BA72B0A307FB511FB906BC9A@EXDCVYMBSTM005.EQ1STM.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 15, 2012 at 08:04:32AM +0200, Soumik DAS wrote:
> mac80211 tries to verify the existence of the current AP by
> probing or sending a NULL frame in function
> ieee80211_mgd_probe_ap_send. It 1st sends a null frame to the AP,
> increments probe_send_count and waits for the ACK to the NULL
> frame for a finite duration of time. At times, it happens that
> by the time mac80211 gets to increment probe_send_count, the ACK
> for the NULL frame transmitted has already been processed. This
> leads to a race condition where mac80211 times out waiting for
> the ACK for the NULL frame causing unnecessary disconnection with
> the AP.
> 
> Signed-off-by: Soumik Das <soumik.das@stericsson.com>
> ---
> net/mac80211/mlme.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c index dbd4bd9..a1213e4 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1522,6 +1522,7 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
>     * anymore. The timeout will be reset if the frame is ACKed by
>     * the AP.
>     */
> +    ifmgd->probe_send_count++;
>     if (sdata->local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
>         ifmgd->nullfunc_failed = false;
>         ieee80211_send_nullfunc(sdata->local, sdata, 0); @@ -1538,7 +1539,6 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
>                     0, (u32) -1, true, false);
>     }
> 
> -    ifmgd->probe_send_count++;
>     ifmgd->probe_timeout = jiffies + msecs_to_jiffies(probe_wait_ms);
>     run_again(ifmgd, ifmgd->probe_timeout);
>     if (sdata->local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)
> --
> 1.7.5.4
> 

Looks like whitespace damage...?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
