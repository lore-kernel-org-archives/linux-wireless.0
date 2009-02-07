Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:26923 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbZBGFUy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Feb 2009 00:20:54 -0500
Received: by yx-out-2324.google.com with SMTP id 8so466364yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 06 Feb 2009 21:20:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090207050356.GA16457@hash.localnet>
References: <20090131023147.GE3342@makis> <20090204215706.GA5651@makis>
	 <20090205154532.M30551@bobcopeland.com>
	 <40f31dec0902051306m769712ecn858672ba24524c63@mail.gmail.com>
	 <20090207050356.GA16457@hash.localnet>
Date: Sat, 7 Feb 2009 07:20:52 +0200
Message-ID: <40f31dec0902062120o1234e462k450c7bc6f61d6753@mail.gmail.com> (sfid-20090207_062058_597720_DBF3E60C)
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

2009/2/7 Bob Copeland <me@bobcopeland.com>:
> On Thu, Feb 05, 2009 at 11:06:59PM +0200, Nick Kossifidis wrote:
>> I think this is because we call reset too many times. Try removing
>> call to reset from config_interface, after some tests i did it seems
>> wrong (we don't need to reset pcu and if we do, we don't need to reset
>> the whole chip and re run phy initialization etc). I don't get any
>> problems with ar2425 but i didn't get any before anyway (i never got a
>> hang, just a few bmiss interrupts, not a storm).
>
> Yep, with BMISS interrupts turned off and config_interface no longer
> calling reset, it's quite stable now.  Maybe there was some timing
> thing at play.  If we add a patch to remove those then I'm satisfied :)
>

O.K. do you want me to put these fixes on this patch or post a separate ?



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
