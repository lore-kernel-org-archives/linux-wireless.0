Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:36112 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755104AbdCJPlF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 10:41:05 -0500
Received: by mail-pf0-f170.google.com with SMTP id o126so43207220pfb.3
        for <linux-wireless@vger.kernel.org>; Fri, 10 Mar 2017 07:41:05 -0800 (PST)
Subject: Re: WARNING: CPU: 1 PID: 23668 at
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c:1539 iwl_mvm_rm_sta+0x3ce/0x450
To: Luca Coelho <luca@coelho.fi>
References: <f2bedfee-e74f-47d6-9088-94171f0e5538@email.android.com>
 <05fff778-8703-f429-f555-aa533c2df25f@kernel.dk>
 <fdfbfffa-31c9-7646-82b5-b6a759b73d21@kernel.dk>
 <1489147283.22435.14.camel@coelho.fi>
 <aceb734b-8e2c-e5b6-300d-172f8d28f471@kernel.dk>
 <1489160164.22435.18.camel@coelho.fi>
Cc: sara.sharon@intel.com, liad.kaufman@intel.com,
        linux-wireless@vger.kernel.org
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5d235320-9c9d-c9e9-6688-3336061cbaf4@kernel.dk> (sfid-20170310_164109_670793_6FD4C1EE)
Date: Fri, 10 Mar 2017 08:41:02 -0700
MIME-Version: 1.0
In-Reply-To: <1489160164.22435.18.camel@coelho.fi>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/10/2017 08:36 AM, Luca Coelho wrote:
> On Fri, 2017-03-10 at 08:23 -0700, Jens Axboe wrote:
>> On 03/10/2017 05:01 AM, Luca Coelho wrote:
>>> Hi Jens,
>>>
>>> On Thu, 2017-03-09 at 21:41 -0700, Jens Axboe wrote:
>>>> On 03/01/2017 09:10 PM, Jens Axboe wrote:
>>>>> On 03/01/2017 08:33 PM, Luca Coelho wrote:
>>>>>> Hi Jens,
>>>>>>
>>>>>> On Mar 1, 2017 20:25, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>
>>>>>>     Not that folks have been jumping all over this, but in case someone is
>>>>>>     curious, it triggered twice here today. For those two times, the value
>>>>>>     of mvm->pending_frames[sta_id] was 80 and 39, respectively.
>>>>>>
>>>>>> Sorry for the delay, I'm on vacation now with limited internet access.
>>>>>> But we'll take a look into this early next week at the latest.
>>>>>>
>>>>>> Thanks a lot for the detailed report!
>>>>>
>>>>> No worries, thanks for responding. I just wanted to ensure this wasn't
>>>>> dropped on the floor.
>>>>>
>>>>> BTW, a few more values of ->pending_frames[sta_id]:
>>>>>
>>>>> $ dmesg | grep "ret="
>>>>> [ 2334.308254] ret=39
>>>>> [ 7915.311828] ret=80
>>>>> [31602.317204] ret=41
>>>>> [32139.510993] ret=54
>>>>> [33292.917759] ret=96
>>>>>
>>>>> it seems to often happen around resume.
>>>>
>>>> This is still happening all the time in current -git.
>>>
>>> Could you collect traces with trace-cmd, as explained in our wiki[1]?
>>> This will probably help point out the problem.  I know it's a bit
>>> difficult because it appears to happen randomly for you, but it's worth
>>> trying.
>>
>> Sure I can, but honestly I'm a little puzzled that nobody else can
>> reproduce this, it happens every time I resume of switch access points.
>> Is anyone trying to reproduce this?
>>
>> I'll have to recompile with iwlwifi tracing enabled, then I'll send a trace
>> when it happens.
> 
> Are you using 4.11-rc1? Or linus' master? Or...?

The trace I just sent is tip of Linus' tree. It's happened continually
since the commit I mentioned in my initial report was merged:

commit 94c3e614df2117626fccfac8f821c66e30556384
Author: Sara Sharon <sara.sharon@intel.com>
Date:   Wed Dec 7 15:04:37 2016 +0200

    iwlwifi: mvm: fix pending frame counter calculation

-- 
Jens Axboe
