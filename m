Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:61295 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724AbZKBVgS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 16:36:18 -0500
Received: by ewy28 with SMTP id 28so5332806ewy.18
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2009 13:36:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091102194349.GA7709@hash.localnet>
References: <200910291330.26172.mb@bu3sch.de> <200910291406.03422.mb@bu3sch.de>
	 <200910291431.48388.mb@bu3sch.de>
	 <20091031202156.GA29825@hash.localnet>
	 <40f31dec0910312353w32aede90ib5e71545ca744389@mail.gmail.com>
	 <20091101131652.GA30381@hash.localnet>
	 <40f31dec0911010541l650513fg31ffcadd12698f0@mail.gmail.com>
	 <20091102194349.GA7709@hash.localnet>
Date: Mon, 2 Nov 2009 23:36:22 +0200
Message-ID: <40f31dec0911021336l45d185fewa5ce1ffb88f7db97@mail.gmail.com>
Subject: Re: ath5k AP issues
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Luis Rodriguez <mcgrof@gmail.com>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/11/2 Bob Copeland <me@bobcopeland.com>:
> On Sun, Nov 01, 2009 at 03:41:49PM +0200, Nick Kossifidis wrote:
>> So beacon-sent gated option doesn't work ?
>> Did you try also AR5K_DCU_MISC_ARBLOCK_IGNORE ?
>>
>> Also according to docs Beacon frames should use queue 9 and CAB should
>> use queue 8 (don't know why but docs say that these are the
>> appropriate DCUs), beacon-gated triggering might only work if we use
>> DCU 9 for beacons (now we are using queue 7 for beacons and queue 6
>> for cab).
>
> So the results of that testing aren't so good; I still couldn't get it
> to work.  See the following patch if you want to play with it.  Eventually
> TXDESC interrupt should fire and you would see:
>
> cabq: enqueued xxxxx
> cabq: processed xxxxx
>
> But that only happens with DBA gating, with BCN_SENT_GT I never see
> 'processed.'  Anything else to try?
>

Well let's enable them both :P

I still think that ready-time thing is evil, we should use a more accurate way.

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
