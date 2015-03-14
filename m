Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40125 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbbCNQOP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 12:14:15 -0400
Message-ID: <55045E56.1050904@candelatech.com> (sfid-20150314_171418_997046_69F81821)
Date: Sat, 14 Mar 2015 09:14:14 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Arend van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mac80211-hwsim and tx-rates.
References: <5500AEAB.8010605@candelatech.com> <5500B417.9070307@broadcom.com> <5500BC5A.9040809@candelatech.com> <20150314104742.GA13495@localhost>
In-Reply-To: <20150314104742.GA13495@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 03/14/2015 03:47 AM, Bob Copeland wrote:
> On Wed, Mar 11, 2015 at 03:06:18PM -0700, Ben Greear wrote:
>> I don't see a good way to tie that idx to an actual rate (which involves
>> flags, nss, mcs values, etc).
>>
>> Maybe I should also just send the info I care about, which is a 'bps' rate,
>> channel-width indication, SGI, etc as separate netlink attributes....
>
> My wmediumd fork (https://github.com/bcopeland/wmediumd) could benefit from
> this as well -- right now it assumes you use OFDM rates only.
>
> It probably makes sense to send the driver rate array as a separate
> netlink message though instead of in-band with CMD_FRAME, since it doesn't
> change per frame and amount of data sent over netlink in the datapath already
> imposes a performance limit.

It can change with every packet based on rate-control logic, right?

Possibly the power is mostly constant, but I thought I saw email about someone
working on rate-ctrl logic that adjusted power on a per-packet basis, so
thought it best to put in there now.

And, it seems unlikely to me that an extra 16 bytes or so would make a
great deal of difference.  Using hash tables instead of linear walks
and other things would likely improve performance more?

>
> Is your simulator available somewhere?

No, sorry..it is a closed source thing that I am working on with another
company...even I do not have any real rights to the code.  After a period
of time I may be able to start work on a similar simulator project, but for now all
I can contribute publicly is the kernel parts that must necessarily be open-source.

For what it's worth, the patch I posted seems to work with the user-space
app I've been working on.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
