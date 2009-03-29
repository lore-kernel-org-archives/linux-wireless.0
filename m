Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:42910 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbZC2V3p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 17:29:45 -0400
Received: by ewy9 with SMTP id 9so1818092ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 29 Mar 2009 14:29:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <40f31dec0903291423s384a98b5l8f86b317aeb5c9a4@mail.gmail.com>
References: <20090315202035.GC5246@makis>
	 <200903292109.55033.rossi.f@inwind.it>
	 <40f31dec0903291335j2befd3b4r1b4f4619ae634113@mail.gmail.com>
	 <200903292204.44260.rossi.f@inwind.it>
	 <40f31dec0903291423s384a98b5l8f86b317aeb5c9a4@mail.gmail.com>
Date: Mon, 30 Mar 2009 00:29:42 +0300
Message-ID: <40f31dec0903291429w5b904ca5nabe39852213dc5a8@mail.gmail.com> (sfid-20090329_232952_520389_28BB1B2E)
Subject: Re: [PATCH 3/3] ath5k: Add tx power calibration support
From: Nick Kossifidis <mickflemm@gmail.com>
To: Fabio Rossi <rossi.f@inwind.it>
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Does also your board support 802.11abg? I don't understand why the noise
>> calibration process remains stuck @ 5.18GHz.
>>

5.18 is the first channel on 5GHz band and 5GHz band is the band we
start with, so it's the first channel the driver sets.

> My initial thought was that one of the cpus was stuck, running the
> calibration function again and again which would result what you
> describe.

Well that's of course extreme, but i can't explain why you can't
unload the module or why you get higher cpu utilization. I mean it
seems only the calibration function gets called (if reset function got
called then we would have more than 6 nf timeout failures since reset
also performs a nf calibration) and nothing else works. It could be an
interrupt storm but i don't understand why this patch triggers it.




-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
