Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:49889 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaFEKvt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 06:51:49 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Firmware debugging patches?
References: <53891ACD.7070902@candelatech.com>
	<87wqczz3h9.fsf@kamboji.qca.qualcomm.com>
	<538CA904.4000508@candelatech.com>
	<87ioojz1b1.fsf@kamboji.qca.qualcomm.com>
	<538CB782.1000509@candelatech.com>
Date: Thu, 5 Jun 2014 13:51:43 +0300
In-Reply-To: <538CB782.1000509@candelatech.com> (Ben Greear's message of "Mon,
	2 Jun 2014 10:42:26 -0700")
Message-ID: <87k38vpr28.fsf@kamboji.qca.qualcomm.com> (sfid-20140605_125154_952594_30D19DE7)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

sorry for jumping in late, I get too much email as usual :/

Ben Greear <greearb@candelatech.com> writes:

> [Good stuff snipped, adding linux-wireless as this is a more
> general issue if we are going to consider general framework]
>
>
> Maybe we should start with goals before getting to implementation
> details.  Here's my wish list that is ath10k specific, but probably
> similar to other firmware users:
>
> 1)  We need the firmware crash text currently printed to
> /var/log/messages.
>
> 2)  It would be nice to get the firmware RAM and stack dumps at time of
> crash to debug more interesting crashes.
>
> 3)  It would be nice to know about firmware debug messages for
> the period of time directly before the crash (maybe 2-5 minutes?)
>
> 4)  It would be nice to have this interleaved with kernel, supplicant,
> and related logs.

I would add:

5) A generic user space interface so that the same user space tool can
   store firmware crash dumps from all wireless drivers and no need to
   reinvent the wheel.

> If we are storing crashes for something like ethtool to report, we need
> RAM and/or disk storage so the firmware RAM dumps and such can be stored until
> the user and/or automated tools ask for them.  We need some way to automatically
> clean up old crashes so disk/ram is not overly utilized.  For APs,
> they are low on both RAM and 'disk', so storing crash logs for any
> length of time may be problematic.

I think most, if not all, wireless drivers store the firmware binary in
RAM forever. I'm having hard time to believe that storing one instance
(the latest one) of firmware crash dump would make any difference.
That's why I'm not worried about RAM usage.

-- 
Kalle Valo
