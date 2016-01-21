Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:52855 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759002AbcAUOBm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 09:01:42 -0500
Date: Thu, 21 Jan 2016 19:31:16 +0530
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 6/7] ath10k: Enable periodic peer stats update
Message-ID: <20160121140112.GA8313@shafi-laptop> (sfid-20160121_150146_037241_6348D3EC)
References: <1452699994-5078-1-git-send-email-mohammed@qca.qualcomm.com>
 <1452699994-5078-7-git-send-email-mohammed@qca.qualcomm.com>
 <87twm7yu7m.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <87twm7yu7m.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 21, 2016 at 02:48:13PM +0200, Kalle Valo wrote:
> Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:
> 
> > From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> >
> > Register for 500ms as periodic peer stats update period,
> > and parameters like rx_duration that needs to be tracked
> > in host can be achieved by this provision, also periodic
> > stats update is the future of fw_stats and shall be extended
> > for pdev / vdev stats irrespecitive PEER_STATS service is enabled
> > or not
> >
> > Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> > ---
> >  drivers/net/wireless/ath/ath10k/mac.c |   12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> > index 2dba57c..fd4b4df 100644
> > --- a/drivers/net/wireless/ath/ath10k/mac.c
> > +++ b/drivers/net/wireless/ath/ath10k/mac.c
> > @@ -4103,6 +4103,18 @@ static int ath10k_start(struct ieee80211_hw *hw)
> >  
> >  	ar->ani_enabled = true;
> >  
> > +	if (test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map)) {
> > +		param = ar->wmi.pdev_param->peer_stats_update_period;
> > +		ret = ath10k_wmi_pdev_set_param(ar, param,
> > +					PEER_DEFAULT_STATS_UPDATE_PERIOD);
> 
> This gives a new checkpatch warning:
> 
> drivers/net/wireless/ath/ath10k/mac.c:4110: Alignment should match open parenthesis
> 
> I fixed that in the pending branch.
>
[shafi] thank you Kalle Valo !

regards,
shafi
