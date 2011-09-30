Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:44137 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758324Ab1I3LLv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 07:11:51 -0400
Message-ID: <4E85A3F4.2000500@neratec.com> (sfid-20110930_131155_903105_8256B832)
Date: Fri, 30 Sep 2011 13:11:48 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: Adrian Chadd <adrian@freebsd.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Boris Presman <boris.presman@ti.com>,
	Assaf Azulay <assaf@ti.com>,
	Michael Green <green@qca.qualcomm.com>,
	David Quan <dquan@qca.qualcomm.com>,
	Kevin Hayes <hayes@qca.qualcomm.com>,
	Arun Venkataraman <arunvenk@qca.qualcomm.com>
Subject: Re: Regulatory revamp status
References: <CAB=NE6U6qmYbvHPTWGTqOdXtuxbKYbUzZXNiE6POOX9QZNRWAg@mail.gmail.com> <1125417094.1836.1317285426615.JavaMail.root@idefix> <CAJ-VmonqEs4mODDa2=fTj8zWHwRM7-G5e=BWNUyGdy65+kYvfg@mail.gmail.com> <4E8468AF.8000006@neratec.com> <CAB=NE6UQpv1bvsni=rDP=3OKM=oN14g0xJtVN+evvm=47nZu_Q@mail.gmail.com>
In-Reply-To: <CAB=NE6UQpv1bvsni=rDP=3OKM=oN14g0xJtVN+evvm=47nZu_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/29/2011 07:47 PM, Luis R. Rodriguez wrote:
> On Thu, Sep 29, 2011 at 5:46 AM, Zefir Kurtisi
> <zefir.kurtisi@neratec.com> wrote:
>> On 09/29/2011 01:45 PM, Adrian Chadd wrote:
>>> On 29 September 2011 16:37, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
>>>> Thanks for the update.
>>>>
>>>> To me it looks not reasonable to mix in between the two approaches: either we assume countrycodes use the same DFS region for all channels, or each channel/band needs to have its own. Otherwise I feel that a DFS region bitmap would give a semi-flexible compromise that might end up being insufficient to represent some fancy countrycodes.
>>>
>>> There's some funny stuff in there.
>>>
>>> For example, some of the DFS bands have different CAC/NOL timing. :-)
>>>
>>>
>>>
>>> Adrian
>>
>> Really? Where would be 'there' countrycode-wise?
>>
>> That would definitely break today's CRDA capabilities :-\
> 
> Well, CRDA has no DFS support yet ;) and hence the regulatory revamp
Yes, I meant the proposed approach with a regulaltory domain per countrycode won't work with those fancy ones.
> work, to accommodate as much as possible for both future technologies
> and capture all these gotchas on existing technologies. If DFS varies
> so much then using one u8 for a country may not be enough, and we may
> want to add a whole section for DFS with the u8 being an optional
> minimum and with a DFS section for overrides on values. Thoughts?
> 
That sounds like a doable way to start with the per countrycode domain and traverse to the optional refinement values on demand.

BTW, would this render the countrycode to CTL mappings in regd_common.h redundant, or do DFS and CTL domains differ?
> That is -- if your country varies per band or CAC / NOL timings we can
> address these countries only with the future revamp work. This would
> allow us to move forward with DFS support only for those countries
> where a unified DFS mapping applies.
> 
To start with support for unified DFS domain CCs, was there ever some v2 for the related patch set you posted?
>   Luis

Zefir
