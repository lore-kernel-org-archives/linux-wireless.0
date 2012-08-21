Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-1.exch022.serverdata.net ([206.225.164.184]:31641
	"EHLO HUB022-nj-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750949Ab2HUNfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 09:35:07 -0400
Message-ID: <50338E84.3050709@posedge.com> (sfid-20120821_153510_996778_353DC6AA)
Date: Tue, 21 Aug 2012 19:05:00 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Kalle Valo <kvalo@adurom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH] cfg80211: VHT (11ac) Regulatory change
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCDD559@mbx022-e1-nj-10.exch022.domain.local> <20120816102211.GD17659@redhat.com> <502CF2D5.6020704@posedge.com> <20120817140657.GA1645@redhat.com> <502E85D9.5050301@posedge.com> <1345480718.4459.37.camel@jlt3.sipsolutions.net> <87d32k7kga.fsf@purkki.adurom.net> <20120821081839.GA2380@redhat.com>
In-Reply-To: <20120821081839.GA2380@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/21/2012 01:48 PM, Stanislaw Gruszka wrote:
> On Tue, Aug 21, 2012 at 10:50:13AM +0300, Kalle Valo wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>>
>>> On the other hand, maybe for VHT we want to completely change channel
>>> specifications? Maybe it would be better to allow specifying the
>>> *global* center frequency of the entire channel, and the width, and the
>>> control channel offset instead of encoding everything into the single
>>> channel type value? I don't know.
>>
>> What about the future? Will we see 320 MHz wide channels in 2020? :)
>
> Not in 2016 ?
>
>> After following the discussion about this I'm starting to think that
>> what you propose above makes our life easier in the long run. I just
>> don't trust that using a single channel type value is scalable in the
>> long run.
>
> Yeh, I think our channel description in code should reflect to what we
> have in new spec. That should fit well for legacy channels as well.
>
> Stanislaw
>
so we are talking about how to specify channel info to cfg/mac80211 from 
upper layers. But regulatory tells if that channel config is allowed or not.
so derive channel type from center freq, width and control chan offset.
Then determine if that channel type is allowed from regulatory flags?

In short we have scaled approach on specifying channel info but not 
regulatory. Please comment.

Regards,
Mahesh
