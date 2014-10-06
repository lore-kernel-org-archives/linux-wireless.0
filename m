Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:2966 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaJFLwv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 07:52:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] ath10k: Add support to configure pktlog filter
References: <1412269778-1045-1-git-send-email-rmanohar@qti.qualcomm.com>
	<1412269778-1045-2-git-send-email-rmanohar@qti.qualcomm.com>
Date: Mon, 6 Oct 2014 14:52:45 +0300
In-Reply-To: <1412269778-1045-2-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Thu, 2 Oct 2014 22:39:35 +0530")
Message-ID: <877g0dl8j6.fsf@kamboji.qca.qualcomm.com> (sfid-20141006_135255_412154_3D7C3137)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Add support to configure packet log filters (tx, rx, rate control)
> via debugfs. To disable htt pktlog events set the filters to 0.
>
> ex:
>
> To enable pktlog for all filters
>
>    echo 0x1f > /sys/kernel/debug/ieee80211/phy*/ath10k/pktlog_filter
>
> To disable pktlog
>
>    echo 0 > /sys/kernel/debug/ieee80211/phy*/ath10k/pktlog_filter
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

I did minor changes to the error handling in
ath10k_write_pktlog_filter() and in ath10k_debug_start(). Diff below and
full commit here:

https://github.com/kvalo/ath/commit/470c43d83b7ee4147dea38a4f7b986070555a032

Please review my changes.

Kalle

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index a5700a2aff8c..fe71494cefa9 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1396,15 +1396,20 @@ int ath10k_debug_start(struct ath10k *ar)
 				    ret);
 	}
 
-	if (ar->debug.pktlog_filter)
+	if (ar->debug.pktlog_filter) {
 		ret = ath10k_wmi_pdev_pktlog_enable(ar,
 						    ar->debug.pktlog_filter);
-	else
+		if (ret)
+			/* not serious */
+			ath10k_warn(ar,
+				    "failed to enable pktlog filter %x: %d",
+				    ar->debug.pktlog_filter, ret);
+	} else {
 		ret = ath10k_wmi_pdev_pktlog_disable(ar);
-
-	if (ret)
-		ath10k_warn(ar, "failed to send pktlog command: %d filter %x",
-			    ret, ar->debug.pktlog_filter);
+		if (ret)
+			/* not serious */
+			ath10k_warn(ar, "failed to disable pktlog: %d", ret);
+	}
 
 	return ret;
 }
@@ -1520,23 +1525,31 @@ static ssize_t ath10k_write_pktlog_filter(struct file *file,
 
 	if (ar->state != ATH10K_STATE_ON) {
 		ar->debug.pktlog_filter = filter;
-		mutex_unlock(&ar->conf_mutex);
-		return count;
+		ret = count;
+		goto out;
 	}
 
-	if (filter && (filter != ar->debug.pktlog_filter))
+	if (filter && (filter != ar->debug.pktlog_filter)) {
 		ret = ath10k_wmi_pdev_pktlog_enable(ar, filter);
-	else
+		if (ret) {
+			ath10k_warn(ar, "failed to enable pktlog filter %x: %d",
+				    ar->debug.pktlog_filter, ret);
+			goto out;
+		}
+	} else {
 		ret = ath10k_wmi_pdev_pktlog_disable(ar);
+		if (ret) {
+			ath10k_warn(ar, "failed to disable pktlog: %d", ret);
+			goto out;
+		}
+	}
 
 	ar->debug.pktlog_filter = filter;
-	mutex_unlock(&ar->conf_mutex);
-
-	if (ret)
-		ath10k_warn(ar, "failed to send pktlog command: %d filter %x",
-			    ret, ar->debug.pktlog_filter);
+	ret = count;
 
-	return count;
+out:
+	mutex_unlock(&ar->conf_mutex);
+	return ret;
 }
 
 static ssize_t ath10k_read_pktlog_filter(struct file *file, char __user *ubuf,
