Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f21.google.com ([209.85.217.21]:54533 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbZBEVG7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 16:06:59 -0500
Received: by mail-gx0-f21.google.com with SMTP id 14so483656gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 05 Feb 2009 13:06:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090205154532.M30551@bobcopeland.com>
References: <20090131023147.GE3342@makis> <20090204215706.GA5651@makis>
	 <20090205154532.M30551@bobcopeland.com>
Date: Thu, 5 Feb 2009 23:06:59 +0200
Message-ID: <40f31dec0902051306m769712ecn858672ba24524c63@mail.gmail.com> (sfid-20090205_220718_668006_0B990EED)
Subject: Re: [PATCH 5/5] ath5k: Update reset code
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/2/5 Bob Copeland <me@bobcopeland.com>:
> On Wed, 4 Feb 2009 23:57:06 +0200, Nick Kossifidis wrote
>> * Update reset and sync with HALs
>>  * Clean up eeprom settings and tweaking of initvals and put them on
> separate functions
>>  * Set/Restore 32KHz ref clk operation
>>  * Add some more documentation
>>  TODO: Spur mitigation, tpc, half/quarter rate, compression etc
>>
>>  v2: Address comments from Bob and Felix and fix RSSI threshold bug
>>  introduced on the first version of the patch
>>
>>  Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>
>
> This works much better, except I still get some hard hangs
> occasionally.  Doesn't appear to be bmiss storm this time.  I did it
> with a VT up and didn't get an oops; I guess I'll try a serial console
> or some printks.
>
> I could trigger it via a few suspend-resume cycles, so I guess it's the
> reset from ath5k_init().  Did you still have any problems with the 2425?
>

I think this is because we call reset too many times. Try removing
call to reset from config_interface, after some tests i did it seems
wrong (we don't need to reset pcu and if we do, we don't need to reset
the whole chip and re run phy initialization etc). I don't get any
problems with ar2425 but i didn't get any before anyway (i never got a
hang, just a few bmiss interrupts, not a storm).



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
