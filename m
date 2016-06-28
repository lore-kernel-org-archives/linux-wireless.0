Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35350 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbcF1VVe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2016 17:21:34 -0400
Message-ID: <5772EA58.3030508@candelatech.com> (sfid-20160628_232138_589464_6E04FBF2)
Date: Tue, 28 Jun 2016 14:21:28 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  ensure info->control.vif is set for queued
 pkts.
References: <1466015073-8418-1-git-send-email-greearb@candelatech.com>	 <1467122419.2493.18.camel@sipsolutions.net>	 <57728EB2.2030706@candelatech.com> (sfid-20160628_165029_450743_D8773180) <1467144189.2493.19.camel@sipsolutions.net>
In-Reply-To: <1467144189.2493.19.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/28/2016 01:03 PM, Johannes Berg wrote:
> On Tue, 2016-06-28 at 07:50 -0700, Ben Greear wrote:
>
>> So, maybe a WARN_ON would be appropriate at the place frames are
>> enqueued in the backlog queue?  Since this patch did fix my problem,
>> maybe that WARN_ON would show the path that allow frames with bad
>> control.vif to be inserted?
>
> Yeah that might make sense, if you're willing to test that.
>
>> I had also found another problem with pktgen using the headroom
>> wrong, so possibly that would have also fixed my problem..I'm not
>> sure which patch I put in first.
>>
>
> That seems very unlikely to be related.

Well, it was very easy to reproduce:  Just over-drive tx on a station
using pktgen.  My pktgen is modified, but nothing that should affect
this bug as far as I know.

I can retest with a WARN_ON, but will be a week or two before I'm back in the office.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

