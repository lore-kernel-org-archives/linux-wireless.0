Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:36565 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751778AbdCJEmB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Mar 2017 23:42:01 -0500
Received: by mail-pf0-f177.google.com with SMTP id o126so37138231pfb.3
        for <linux-wireless@vger.kernel.org>; Thu, 09 Mar 2017 20:42:00 -0800 (PST)
Subject: Re: WARNING: CPU: 1 PID: 23668 at
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c:1539 iwl_mvm_rm_sta+0x3ce/0x450
To: Luca Coelho <luca@coelho.fi>
References: <f2bedfee-e74f-47d6-9088-94171f0e5538@email.android.com>
 <05fff778-8703-f429-f555-aa533c2df25f@kernel.dk>
Cc: luciano.coelho@intel.com, sara.sharon@intel.com,
        liad.kaufman@intel.com, linux-wireless@vger.kernel.org
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <fdfbfffa-31c9-7646-82b5-b6a759b73d21@kernel.dk> (sfid-20170310_054204_664366_5DBFF49D)
Date: Thu, 9 Mar 2017 21:41:57 -0700
MIME-Version: 1.0
In-Reply-To: <05fff778-8703-f429-f555-aa533c2df25f@kernel.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/01/2017 09:10 PM, Jens Axboe wrote:
> On 03/01/2017 08:33 PM, Luca Coelho wrote:
>> Hi Jens,
>>
>> On Mar 1, 2017 20:25, Jens Axboe <axboe@kernel.dk> wrote:
>>
>>     Not that folks have been jumping all over this, but in case someone is
>>     curious, it triggered twice here today. For those two times, the value
>>     of mvm->pending_frames[sta_id] was 80 and 39, respectively.
>>
>> Sorry for the delay, I'm on vacation now with limited internet access.
>> But we'll take a look into this early next week at the latest.
>>
>> Thanks a lot for the detailed report!
> 
> No worries, thanks for responding. I just wanted to ensure this wasn't
> dropped on the floor.
> 
> BTW, a few more values of ->pending_frames[sta_id]:
> 
> $ dmesg | grep "ret="
> [ 2334.308254] ret=39
> [ 7915.311828] ret=80
> [31602.317204] ret=41
> [32139.510993] ret=54
> [33292.917759] ret=96
> 
> it seems to often happen around resume.

This is still happening all the time in current -git.

-- 
Jens Axboe
