Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:42865 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbbCBIqp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 03:46:45 -0500
Received: by wesw62 with SMTP id w62so31770401wes.9
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2015 00:46:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1425238927.31561.5.camel@perches.com>
References: <1425238186.30202.5.camel@egrumbacBox> <1425238304-498-8-git-send-email-emmanuel.grumbach@intel.com>
 <1425238927.31561.5.camel@perches.com>
From: Eyal Shapira <eyal@wizery.com>
Date: Mon, 2 Mar 2015 10:46:24 +0200
Message-ID: <CAF8O4-wyiy6zejoHuJKX53=O+AQW=aEAR7dCL1jO=iVQx_K97A@mail.gmail.com> (sfid-20150302_094648_701902_DCE695F6)
Subject: Re: [PATCH 08/31] iwlwifi: mvm: rs: print single stream params via debugfs
To: Joe Perches <joe@perches.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org,
	Eyal Shapira <eyalx.shapira@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 1, 2015 at 9:42 PM, Joe Perches <joe@perches.com> wrote:
> On Sun, 2015-03-01 at 21:31 +0200, Emmanuel Grumbach wrote:
>> From: Eyal Shapira <eyal@wizery.com>
>>
>> Add this to the info printed when reading rate_scale_table.
>> Useful for debugging.
> []
>> diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
> []
>> @@ -3369,6 +3370,16 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
>>                       lq_sta->lq.agg_frame_cnt_limit);
>>
>>       desc += sprintf(buff+desc, "reduced tpc=%d\n", lq_sta->lq.reduced_tpc);
>> +     ss_params = le32_to_cpu(lq_sta->lq.ss_params);
>> +     desc += sprintf(buff+desc, "single stream params: %s%s%s%s\n",
>> +                     (ss_params & LQ_SS_PARAMS_VALID) ?
>> +                     "VALID," : "INVALID",
>> +                     (ss_params & LQ_SS_BFER_ALLOWED) ?
>> +                     "BFER," : "",
>> +                     (ss_params & LQ_SS_STBC_1SS_ALLOWED) ?
>> +                     "STBC," : "",
>> +                     (ss_params & LQ_SS_FORCE) ?
>> +                     "FORCE" : "");
>
> Are all things exclusive?

INVALID is exclusive to the other options so there's no real readability issue.
I like your version better though as it avoids the additional comma in the end.
Submitted to Emmanuel's internal tree.
Thanks

> If no, the output is not easily readable.
>
> It would probably be better to use:
> 12345678901234567890123456789012345678901234567890123456789012345678901234567890
>         desc += sprintf(buff+desc, "single stream params: %s%s%s%s\n",
>                         (ss_params & LQ_SS_PARAMS_VALID) ?
>                         "VALID" : "INVALID",
>                         (ss_params & LQ_SS_BFER_ALLOWED) ?
>                         ", BFER" : "",
>                         (ss_params & LQ_SS_STBC_1SS_ALLOWED) ?
>                         ", STBC" : "",
>                         (ss_params & LQ_SS_FORCE) ?
>                         ", FORCE" : "");
>
