Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.242]:52683 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbYFYA4W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 20:56:22 -0400
Received: by an-out-0708.google.com with SMTP id d40so761384and.103
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2008 17:56:21 -0700 (PDT)
Message-ID: <40f31dec0806241756j2916da61n42e6a7b5ea556ea7@mail.gmail.com> (sfid-20080625_025628_764398_4D93AE44)
Date: Wed, 25 Jun 2008 03:56:21 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: RFC: always enable MAC80211_RC_PID?
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Adrian Bunk" <bunk@stusta.de>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
In-Reply-To: <1214298259.8967.260.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080622125553.GB22539@cs181133002.pp.htv.fi>
	 <43e72e890806220804i347b942claae7b725231afcce@mail.gmail.com>
	 <1214298259.8967.260.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/6/24 Johannes Berg <johannes@sipsolutions.net>:
>
>> You can currently only get away living without it if you are just
>> using iwl3945 or iwl4965 as they provide their own rate control
>> algorithms. In the future if other vendor drivers are added with their
>> own rate control algorithm this list grows.
>
> FWIW, I would like to see those algorithms be supported as part of
> mac80211 and not be internal like iwlwifi hacked them on, and have some
> sort of feature negotiation between the hardware and the RC algorithm
> when choosing one.
>
> johannes
>

I also agree on that, this way we can eg. port samplerate or minstrel
from MadWiFi to mac80211 for any card that can do multirate
transmitions for example, not only Atheros cards.

We need however a fallback algorithm compiled in by default if we go
that way because the user might not know what algorithms are
compatible with his card during kernel configuration. I guess PID is
generic enough for this.

Also ideally the user should be able to change rate control algorithm
during runtime (without the need to reload the driver), i think having
rate control inside mac80211 makes it easier.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
