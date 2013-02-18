Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx-relay11-haj2.antispameurope.com ([83.246.65.211]:38917 "EHLO
	mx-relay11-haj2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756872Ab3BRToG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 14:44:06 -0500
Message-ID: <512282AB.40604@fokus.fraunhofer.de> (sfid-20130218_204411_379239_6A8120A0)
Date: Mon, 18 Feb 2013 20:36:11 +0100
From: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Antonio Quartulli <antonio@open-mesh.com>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>,
	Marek Lindner <marek@open-mesh.com>
Subject: Re: [RFC] design discussion: Collecting information for (non-peer)
 stations
References: <20130215171938.GA4140@pandem0nium>  <1361197831.8555.23.camel@jlt4.sipsolutions.net>  <1361197982.8555.24.camel@jlt4.sipsolutions.net>  <20130218144622.GA4162@open-mesh.com>  <1361201387.8555.32.camel@jlt4.sipsolutions.net>  <20130218153833.GB4162@open-mesh.com>  <1361202206.8555.34.camel@jlt4.sipsolutions.net>  <20130218154906.GC4162@open-mesh.com>  <1361203098.8555.35.camel@jlt4.sipsolutions.net>  <20130218160705.GD4162@open-mesh.com> <1361206302.8555.36.camel@jlt4.sipsolutions.net>
In-Reply-To: <1361206302.8555.36.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/18/2013 05:51 PM, Johannes Berg wrote:
> On Mon, 2013-02-18 at 17:07 +0100, Antonio Quartulli wrote:
>> On Mon, Feb 18, 2013 at 07:58:18 -0800, Johannes Berg wrote:
>>> On Mon, 2013-02-18 at 16:49 +0100, Antonio Quartulli wrote:
>>>> On Mon, Feb 18, 2013 at 07:43:26 -0800, Johannes Berg wrote:
>>>>>> I did not like this approach because the sta_info struct is so big that
>>>>>> when we want to fill the stats substruct only we will waste a lot of bytes.
>>>>>
>>>>> I don't understand your point.
>>>>>
>>>>> struct sta_info {
>>>>>     ...
>>>>>     struct stats stats;
>>>>> };
>>>>
>>>> My concern is about those "..." that we are allocating within the sta_info struct
>>>> that we will never use for every non-peer station.
>>>>
>>>> While if we used the struct below (with its own hash table), we would allocate
>>>> only the space needed for the stats.
>>>>
>>>>>
>>>>> struct stats_entry {
>>>>>     struct hash/list/whatever;
>>>>>     struct stats stats;
>>>>> };
>>>>>
>>>>
>>>>
>>>> no?
>>>> Maybe I misunderstood your idea?
>>>
>>> But I'm not saying that these are mutually exclusive, I'm saying both
>>> should exist.
>>
>> Ah ok..Sorry, but I did not take this as an option :)
>>
>> So, if I understood correctly, this means one table lookup for peer stations,
>> while two table lookups for non peers (first in sta_hash, which will fail). Right?
>>
>> This would save one look up for each peer, since we have to do perform one of
>> them anyway (now I fully understood your previous statement!).
>
> Right... But the failing sta lookup has to happen anyway, so it really
> adds practically no cost in the peer case, and a singe lookup in the
> "non-peer already exists" case.

IMHO, this is the most efficient implementation for most practical use 
cases, where 'peer' traffic accounts more the majority of the traffic. 
Hence it should be in the 'fast path', while the extra lookup for 'non 
peer' traffic should be tolerable.

My five cents,

Mathias

> johannes
>


-- 
Fraunhofer FOKUS - RESourCe Optimised Networks
Dr. Mathias Kretschmer
Schloss Birlinghoven; D-53754 Sankt Augustin
T +49-2241-14-3466, F +49-2241-14-1050,
E mathias.kretschmer@fokus.fraunhofer.de
http://www.fokus.fraunhofer.de/en/rescon
