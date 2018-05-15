Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr20047.outbound.protection.outlook.com ([40.107.2.47]:30336
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750810AbeEOT0u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 15:26:50 -0400
Subject: Fwd: Re: [PATCHv2 2/2] ath10k: DFS Host Confirmation
References: <72826487-2af6-3c16-e7f8-3b2592416f9d@bowerswilkins.com>
To: Sriram R <srirrama@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <cf2b6989-cd97-68c5-8e6a-1e0c80cb9c7d@bowerswilkins.com> (sfid-20180515_212654_442841_F68BDE73)
Date: Tue, 15 May 2018 12:26:34 -0700
MIME-Version: 1.0
In-Reply-To: <72826487-2af6-3c16-e7f8-3b2592416f9d@bowerswilkins.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +	/* Even in case of radar detection failure we follow the same
> +	 * behaviour as if radar is detected i.e to switch to a different
> +	 * channel.
> +	 */
> +	if (status_arg.status == WMI_HW_RADAR_DETECTED ||
> +	    status_arg.status == WMI_RADAR_DETECTION_FAIL)
> +		ath10k_radar_detected(ar);
>
This behavior is different from what Kalle explained.
Failing verification of radar type by FW does not enforce stop DFS
channels from using.
Kalle?
