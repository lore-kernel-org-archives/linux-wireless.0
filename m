Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:54884 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbZKANlp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2009 08:41:45 -0500
Received: by ewy28 with SMTP id 28so4112939ewy.18
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2009 05:41:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091101131652.GA30381@hash.localnet>
References: <200910291330.26172.mb@bu3sch.de> <200910291406.03422.mb@bu3sch.de>
	 <200910291431.48388.mb@bu3sch.de>
	 <20091031202156.GA29825@hash.localnet>
	 <40f31dec0910312353w32aede90ib5e71545ca744389@mail.gmail.com>
	 <20091101131652.GA30381@hash.localnet>
Date: Sun, 1 Nov 2009 15:41:49 +0200
Message-ID: <40f31dec0911010541l650513fg31ffcadd12698f0@mail.gmail.com>
Subject: Re: ath5k AP issues
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Luis Rodriguez <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/11/1 Bob Copeland <me@bobcopeland.com>:
> On Sun, Nov 01, 2009 at 08:53:44AM +0200, Nick Kossifidis wrote:
>> 2009/10/31 Bob Copeland <me@bobcopeland.com>:
>> notice the AR5K_QCU_RDYTIMECFG_ENABLE. So it's probable that the queue
>> starts on time and we miss sync because we wait an extra ready-time
>> period.
>
> Yeah, I know -- I turned it off before running tests.  I don't
> think it ever ran the queue, or if it did it was very late.
>

So beacon-sent gated option doesn't work ?
Did you try also AR5K_DCU_MISC_ARBLOCK_IGNORE ?

Also according to docs Beacon frames should use queue 9 and CAB should
use queue 8 (don't know why but docs say that these are the
appropriate DCUs), beacon-gated triggering might only work if we use
DCU 9 for beacons (now we are using queue 7 for beacons and queue 6
for cab).


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
