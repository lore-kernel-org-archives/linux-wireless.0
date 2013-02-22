Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60743 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620Ab3BVLgd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 06:36:33 -0500
Message-ID: <51275837.4020708@openwrt.org> (sfid-20130222_123636_575333_EFB64A7F)
Date: Fri, 22 Feb 2013 12:36:23 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Sujith Manoharan <sujith@msujith.org>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [RFC] ath9k: Detect and work-around tx-queue hang.
References: <1361498797-14361-1-git-send-email-greearb@candelatech.com> <20774.62475.588131.344540@gargle.gargle.HOWL> <5126F732.6040007@candelatech.com> <20774.63702.208829.602903@gargle.gargle.HOWL> <51270186.6070003@candelatech.com>
In-Reply-To: <51270186.6070003@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-02-22 6:26 AM, Ben Greear wrote:
> On 02/21/2013 08:49 PM, Sujith Manoharan wrote:
>> Ben Greear wrote:
>>> I'll be happy to test patches, but I'm not sure how to go about
>>> debugging the real problem on my own.  Maybe some stats could
>>> be added to the xmit debugfs file to help diagnose the problem,
>>> or maybe some other debugfs info will help?
>>>
>>> I can't reproduce the problem with ath9k debugging set at the
>>> previous suggested level, so it would have to be something
>>> less invasive.
>>>
>>> As for just stations going out of range, it remains locked up
>>> even with signal level goes back to -20, so it's not just a simple
>>> station-out-of range issues..
>>
>> Sure, but I think that filtered frames are not handled properly,
>> especially with aggregation, since the debugfs stats from your earlier email
>> showed a large counter (from a private patch ?):
>>
>> TXERR Filtered:            224          0         0         0
> 
> Yeah, guess that patch never made it upstream.  The pertinent bit is:
Please also check if the station(s) that the frames are queued for are
in powersave state for some reason. That would prevent the tx path from
throwing them in the hw queue, yet they'd still take up pending-frame
slots. I was planning on fixing this eventually by expiring frames that
stay in the queue for too long, but haven't decided on the exact
approach yet.

- Felix

