Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24150 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337AbcEaS6A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 14:58:00 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
CC: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: Fix 10.4 extended peer stats update
Date: Tue, 31 May 2016 18:57:52 +0000
Message-ID: <87r3cicaxi.fsf@qca.qualcomm.com> (sfid-20160531_205805_769234_D58DB612)
References: <1464339926-12136-1-git-send-email-mohammed@qca.qualcomm.com>
	<87vb1ucten.fsf@qca.qualcomm.com>
	<20160531133700.GB3146@atheros-ThinkPad-T61>
In-Reply-To: <20160531133700.GB3146@atheros-ThinkPad-T61> (Mohammed Shafi
	Shajakhan's message of "Tue, 31 May 2016 19:07:00 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@codeaurora.org> writes:

>> > +void ath10k_sta_update_rx_duration(struct ath10k *ar,
>> > +				   struct ath10k_fw_stats *stats)
>> > +{
>> > +	struct ath10k_fw_file *fw_file = &ar->normal_mode_fw.fw_file;
>> > +
>> > +	if (fw_file->wmi_op_version < ATH10K_FW_WMI_OP_VERSION_10_4)
>> > +		ath10k_sta_update_stats_rx_duration(ar, &stats->peers);
>> > +	else
>> > +		ath10k_sta_update_extd_stats_rx_duration(ar,
>> > +							 &stats->peers_extd);
>> > +}
>> 
>> _Ideally_ wmi_op_version should be used only in ath10k_wmi_attach() and
>> nowhere else. Isn't there any other way to detect this scenario? For
>> example, what if you store stats_id to struct ath10k_fw_stats and do
>> something like this:
>> 
>> if (stats->stats_id & WMI_10_4_STAT_PEER_EXTD)
>> 	ath10k_sta_update_extd_stats_rx_duration(ar,
>> 						 &stats->peers_extd);
>> else
>> 	ath10k_sta_update_stats_rx_duration(ar, &stats->peers);
>> 
>> Would that work?
>
> [shafi] I am also thinking to re-use (ar->fw_stats_req_mask & WMI_10_4_STAT_PEER_EXTD)
> it might work, but will it conflict vdev stats WMI_STAT_VDEV (though its not currently
> supported for 10.2 )

Can you describe more how they conflict?

> let me know your thoughts about this, seems extended stats was
> implemented for 10.4 wmi version so i made it explicit

I don't like hard coding features like this based on wmi_op_version as
that might create problems managing the firmware interfaces in the
future. The simplest is if we can automatically runtime detect if
firmware uses the extended version or not.

-- 
Kalle Valo