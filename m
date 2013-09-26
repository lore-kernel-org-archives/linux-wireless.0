Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:7164 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3IZJEW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 05:04:22 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 07/13] ath10k: implement host memory chunks
References: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
	<1380101891-18312-8-git-send-email-bartosz.markowski@tieto.com>
Date: Thu, 26 Sep 2013 12:04:12 +0300
In-Reply-To: <1380101891-18312-8-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Wed, 25 Sep 2013 11:38:05 +0200")
Message-ID: <87k3i4rm2b.fsf@kamboji.qca.qualcomm.com> (sfid-20130926_110427_494761_8DB94E08)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> 10.X firmware can request a memory pool from host to offload
> it's own resources. This is a feature designed especially
> for AP mode where the target has to deal with large number
> of peers.
>
> So we allocate and map a consistent DMA memory which FW can
> use to store e.g. peer rate contol maps.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

[...]

> +		if (num_unit_info) {
> +			if (num_unit_info & NUM_UNITS_IS_NUM_PEERS)
> +				/* number of units to allocate is number of
> +				 * peers, 1 extra for self peer on target */
> +				/* this needs to be tied, host and target
> +				 * can get out of sync */
> +				num_units = TARGET_NUM_PEERS + 1;
> +			if (num_unit_info & NUM_UNITS_IS_NUM_VDEVS)
> +				num_units = TARGET_NUM_VDEVS + 1;
> +		}

The outer if test looks useless. I think this can be simplified to just:

if (num_unit_info & NUM_UNITS_IS_NUM_PEERS)
        ....
else if (num_unit_info & NUM_UNITS_IS_NUM_VDEVS)
        ...

-- 
Kalle Valo
