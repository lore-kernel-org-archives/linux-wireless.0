Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37005 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbaBQToL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 14:44:11 -0500
Message-ID: <53026685.7040303@candelatech.com> (sfid-20140217_204416_011999_287CAF80)
Date: Mon, 17 Feb 2014 11:44:05 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Subject: Question on how encryption keys are supposed to be handled.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I've been debugging an issue where my ath10k firmware is running out of key
objects to allocate.  This could be a simple issue in the firmware, but first I
wanted to try to figure out how things are supposed to work.

What I see in my firmware is that near time of association it allocates
4 keys.  Two of them are multicast, and one of the multicast is index 0,
the second is index 1.

Then, some time later (probably on rekey), another multicast is added at index 2.

After that, key space is exhausted so I see errors in the kernel logs about adding
broadcast keys failing.

TCP and UDP traffic continues to flow, but I am not testing multicast traffic,
so maybe that would be failing.

So, question is:  Is it expected that the mcast keys keep being added at increasing
key indexes?  If so, what is the maximum index allowed?

Is this something primarily controlled at the supplicant level?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

