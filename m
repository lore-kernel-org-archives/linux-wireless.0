Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46423 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbcFAPMt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2016 11:12:49 -0400
Date: Wed, 1 Jun 2016 20:42:38 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: Fix 10.4 extended peer stats update
Message-ID: <20160601151238.GA9766@atheros-ThinkPad-T61> (sfid-20160601_171253_469370_41F65148)
References: <1464339926-12136-1-git-send-email-mohammed@qca.qualcomm.com>
 <87vb1ucten.fsf@qca.qualcomm.com>
 <20160531133700.GB3146@atheros-ThinkPad-T61>
 <87r3cicaxi.fsf@qca.qualcomm.com>
 <20160601090805.GA7773@atheros-ThinkPad-T61>
 <877fe92he0.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <877fe92he0.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 01, 2016 at 01:00:40PM +0000, Valo, Kalle wrote:
> Mohammed Shafi Shajakhan <mohammed@codeaurora.org> writes:
> 
> > Hello,
> >
> > On Tue, May 31, 2016 at 06:57:52PM +0000, Valo, Kalle wrote:
> >> Mohammed Shafi Shajakhan <mohammed@codeaurora.org> writes:
> >> 
> >> >> > +void ath10k_sta_update_rx_duration(struct ath10k *ar,
> >> >> > +				   struct ath10k_fw_stats *stats)
> >> >> > +{
> >> >> > +	struct ath10k_fw_file *fw_file = &ar->normal_mode_fw.fw_file;
> >> >> > +
> >> >> > +	if (fw_file->wmi_op_version < ATH10K_FW_WMI_OP_VERSION_10_4)
> >> >> > +		ath10k_sta_update_stats_rx_duration(ar, &stats->peers);
> >> >> > +	else
> >> >> > +		ath10k_sta_update_extd_stats_rx_duration(ar,
> >> >> > +							 &stats->peers_extd);
> >> >> > +}
> >> >> 
> >> >> _Ideally_ wmi_op_version should be used only in ath10k_wmi_attach() and
> >> >> nowhere else. Isn't there any other way to detect this scenario? For
> >> >> example, what if you store stats_id to struct ath10k_fw_stats and do
> >> >> something like this:
> >> >> 
> >> >> if (stats->stats_id & WMI_10_4_STAT_PEER_EXTD)
> >> >> 	ath10k_sta_update_extd_stats_rx_duration(ar,
> >> >> 						 &stats->peers_extd);
> >> >> else
> >> >> 	ath10k_sta_update_stats_rx_duration(ar, &stats->peers);
> >> >> 
> >> >> Would that work?
> >> >
> >> > [shafi] I am also thinking to re-use (ar->fw_stats_req_mask & WMI_10_4_STAT_PEER_EXTD)
> >> > it might work, but will it conflict vdev stats WMI_STAT_VDEV (though its not currently
> >> > supported for 10.2 )
> >> 
> >> Can you describe more how they conflict?
> >
> > [shafi] 'WMI_STAT_VDEV' and 'WMI_10_4_STAT_PEER_EXTD' are having the same value
> > BIT(3), though as of now we are only 'WMI_10_4_STAT_PEER_EXTD' for 10.4
> 
> Ah. But that's easy to solve, for example you could use a bool instead.
>
[shafi] sure thanks will do the same, i had a similar change in my mind as well
!
