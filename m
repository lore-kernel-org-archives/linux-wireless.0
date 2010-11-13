Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35368 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab0KMSTl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Nov 2010 13:19:41 -0500
Message-ID: <4CDED6B7.1060605@candelatech.com>
Date: Sat, 13 Nov 2010 10:19:35 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Scanning improvements for multiple VIFS.
References: <4CDDCC72.6070006@candelatech.com> <4CDDE324.3070801@candelatech.com> <4b2689e6064549781b072ac8956bcc1a@localhost>
In-Reply-To: <4b2689e6064549781b072ac8956bcc1a@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/2010 09:19 PM, Johannes Berg wrote:
>>> In nl80211_trigger_scan, if rdev->scan_req is != NULL,
>>> instead of returning EBUSY, what if we set a flag in
>>> the VIF that said "I want scan results too."
>>>
>>> Then, when whatever is scanning is finished, it would send
>>> scan results to all interested vifs.
>
> But the scans results could technically be different
> if they've been done on a different interface. Besides,

I was wondering about that...I was hoping that some results
were better than none, and that supplicant or whatever would
re-scan if it didn't find what it was looking for.

I'd also be happy to add a flag that would allow user-space
to request this feature enabled or not per-scan attempt,
and disable it by default so that no one is surprised by new
behaviour.

> you can handle it in userspace. You've been trying for
> weeks to avoid changing your userspace by changing the
> kernel, which is still the wrong approach.

 From what I can tell, you are right about wpa_supplicant
controlled interfaces (perhaps requires some supplicant hacking,
but logically it can be done), but what about non-encrypted
interfaces that do not even need supplicant?  It seems
user-space has very little to do with how these scan and
associated aside from setting the initial values.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
