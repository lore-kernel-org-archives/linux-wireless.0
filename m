Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:10990 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbYEOQpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 12:45:33 -0400
Received: by rv-out-0506.google.com with SMTP id l9so595566rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2008 09:45:32 -0700 (PDT)
Message-ID: <b6c5339f0805150945j8c3847ctd66f88180902a029@mail.gmail.com> (sfid-20080515_184537_460826_9C556202)
Date: Thu, 15 May 2008 12:45:32 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Zack Weinberg" <zackw@panix.com>
Subject: Re: Getting ath5k driver working with Thinkpad T61 [168c:1014]
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <eb97335b0805150741g252ba49ckbf1b493a46acf762@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <eb97335b0805141024w6afa864j860b312b072faa8a@mail.gmail.com>
	 <b6c5339f0805141138o5575095du1f12c62624c80630@mail.gmail.com>
	 <eb97335b0805141145v3436e0e3ld7bd2721cbf0d15f@mail.gmail.com>
	 <b6c5339f0805141209p4a8b1b2do1cb2ec1c11de07e8@mail.gmail.com>
	 <eb97335b0805150741g252ba49ckbf1b493a46acf762@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 15, 2008 at 10:41 AM, Zack Weinberg <zackw@panix.com> wrote:
>> Interesting...  can you confirm that madwifi also will not start from a cold
>> boot?
>
> Yes, madwifi will not start from a cold boot.

Ugh, well that is not good.  Does ndiswrapper work?  Unless anyone
else has ideas, I would suggest capturing a trace using mmiotrace and
ndiswrapper to see what is going on.  Someone on ath5k-devel list
might have a better idea.

>> Perhaps the best thing to do is add printks to ath5k_hw_nic_wakeup and see
>> where it hangs?
>
> It's not hanging. The very first call to ath5k_hw_set_power(ah,
> AR5K_PM_AWAKE, true, 0); from ath5k_hw_nic_wakeup fails with -EIO, and
> the driver gives up.

By 'hanging' I mean the register writes cease to do anything useful
and the card basically stops responding until you power off.  Madwifi
will even give "Card didn't behave as expected" in this case.  -EIO
means it couldn't wake up the chip after 1s, so if the first call to
ath5k_hw_set_power that doesn't work, we'll need a trace to see what
differences there are in a working setup.

-- 
Bob Copeland %% www.bobcopeland.com
