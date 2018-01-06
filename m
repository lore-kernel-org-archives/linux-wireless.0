Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:38967 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753520AbeAFQeE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Jan 2018 11:34:04 -0500
Received: by mail-ot0-f195.google.com with SMTP id 37so6240096otv.6
        for <linux-wireless@vger.kernel.org>; Sat, 06 Jan 2018 08:34:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3586343.KJymplWpZW@debian64>
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151520103755.32271.6819511294540882298.stgit@dwillia2-desk3.amr.corp.intel.com>
 <3586343.KJymplWpZW@debian64>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 6 Jan 2018 08:34:03 -0800
Message-ID: <CAPcyv4jR2za11fDEzcS3vq1xtcDj-uH8Uykg+uecn7Bk-9Cu1w@mail.gmail.com> (sfid-20180106_173437_169773_B96D9475)
Subject: Re: [PATCH 08/18] carl9170: prevent bounds-check bypass via
 speculative execution
To: Christian Lamparter <chunkeey@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 6, 2018 at 6:23 AM, Christian Lamparter <chunkeey@gmail.com> wrote:
> On Saturday, January 6, 2018 2:10:37 AM CET Dan Williams wrote:
>> Static analysis reports that 'queue' may be a user controlled value that
>> is used as a data dependency to read from the 'ar9170_qmap' array. In
>> order to avoid potential leaks of kernel memory values, block
>> speculative execution of the instruction stream that could issue reads
>> based on an invalid result of 'ar9170_qmap[queue]'. In this case the
>> value of 'ar9170_qmap[queue]' is immediately reused as an index to the
>> 'ar->edcf' array.
>>
>> Based on an original patch by Elena Reshetova.
>>
>> Cc: Christian Lamparter <chunkeey@googlemail.com>
>> Cc: Kalle Valo <kvalo@codeaurora.org>
>> Cc: linux-wireless@vger.kernel.org
>> Cc: netdev@vger.kernel.org
>> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/net/wireless/ath/carl9170/main.c |    6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
>> index 988c8857d78c..0ff34cbe2b62 100644
>> --- a/drivers/net/wireless/ath/carl9170/main.c
>> +++ b/drivers/net/wireless/ath/carl9170/main.c
>> @@ -41,6 +41,7 @@
>>  #include <linux/module.h>
>>  #include <linux/etherdevice.h>
>>  #include <linux/random.h>
>> +#include <linux/compiler.h>
>>  #include <net/mac80211.h>
>>  #include <net/cfg80211.h>
>>  #include "hw.h"
>> @@ -1384,11 +1385,12 @@ static int carl9170_op_conf_tx(struct ieee80211_hw *hw,
>>                              const struct ieee80211_tx_queue_params *param)
>>  {
>>       struct ar9170 *ar = hw->priv;
>> +     const u8 *elem;
>>       int ret;
>>
>>       mutex_lock(&ar->mutex);
>> -     if (queue < ar->hw->queues) {
>> -             memcpy(&ar->edcf[ar9170_qmap[queue]], param, sizeof(*param));
>> +     if ((elem = nospec_array_ptr(ar9170_qmap, queue, ar->hw->queues))) {
>> +             memcpy(&ar->edcf[*elem], param, sizeof(*param));
>>               ret = carl9170_set_qos(ar);
>>       } else {
>>               ret = -EINVAL;
>>
>>
> About the "queue" in carl9170_op_conf_tx, p54_conf_tx and cw1200_conf_tx:
>
> The only way a user can set this in any meaningful way would be via
> a NL80211_CMD_SET_WIPHY netlink message. However, the value will get
> vetted there by cfg80211's parse_txq_params [0]. This is long before
> it reaches any of the *_op_conf_tx functions.
>
> And Furthermore a invalid queue (param->ac) would cause a crash in
> this line in mac80211 before it even reaches the driver [1]:
> |       sdata->tx_conf[params->ac] = p;
> |                   ^^^^^^^^
> |       if (drv_conf_tx(local, sdata, >>>> params->ac <<<<, &p)) {
> |        ^^ (this is a wrapper for the *_op_conf_tx)
>
> I don't think these chin-up exercises are needed.

Quite the contrary, you've identified a better place in the call stack
to sanitize the input and disable speculation. Then we can kill the
whole class of the wireless driver reports at once it seems.
