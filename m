Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43837 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab1JSSsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 14:48:18 -0400
Message-ID: <4E9F1B6B.1080401@candelatech.com> (sfid-20111019_204821_659778_187B05B5)
Date: Wed, 19 Oct 2011 11:48:11 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	reinette chatre <reinette.chatre@intel.com>,
	Eliad Peller <eliad@wizery.com>
Subject: Re: [RFC] mac80211: properly go back to operational channel?
References: <1317121970-3638-1-git-send-email-sgruszka@redhat.com>  <1317123289.4082.12.camel@jlt3.sipsolutions.net>  <20110929150018.GA4554@redhat.com>  <1317740824.6741.22.camel@jlt3.sipsolutions.net>  <20111005111507.GA2184@redhat.com>  <1317813762.4839.7.camel@jlt3.sipsolutions.net>  <20111018141922.GA6204@redhat.com> <1318948251.3958.29.camel@jlt3.sipsolutions.net>
In-Reply-To: <1318948251.3958.29.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/18/2011 07:30 AM, Johannes Berg wrote:
> On Tue, 2011-10-18 at 16:19 +0200, Stanislaw Gruszka wrote:
>> For local->tmp_channel == NULL and local->scan_channel == NULL
>> ieee80211_cfg_on_oper_channel() will return false if
>> local->oper_channel != local->hw.conf.channel,
>> hece we do not properly go back to oper_channel from tmp_channel.
>
> Huh, good catch.
>
>> Does patch have sense?
>
> Let's see what Ben says. It seems a bit like the
> ieee80211_cfg_on_oper_channel() test there should be inverted instead of
> removed?
>
>> Could it fixes problems we are talking
>> in this thread?
>
> Yes, could be related, also some issue Jouni and Reinette have been
> seeing with P2P might be related as well.

Please see the patch I just posted.  I think it fixes the
issue (which was originally reported by
Eliad Peller <eliad@wizery.com>, who also posted a patch).
I re-worked his suggested patch to what I believe is a more
proper patch.

Also, Eliad had posted another patch that seems to be good
as is (which I also just re-posted).

Obviously, my tests cases are not catching all of these issues,
so please review the patches and/or test them out to see if
they fix the problem.

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

