Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41136 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbbCNSEf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 14:04:35 -0400
Message-ID: <55047831.8000307@candelatech.com> (sfid-20150314_190439_705345_30D204B3)
Date: Sat, 14 Mar 2015 11:04:33 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Arend van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mac80211-hwsim and tx-rates.
References: <5500AEAB.8010605@candelatech.com> <5500B417.9070307@broadcom.com> <5500BC5A.9040809@candelatech.com> <20150314104742.GA13495@localhost> <55045E56.1050904@candelatech.com> <20150314174813.GA6772@localhost>
In-Reply-To: <20150314174813.GA6772@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 03/14/2015 10:48 AM, Bob Copeland wrote:
> On Sat, Mar 14, 2015 at 09:14:14AM -0700, Ben Greear wrote:
>> It can change with every packet based on rate-control logic, right?
>
> You said you wanted to go from index to bitrate -- the index changes,
> but not the rate<->index mapping.

The index means different things based on legacy, HT, VHT.  You need index
+ flags to determine the actual rate for each packet.

I am fine with hard-coding in user-space the correlation of legacy index
to rates.

The array that is currently sent to user-space is the rates that rate-ctrl
determines should be used for transmit (and re-transmit), as far as I can tell.


>> And, it seems unlikely to me that an extra 16 bytes or so would make a
>> great deal of difference.  Using hash tables instead of linear walks
>> and other things would likely improve performance more?
>
> Last time I tested with perf, memcpy dominated everything -- I've been
> thinking about having a mode where just headers are sent to userspace
> to avoid some of that.

I need full pkt in user-space, but at least for some use-cases your idea
may be a nice improvement.

With hundreds of virtual radios and network devices, hashing the lookup of
radios should be a big win.  I'll work on that someday soon most likely.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
