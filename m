Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:34007 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbbCSI2C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 04:28:02 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: Re: [PATCH] ath10k: fix htt t2h message conflicts among firmware revisions
References: <1426066382-481-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Thu, 19 Mar 2015 10:27:52 +0200
In-Reply-To: <1426066382-481-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Wed, 11 Mar 2015 15:03:02 +0530")
Message-ID: <878uetl7cn.fsf@kamboji.qca.qualcomm.com> (sfid-20150319_092808_792213_E403EC8C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Target to host HTT messages are conflicting between 10.x and other
> firmware revisions. By maintaining separate HTT T2H tables for each
> firmware revisions (main, 10x and tlv) similar to WMI abstraction,
> solves the conflicts.
>
> Cc: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

So this is needed to get managements frames over HTT working, right?
It's good to mention that in the commit log, does this look ok:

Author: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Date:   Wed Mar 11 15:03:02 2015 +0530

    ath10k: fix htt t2h message conflicts among firmware revisions
    
    Target to host HTT messages are conflicting between 10.x and other
    firmware revisions. By maintaining separate HTT T2H tables for each
    firmware revisions (main, 10x and tlv) similar to WMI abstraction,
    solves the conflicts.
    
    This fix is needed to get management frames over HTT (ie.
    ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX disabled) working with 10.2.4.48-2 firmware.
    Otherwise there will be unknown htt events and nothing works:
    
    [30087.438343] ath10k_pci 0000:02:00.0: htt event (19) not handled
    [30087.448691] ath10k_pci 0000:02:00.0: htt event (19) not handled
    [30149.032974] ath10k_pci 0000:02:00.0: htt event (19) not handled
    
    Cc: Michal Kazior <michal.kazior@tieto.com>
    Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

> @@ -66,6 +146,26 @@ int ath10k_htt_init(struct ath10k *ar)
>  		8 + /* llc snap */
>  		2; /* ip4 dscp or ip6 priority */
>  
> +	switch (ar->wmi.op_version) {
> +	case ATH10K_FW_WMI_OP_VERSION_MAIN:
> +		ar->htt.t2h_msg_types = htt_main_t2h_msg_types;
> +		ar->htt.t2h_msg_types_max = HTT_MAIN_T2H_NUM_MSGS;
> +		break;
> +	case ATH10K_FW_WMI_OP_VERSION_10_1:
> +	case ATH10K_FW_WMI_OP_VERSION_10_2:
> +	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
> +		ar->htt.t2h_msg_types = htt_10x_t2h_msg_types;
> +		ar->htt.t2h_msg_types_max = HTT_10X_T2H_NUM_MSGS;
> +		break;
> +	case ATH10K_FW_WMI_OP_VERSION_TLV:
> +		ar->htt.t2h_msg_types = htt_tlv_t2h_msg_types;
> +		ar->htt.t2h_msg_types_max = HTT_TLV_T2H_NUM_MSGS;
> +		break;
> +	case ATH10K_FW_WMI_OP_VERSION_UNSET:
> +	case ATH10K_FW_WMI_OP_VERSION_MAX:
> +		WARN_ON(1);
> +		return -EINVAL;
> +	}
>  	return 0;

When I was adding WMI_OP_VERSION, my idea was that we will add similar
version for HTT as well once we need it. But I guess this is good enough
for now, we can add HTT_OP_VERSION later if more changes are needed.

-- 
Kalle Valo
