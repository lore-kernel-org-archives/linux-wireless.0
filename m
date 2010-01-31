Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f173.google.com ([209.85.223.173]:59672 "EHLO
	mail-iw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab0AaTIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2010 14:08:18 -0500
Received: by iwn3 with SMTP id 3so3659760iwn.23
        for <linux-wireless@vger.kernel.org>; Sun, 31 Jan 2010 11:08:18 -0800 (PST)
Message-ID: <4B65D51F.1090903@lwfinger.net>
Date: Sun, 31 Jan 2010 13:08:15 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression in b43 with BCM4311/2
References: <4B64A2F2.6060608@lwfinger.net>	 <1264887027.3546.207.camel@johannes.local>  <4B64AAEB.9020806@lwfinger.net> <1264888699.3546.208.camel@johannes.local>
In-Reply-To: <1264888699.3546.208.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

I finally sorted this out. The patch in question (c7ab5ef) is the bad one, but
not the basic response rate part.

Going back to the code that worked, I discovered that the routines
b43_short_slot_timing_enable/disable() were never called. Once the new code
touched the shared memory location 0x0010, the transmit performance dropped way
off. If I let the new code adjust the Interframe Slot time in MMIO space, but
not the shared memory location, the transmit rate in my BCM4311/2 went from a
maximum of 18 to 22 Mb/s. This problem did not affect the 0x4315 device as the
memory was changed only for G PHYs. I think that should be for 2GHz, and have
made that adjustment. I have not yet tested that with the LP PHY. Once I do, I
will post a patch for comment and testing.

Thanks for helping me understand the basic response rates.

Larry
