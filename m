Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:35769 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753387AbdCAXdx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Mar 2017 18:33:53 -0500
Received: by mail-pf0-f173.google.com with SMTP id j5so15572441pfb.2
        for <linux-wireless@vger.kernel.org>; Wed, 01 Mar 2017 15:32:36 -0800 (PST)
Subject: Re: WARNING: CPU: 1 PID: 23668 at
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c:1539 iwl_mvm_rm_sta+0x3ce/0x450
To: sara.sharon@intel.com
References: <c60e6859-f1ec-6656-2625-b5ce5f18059a@kernel.dk>
 <9c4d1814-d6f2-e9c2-0b66-bbfadc002b15@kernel.dk>
Cc: linux-wireless@vger.kernel.org, luciano.coelho@intel.com,
        liad.kaufman@intel.com
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <2f9864c4-0b5f-b58f-f634-092188d71acc@kernel.dk> (sfid-20170302_003356_463959_4F194132)
Date: Wed, 1 Mar 2017 16:25:14 -0700
MIME-Version: 1.0
In-Reply-To: <9c4d1814-d6f2-e9c2-0b66-bbfadc002b15@kernel.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/28/2017 01:41 PM, Jens Axboe wrote:
> On 02/28/2017 11:02 AM, Jens Axboe wrote:
>> Hi,
>>
>> I'm hitting this one a lot with current -git, which is this one:
>>
>> if (iwl_mvm_is_dqa_supported(mvm)) {                            
>>         iwl_mvm_disable_sta_queues(mvm, vif, mvm_sta);          
>>         /*                                                      
>>          * If pending_frames is set at this point - it must be  
>>          * driver internal logic error, since queues are empty  
>>          * and removed successuly.                              
>>          * warn on it but set it to 0 anyway to avoid station   
>>          * not being removed later in the function              
>>          */                                                     
>>         WARN_ON(atomic_xchg(&mvm->pending_frames[sta_id], 0));  
>> }
>>
>> It's hit 4 times over the last day. The bug is probably older than the
>> commit that added this warning:
>>
>> commit 94c3e614df2117626fccfac8f821c66e30556384
>> Author: Sara Sharon <sara.sharon@intel.com>
>> Date:   Wed Dec 7 15:04:37 2016 +0200
>>
>>     iwlwifi: mvm: fix pending frame counter calculation
>>
>> but the pestering is new.
> 
> Forgot to include the traces, find them below.

Not that folks have been jumping all over this, but in case someone is
curious, it triggered twice here today. For those two times, the value
of mvm->pending_frames[sta_id] was 80 and 39, respectively.

-- 
Jens Axboe
