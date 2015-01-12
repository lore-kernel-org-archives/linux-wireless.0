Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27414 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbbALLqL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 06:46:11 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 8/8] ath10k: add support to send delba
References: <1419407949-32367-1-git-send-email-rmanohar@qti.qualcomm.com>
	<1419407949-32367-9-git-send-email-rmanohar@qti.qualcomm.com>
Date: Mon, 12 Jan 2015 13:45:59 +0200
In-Reply-To: <1419407949-32367-9-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Wed, 24 Dec 2014 13:29:09 +0530")
Message-ID: <87twzwdxxk.fsf@kamboji.qca.qualcomm.com> (sfid-20150112_124621_485040_4D148C43)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> This per-station debugfs entry helps to send delba in manual mode
> for debugging purpose. It accepts tid, initiator and reason code
> as inputs.
>
> To send delba,
>
> echo 0 1 37 >/sys/kernel/debug/ieee80211/phyX/netdev:wlanX/
> 	     stations/XX:XX:XX:XX:XX:XX/delba
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

[...]

> +	ret = sscanf(buf, "%u %u %u", &tid, &initiator, &reason);
> +	if (ret != 3) {
> +		ath10k_warn(ar, "ex: echo <tid> <initiator> <reason code> >delba\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Valid TID values are 0 through 15 */
> +	if (tid > HTT_DATA_TX_EXT_TID_MGMT - 2) {
> +		ath10k_warn(ar, "Invalid TID %u\n", tid);
> +		return -EINVAL;
> +	}

And I did the same here as well.

-- 
Kalle Valo
