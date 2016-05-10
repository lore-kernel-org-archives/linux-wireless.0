Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:60626 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbcEJOwt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 10:52:49 -0400
Message-ID: <5731F5BF.7080307@candelatech.com> (sfid-20160510_165252_562550_4F317248)
Date: Tue, 10 May 2016 07:52:47 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
CC: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 15/21] ath10k: support CT firmware flag.
References: <1462835475-11079-1-git-send-email-greearb@candelatech.com> <1462835475-11079-16-git-send-email-greearb@candelatech.com> <20160510072005.GE25626@atheros-ThinkPad-T61>
In-Reply-To: <20160510072005.GE25626@atheros-ThinkPad-T61>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 05/10/2016 12:20 AM, Mohammed Shafi Shajakhan wrote:
> Hi Ben,
>
> On Mon, May 09, 2016 at 04:11:09PM -0700, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Add placeholder so CT firmware can more easily co-exist with upstream
>> kernel.
>
> [shafi] nitpick: good to provide an expansion in commit log as well, so that
> if we can easily figure out in git log alone, rather than going through
> the change and suggesting that it supports more vif's etc

CT firmware supports a great deal of things, such as IBSS, tx-rate reporting,
more control over tx-buffer allocation, rate-ctrl improvements and so forth.

I have another hundred or so patches that can enable and take advantage
of this sort of thing, but in the past, there has been no desire to allow
these patches upstream, so I am trying to feed some of the least controversial
patches first in case attitudes have changed.

If you would like to see my full patch tree, it is here:

http://dmz2.candelatech.com/?p=linux-4.4.dev.y/.git;a=summary

And, you can clone it:

git clone git://dmz2.candelatech.com/linux-4.4.dev.y

With regard to the patches in this series to dump the BSS regions and similar, I would
be happy to share my packaging script with QCA folks so they can add that info to their
own firmware. With BSS and Stack dumps, you can walk back through null-pointer exceptions
in the firmware and get a full backtrace instead of just the last call location.  This means
you can remove a huge number of ASSERTS, which frees up IRAM and overall makes the code
faster.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
