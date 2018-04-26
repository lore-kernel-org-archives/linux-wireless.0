Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49232 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755074AbeDZKdW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 06:33:22 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Wireless <linux-wireless@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Shaul Triebitz <shaul.triebitz@intel.com>
Subject: Re: linux-next: manual merge of the wireless-drivers-next tree with the wireless-drivers tree
References: <20180426110917.446204af@canb.auug.org.au>
        <6f5ba028f120d092bd5c96557144750518faf9c1.camel@intel.com>
Date: Thu, 26 Apr 2018 13:33:09 +0300
In-Reply-To: <6f5ba028f120d092bd5c96557144750518faf9c1.camel@intel.com>
        (Luciano Coelho's message of "Thu, 26 Apr 2018 10:38:11 +0300")
Message-ID: <87a7tq6yvu.fsf@kamboji.qca.qualcomm.com> (sfid-20180426_123335_361856_978771E3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho <luciano.coelho@intel.com> writes:

> On Thu, 2018-04-26 at 11:09 +1000, Stephen Rothwell wrote:
>> Hi all,
>> 
>> Today's linux-next merge of the wireless-drivers-next tree got a
>> conflict in:
>> 
>>   drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
>> 
>> between commit:
>> 
>>   77e30e10ee28 ("iwlwifi: mvm: query regdb for wmm rule if needed")
>> 
>> from the wireless-drivers tree and commits:
>> 
>>   9c4f7d512740 ("iwlwifi: move all NVM parsing code to the common
>> files")
>>   4c625c564ba2 ("iwlwifi: get rid of fw/nvm.c")
>> 
>> from the wireless-drivers-next tree.
>> 
>> I fixed it up (see below) and can carry the fix as necessary. This
>> is now fixed as far as linux-next is concerned, but any non trivial
>> conflicts should be mentioned to your upstream maintainer when your
>> tree
>> is submitted for merging.  You may also want to consider cooperating
>> with the maintainer of the conflicting tree to minimise any
>> particularly
>> complex conflicts.
>
> Thanks for resolving this, Stephen!
>
> I checked your resolution and it's spot on.

I now merged w-d to w-d-next to fix this, please check:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=0ddcf3e76ae4d02918e609342a1020b50258fadd

I was not sure what to do with these includes so I left them in:

#include "fw/api/commands.h"
#include "fw/api/cmdhdr.h"
#include "fw/img.h"

-- 
Kalle Valo
