Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60916 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751357AbdJEIlo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Oct 2017 04:41:44 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Himanshu Jha <himanshujha199640@gmail.com>
Cc: amitkarwar@gmail.com, nishants@marvell.com, gbhat@marvell.com,
        huxm@marvell.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mwifiex: Use put_unaligned_le32
References: <1507141686-5178-1-git-send-email-himanshujha199640@gmail.com>
        <874lre5a86.fsf@codeaurora.org>
        <20171005083433.GA11485@himanshu-Vostro-3559>
Date: Thu, 05 Oct 2017 11:41:38 +0300
In-Reply-To: <20171005083433.GA11485@himanshu-Vostro-3559> (Himanshu Jha's
        message of "Thu, 5 Oct 2017 14:04:33 +0530")
Message-ID: <87zi963s1p.fsf@codeaurora.org> (sfid-20171005_104205_923008_9B0683D6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Himanshu Jha <himanshujha199640@gmail.com> writes:

>> > --- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
>> > +++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
>> > @@ -17,6 +17,7 @@
>> >   * this warranty disclaimer.
>> >   */
>> >  
>> > +#include <linux/unaligned/access_ok.h>
>> 
>> I don't think this is correct. Should it be asm/unaligned.h?
>
> Would mind explainig me as to why it is incorrect! Also, it defined in
> both the header files but, why is asm/unaligned.h preferred ?

asm/unaligned.h seems to be the toplevel header file which includes
header files based on arch configuration. Also grepping the sources
support that, nobody from drivers/ include access_ok.h directly.

But I can't say that I fully understand how the header files work so
please do correct me if I have mistaken.

-- 
Kalle Valo
