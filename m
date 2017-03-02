Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:33073 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752324AbdCBEL0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Mar 2017 23:11:26 -0500
Received: by mail-pg0-f45.google.com with SMTP id 25so27559400pgy.0
        for <linux-wireless@vger.kernel.org>; Wed, 01 Mar 2017 20:10:51 -0800 (PST)
Subject: Re: WARNING: CPU: 1 PID: 23668 at
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c:1539 iwl_mvm_rm_sta+0x3ce/0x450
To: Luca Coelho <luca@coelho.fi>
References: <f2bedfee-e74f-47d6-9088-94171f0e5538@email.android.com>
Cc: luciano.coelho@intel.com, sara.sharon@intel.com,
        liad.kaufman@intel.com, linux-wireless@vger.kernel.org
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <05fff778-8703-f429-f555-aa533c2df25f@kernel.dk> (sfid-20170302_051218_828025_01C2A1BA)
Date: Wed, 1 Mar 2017 21:10:47 -0700
MIME-Version: 1.0
In-Reply-To: <f2bedfee-e74f-47d6-9088-94171f0e5538@email.android.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/01/2017 08:33 PM, Luca Coelho wrote:
> Hi Jens,
> 
> On Mar 1, 2017 20:25, Jens Axboe <axboe@kernel.dk> wrote:
> 
>     Not that folks have been jumping all over this, but in case someone is
>     curious, it triggered twice here today. For those two times, the value
>     of mvm->pending_frames[sta_id] was 80 and 39, respectively.
> 
> Sorry for the delay, I'm on vacation now with limited internet access.
> But we'll take a look into this early next week at the latest.
> 
> Thanks a lot for the detailed report!

No worries, thanks for responding. I just wanted to ensure this wasn't
dropped on the floor.

BTW, a few more values of ->pending_frames[sta_id]:

$ dmesg | grep "ret="
[ 2334.308254] ret=39
[ 7915.311828] ret=80
[31602.317204] ret=41
[32139.510993] ret=54
[33292.917759] ret=96

it seems to often happen around resume.

-- 
Jens Axboe
