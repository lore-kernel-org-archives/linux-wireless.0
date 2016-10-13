Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31843 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753925AbcJMLJA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 07:09:00 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3] ath10k: cache calibration data when the core is stopped
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1476115204-7385-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1476115204-7385-1-git-send-email-kvalo@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        "Marty Faltesek" <mfaltesek@google.com>
Message-ID: <a8e2f654ee4e490caeaa23dbb8764cbf@euamsexm01a.eu.qualcomm.com> (sfid-20161013_130904_770645_B63DCFF9)
Date: Thu, 13 Oct 2016 13:08:52 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> From: Marty Faltesek <mfaltesek@google.com>
> 
> Commit 0b8e3c4ca29f ("ath10k: move cal data len to hw_params") broke retrieving
> the calibration data from cal_data debugfs file. The length of file was always
> zero. The reason is:
> 
>     static ssize_t ath10k_debug_cal_data_read(struct file *file,
>                                           char __user *user_buf,
>                                           size_t count, loff_t *ppos)
>     {
>         struct ath10k *ar = file->private_data;
>         void *buf = file->private_data;
> 
> 
> This is obviously bogus, private_data cannot contain both struct ath10k and the
> buffer. Fix it by caching calibration data to ar->debug.cal_data. This also
> allows it to be accessed when the device is not active (interface is down).
> 
> The cal_data buffer is fixed size because during the first firmware probe we
> don't yet know what will be the lenght of the calibration data. It was simplest
> just to use a fixed length. There's a WARN_ON() in
> ath10k_debug_cal_data_fetch() if the buffer is too small.
> 
> Tested with qca988x and firmware 10.2.4.70.56.
> 
> Reported-by: Nikolay Martynov <mar.kolya@gmail.com>
> Fixes: 0b8e3c4ca29f ("ath10k: move cal data len to hw_params")
> Cc: stable@vger.kernel.org # 4.7+
> Signed-off-by: Marty Faltesek <mfaltesek@google.com>
> [kvalo@qca.qualcomm.com: improve commit log and minor other changes]
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-current branch of ath.git, thanks.

f67b107d4ced ath10k: cache calibration data when the core is stopped

-- 
https://patchwork.kernel.org/patch/9369685/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
