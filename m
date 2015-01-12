Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62466 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbbALLmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 06:42:31 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 6/8] ath10k: add support to send addba request
References: <1419407949-32367-1-git-send-email-rmanohar@qti.qualcomm.com>
	<1419407949-32367-7-git-send-email-rmanohar@qti.qualcomm.com>
Date: Mon, 12 Jan 2015 13:42:20 +0200
In-Reply-To: <1419407949-32367-7-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Wed, 24 Dec 2014 13:29:07 +0530")
Message-ID: <87387gfco3.fsf@kamboji.qca.qualcomm.com> (sfid-20150112_124235_032133_6173BF93)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> This per-station debugfs entry helps to send addba request in manual
> mode. Need to pass two configuration parameters (tid, buffer size)
> as input.
>
> To send addba,
>
> echo 1 32 >/sys/kernel/debug/ieee80211/phyX/netdev:wlanX/
> 	   stations/XX:XX:XX:XX:XX:XX/addba
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

[...]

> +	ret = sscanf(buf, "%u %u", &tid, &buf_size);
> +	if (ret != 2) {
> +		ath10k_warn(ar, "ex: echo <tid> <buffer size> >addba\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Valid TID values are 0 through 15 */
> +	if (tid > HTT_DATA_TX_EXT_TID_MGMT - 2) {
> +		ath10k_warn(ar, "Invalid TID %u\n", tid);
> +		return -EINVAL;
> +	}

It's preferred that the driver doesn't print anything based on wrong
user input, so I removed these two warning messages:

--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -97,16 +97,12 @@ static ssize_t ath10k_dbg_sta_write_addba(struct file *file,
        buf[sizeof(buf) - 1] = '\0';
 
        ret = sscanf(buf, "%u %u", &tid, &buf_size);
-       if (ret != 2) {
-               ath10k_warn(ar, "ex: echo <tid> <buffer size> >addba\n");
+       if (ret != 2)
                return -EINVAL;
-       }
 
        /* Valid TID values are 0 through 15 */
-       if (tid > HTT_DATA_TX_EXT_TID_MGMT - 2) {
-               ath10k_warn(ar, "Invalid TID %u\n", tid);
+       if (tid > HTT_DATA_TX_EXT_TID_MGMT - 2)
                return -EINVAL;
-       }
 
        mutex_lock(&ar->conf_mutex);
        if ((ar->state != ATH10K_STATE_ON) ||

-- 
Kalle Valo
