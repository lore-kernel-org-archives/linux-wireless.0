Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:40962 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752770AbeAFKBS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Jan 2018 05:01:18 -0500
Received: by mail-lf0-f66.google.com with SMTP id h137so7501085lfe.8
        for <linux-wireless@vger.kernel.org>; Sat, 06 Jan 2018 02:01:17 -0800 (PST)
Subject: Re: [PATCH 08/18] carl9170: prevent bounds-check bypass via
 speculative execution
To: Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, peterz@infradead.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        gregkh@linuxfoundation.org,
        Christian Lamparter <chunkeey@googlemail.com>,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        Kalle Valo <kvalo@codeaurora.org>, alan@linux.intel.com
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151520103755.32271.6819511294540882298.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <113c7f80-265b-4da2-3eba-727c8f64a2b0@cogentembedded.com> (sfid-20180106_110144_885868_FC862CBE)
Date: Sat, 6 Jan 2018 13:01:15 +0300
MIME-Version: 1.0
In-Reply-To: <151520103755.32271.6819511294540882298.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

On 1/6/2018 4:10 AM, Dan Williams wrote:

> Static analysis reports that 'queue' may be a user controlled value that
> is used as a data dependency to read from the 'ar9170_qmap' array. In
> order to avoid potential leaks of kernel memory values, block
> speculative execution of the instruction stream that could issue reads
> based on an invalid result of 'ar9170_qmap[queue]'. In this case the
> value of 'ar9170_qmap[queue]' is immediately reused as an index to the
> 'ar->edcf' array.
> 
> Based on an original patch by Elena Reshetova.
> 
> Cc: Christian Lamparter <chunkeey@googlemail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>   drivers/net/wireless/ath/carl9170/main.c |    6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
> index 988c8857d78c..0ff34cbe2b62 100644
> --- a/drivers/net/wireless/ath/carl9170/main.c
> +++ b/drivers/net/wireless/ath/carl9170/main.c
> @@ -41,6 +41,7 @@
>   #include <linux/module.h>
>   #include <linux/etherdevice.h>
>   #include <linux/random.h>
> +#include <linux/compiler.h>
>   #include <net/mac80211.h>
>   #include <net/cfg80211.h>
>   #include "hw.h"
> @@ -1384,11 +1385,12 @@ static int carl9170_op_conf_tx(struct ieee80211_hw *hw,
>   			       const struct ieee80211_tx_queue_params *param)
>   {
>   	struct ar9170 *ar = hw->priv;
> +	const u8 *elem;
>   	int ret;
>   
>   	mutex_lock(&ar->mutex);
> -	if (queue < ar->hw->queues) {
> -		memcpy(&ar->edcf[ar9170_qmap[queue]], param, sizeof(*param));
> +	if ((elem = nospec_array_ptr(ar9170_qmap, queue, ar->hw->queues))) {

    I bet this causes checkpatch.pl to complain. I don't see a dire need to 
upset it here, the assignment may well precede *if*...

> +		memcpy(&ar->edcf[*elem], param, sizeof(*param));
>   		ret = carl9170_set_qos(ar);
>   	} else {
>   		ret = -EINVAL;
> 

MBR, Sergei
