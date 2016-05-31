Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59182 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358AbcEaNhJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 09:37:09 -0400
Date: Tue, 31 May 2016 19:07:00 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: Fix 10.4 extended peer stats update
Message-ID: <20160531133700.GB3146@atheros-ThinkPad-T61> (sfid-20160531_153721_803725_E4868E35)
References: <1464339926-12136-1-git-send-email-mohammed@qca.qualcomm.com>
 <87vb1ucten.fsf@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87vb1ucten.fsf@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

thanks for the review


On Tue, May 31, 2016 at 12:18:49PM +0000, Valo, Kalle wrote:
> Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:
> 
> > From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> >
> > 10.4 'extended peer stats' will be not be appended with normal peer stats
> > data and they shall be coming in separate chunks. Fix this by maintaining
> > a separate linked list 'extender peer stats' for 10.4 and update
> > rx_duration for per station statistics. Also parse through beacon filter
> > (if enabled), to make sure we parse the extended peer stats properly.
> > This issue was exposed when more than one client is connected and
> > extended peer stats for 10.4 is enabled
> >
> > The order for the stats is as below
> > S - standard peer stats, E- extended peer stats, B - beacon filter stats
> >
> > {S1, S2, S3..} -> {B1, B2, B3..}(if available) -> {E1, E2, E3..}
> >
> > Fixes: f9575793d44c ("ath10k: enable parsing per station rx duration for 10.4")
> > Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> [...]
> 
> > +void ath10k_sta_update_rx_duration(struct ath10k *ar,
> > +				   struct ath10k_fw_stats *stats)
> > +{
> > +	struct ath10k_fw_file *fw_file = &ar->normal_mode_fw.fw_file;
> > +
> > +	if (fw_file->wmi_op_version < ATH10K_FW_WMI_OP_VERSION_10_4)
> > +		ath10k_sta_update_stats_rx_duration(ar, &stats->peers);
> > +	else
> > +		ath10k_sta_update_extd_stats_rx_duration(ar,
> > +							 &stats->peers_extd);
> > +}
> 
> _Ideally_ wmi_op_version should be used only in ath10k_wmi_attach() and
> nowhere else. Isn't there any other way to detect this scenario? For
> example, what if you store stats_id to struct ath10k_fw_stats and do
> something like this:
> 
> if (stats->stats_id & WMI_10_4_STAT_PEER_EXTD)
> 	ath10k_sta_update_extd_stats_rx_duration(ar,
> 						 &stats->peers_extd);
> else
> 	ath10k_sta_update_stats_rx_duration(ar, &stats->peers);
> 
> Would that work?

[shafi] I am also thinking to re-use (ar->fw_stats_req_mask & WMI_10_4_STAT_PEER_EXTD)
it might work, but will it conflict vdev stats WMI_STAT_VDEV (though its not currently
supported for 10.2 ) let me know your thoughts about this, seems extended stats
was implemented for 10.4 wmi version so i made it explicit

> 
> -- 
> Kalle Valo--
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
