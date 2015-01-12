Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14785 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbbALLn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 06:43:58 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 7/8] ath10k: add support to send addba response
References: <1419407949-32367-1-git-send-email-rmanohar@qti.qualcomm.com>
	<1419407949-32367-8-git-send-email-rmanohar@qti.qualcomm.com>
Date: Mon, 12 Jan 2015 13:43:46 +0200
In-Reply-To: <1419407949-32367-8-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Wed, 24 Dec 2014 13:29:08 +0530")
Message-ID: <87y4p8dy19.fsf@kamboji.qca.qualcomm.com> (sfid-20150112_124402_388684_1E40DB6C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> This per-station debugfs entry helps to send addba response in
> manual mode for debugging purpose. It accepts tid and status code
> as input arguments.
>
> To send addba response,
>
> echo 0 25 >/sys/kernel/debug/ieee80211/phyX/netdev:wlanX/
> 	   stations/XX:XX:XX:XX:XX:XX/addba_resp
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Same here:

--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -148,16 +148,12 @@ static ssize_t ath10k_dbg_sta_write_addba_resp(struct file *file,
        buf[sizeof(buf) - 1] = '\0';
 
        ret = sscanf(buf, "%u %u", &tid, &status);
-       if (ret != 2) {
-               ath10k_warn(ar, "ex: echo <tid> <status code> >addba_resp\n");
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
