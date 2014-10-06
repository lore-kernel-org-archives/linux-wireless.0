Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:4660 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaJFMMW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 08:12:22 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] ath10k: Add support to configure pktlog filter
References: <1412269778-1045-1-git-send-email-rmanohar@qti.qualcomm.com>
	<1412269778-1045-2-git-send-email-rmanohar@qti.qualcomm.com>
	<877g0dl8j6.fsf@kamboji.qca.qualcomm.com>
	<20141006120656.GA19615@qca.qualcomm.com>
Date: Mon, 6 Oct 2014 15:11:57 +0300
In-Reply-To: <20141006120656.GA19615@qca.qualcomm.com> (Rajkumar Manoharan's
	message of "Mon, 6 Oct 2014 17:36:58 +0530")
Message-ID: <87y4stjt2q.fsf@kamboji.qca.qualcomm.com> (sfid-20141006_141228_871821_7417DB51)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> On Mon, Oct 06, 2014 at 02:52:45PM +0300, Kalle Valo wrote:
>> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
>> 
>> > Add support to configure packet log filters (tx, rx, rate control)
>> > via debugfs. To disable htt pktlog events set the filters to 0.
>> >
>> > ex:
>> >
>> > To enable pktlog for all filters
>> >
>> >    echo 0x1f > /sys/kernel/debug/ieee80211/phy*/ath10k/pktlog_filter
>> >
>> > To disable pktlog
>> >
>> >    echo 0 > /sys/kernel/debug/ieee80211/phy*/ath10k/pktlog_filter
>> >
>> > Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
>> 
>> I did minor changes to the error handling in
>> ath10k_write_pktlog_filter() and in ath10k_debug_start(). Diff below and
>> full commit here:
>> 
>> https://github.com/kvalo/ath/commit/470c43d83b7ee4147dea38a4f7b986070555a032
>> 
>> Please review my changes.
>
> LGTM.

Joe Perches pointed out to me offline that I had missed '\n' in two of
the warning messages. So one more change:

--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1402,13 +1402,13 @@ int ath10k_debug_start(struct ath10k *ar)
 		if (ret)
 			/* not serious */
 			ath10k_warn(ar,
-				    "failed to enable pktlog filter %x: %d",
+				    "failed to enable pktlog filter %x: %d\n",
 				    ar->debug.pktlog_filter, ret);
 	} else {
 		ret = ath10k_wmi_pdev_pktlog_disable(ar);
 		if (ret)
 			/* not serious */
-			ath10k_warn(ar, "failed to disable pktlog: %d", ret);
+			ath10k_warn(ar, "failed to disable pktlog: %d\n", ret);
 	}
 
 	return ret;
@@ -1532,14 +1532,14 @@ static ssize_t ath10k_write_pktlog_filter(struct file *file,
 	if (filter && (filter != ar->debug.pktlog_filter)) {
 		ret = ath10k_wmi_pdev_pktlog_enable(ar, filter);
 		if (ret) {
-			ath10k_warn(ar, "failed to enable pktlog filter %x: %d",
+			ath10k_warn(ar, "failed to enable pktlog filter %x: %d\n",
 				    ar->debug.pktlog_filter, ret);
 			goto out;
 		}
 	} else {
 		ret = ath10k_wmi_pdev_pktlog_disable(ar);
 		if (ret) {
-			ath10k_warn(ar, "failed to disable pktlog: %d", ret);
+			ath10k_warn(ar, "failed to disable pktlog: %d\n", ret);
 			goto out;
 		}
 	}


-- 
Kalle Valo
