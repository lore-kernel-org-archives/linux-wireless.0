Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-6.exch022.serverdata.net ([206.225.164.189]:1986 "EHLO
	HUB022-nj-6.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754161Ab2HUSH4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 14:07:56 -0400
Message-ID: <5033CE76.6040306@posedge.com> (sfid-20120821_200800_148170_1F5CA79C)
Date: Tue, 21 Aug 2012 23:37:50 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH] cfg80211: VHT (11ac) Regulatory change
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCDD559@mbx022-e1-nj-10.exch022.domain.local>  <20120816102211.GD17659@redhat.com> <502CF2D5.6020704@posedge.com>  <20120817140657.GA1645@redhat.com> <502E85D9.5050301@posedge.com>  <1345480718.4459.37.camel@jlt3.sipsolutions.net>  <87d32k7kga.fsf@purkki.adurom.net> <20120821081839.GA2380@redhat.com>  <50338E84.3050709@posedge.com> <1345564421.10280.9.camel@jlt3.sipsolutions.net>
In-Reply-To: <1345564421.10280.9.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 8/21/2012 9:23 PM, Johannes Berg wrote:
> On Tue, 2012-08-21 at 19:05 +0530, Mahesh Palivela wrote:
>
>> so we are talking about how to specify channel info to cfg/mac80211 from
>> upper layers.
>
> Correct
>
>> But regulatory tells if that channel config is allowed or not.
>
> Correct.
>
>> so derive channel type from center freq, width and control chan offset.
>> Then determine if that channel type is allowed from regulatory flags?
>>
>> In short we have scaled approach on specifying channel info but not
>> regulatory. Please comment.
>
> Well, we don't really have it yet :-)
>
> I think the question really is whether or not we actually need the
> flags. Sometimes, but very rarely really, we need to answer the question
>
>          Is this set of parameters allowed with the current regulatory
>          rules?
>
> There's nothing that says this needs to be a flag. It could just as well
> be a function
>
> bool regulatory_chan_use_permitted(...);
>
> where the ... gives all the necessary parameters or maybe some structure
> holding all these.
>
> If this was a function, it could go back to the regulatory definitions
> (that we hopefully keep track of in the kernel) and actually use the
> algorithm that today we use to determine the flags to determine the
> answer.
>
> Today, with the flags, we basically pre-determine the answers to all
> possible such questions, and encode the answers in the flags for each
> channel. If we don't pre-determine the answers, then we can get away
> without any flags at all.
>
> Does that make sense?
>
Yes it does. Basically we want to retire look up table approach and 
compute everytime as its not scalable. Fine. In that case, even we need 
to cover HT20, HT40-, HT40+ as well right?

> Still doesn't solve the problems we saw with how to configure the
> channel with considerations such as
>    - bandwidth
>    - center frequency
>    - primary subchannel
>    - 80 + 80 (which is basically two such channels?)
>
Yes It does. From center freq, width, control chan offset we know the 
secondary chans. That's all we want. For 80+80 configuration, we will 
get two center freq values.

> johannes
>

-- 
Thanks,
Mahesh
