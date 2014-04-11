Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44343 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaDKE7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2014 00:59:44 -0400
Message-ID: <5347769F.2020808@candelatech.com> (sfid-20140411_065949_057735_B1050078)
Date: Thu, 10 Apr 2014 21:59:11 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>, ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFTv2 3/5] ath10k: rework peer accounting
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com> <1397040531-6224-1-git-send-email-michal.kazior@tieto.com> <1397040531-6224-4-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1397040531-6224-4-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/09/2014 03:48 AM, Michal Kazior wrote:
> It was troublesome to iterate over peers and
> perform sleepable calls. This will be necessary
> for some upcomming changes to tx flushing.

Just FYI, I tried all yesterday to get my system stable with all
of your RFT patches applied, but it just has all sorts of issues.
I think much of it relates to the management flush logic, perhaps
all the time it spends under lock (including RTNL lock I think)
just makes my system fall apart.

Possibly related to my peculiar environment & firmware, for sure.

I backed out your last two, leaving this one and the two previous,
and it runs better.  I still see the tx-credits hang (this time,
when I tried resetting all 32 stations while transmitting packets),
but at least the stations come up and can transmit packets most of
the time.

Even in the 'mostly working' state, resetting interfaces while
they and other vifs are under heavy packet load can effectively
lock up my user-space app, and things like 'ifconfig -a'
can take 10s of seconds to complete.  So, I probably need
to mitigate more of the sleeps related to flushing somehow.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

