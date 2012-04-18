Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43841 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab2DRPJJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 11:09:09 -0400
Message-ID: <4F8ED913.4040807@sipsolutions.net> (sfid-20120418_170926_285914_2C38BB60)
Date: Wed, 18 Apr 2012 08:09:07 -0700
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RFCv1] mac80211: Adds Software / Virtual AMP 80211
References: <1334059909-20513-1-git-send-email-Andrei.Emeltchenko.news@gmail.com> <1334059909-20513-2-git-send-email-Andrei.Emeltchenko.news@gmail.com> <4F846257.1060807@sipsolutions.net> <1334092668.16897.54.camel@aeonflux> <4F84A422.3030900@sipsolutions.net> <4F84A52A.7050905@sipsolutions.net> <20120411071119.GC17779@aemeltch-MOBL1> <1334714611.3725.34.camel@jlt3.sipsolutions.net> <20120418121551.GE19228@aemeltch-MOBL1> <4F8ED1D0.1070401@sipsolutions.net> <20120418145202.GH19228@aemeltch-MOBL1>
In-Reply-To: <20120418145202.GH19228@aemeltch-MOBL1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrei,

>> No, this is incorrect. If one device wants to connect on one
>> channel, the other typically has to use the same channel. If one
>> device wants to scan, the other will be affected. Some hardware may
>> support switching around between two channels, but might also
>> support more than 2 virtual interfaces, so again they won't be
>> independent.
>
> BTW: which devices can switch channels?

None today, I'm working on it.

>> Therefore, you need something managing all this concurrency. This is
>> in a small part the driver which will enforce restrictions (it will
>> reject new impossible things), but mostly the supplicant which can
>> make policy decisions about which usage should win.
>
> This doesn't sound like a rocket science to me. IMO this might be done in
> drivers. Those drivers which can switch channels why do they need
> wpa_supplicant involved making this decision?

I don't think you understand.

Say our device can do 3 virtual interfaces, on 2 channels. Then if the 
user is connected to some managed network (say office network), one 
interface & channel is used up. Now the user has AMP running, another 
channel might be used up. Now the user wants to do P2P negotiation. Now 
the supplicant, which is doing the negotiation, needs to know that it 
can negotiate only one of those two channels, not any other. Or maybe 
P2P should win, then it might disconnect the AMP or the managed 
connection. But all those are policy decisions, so the driver can't 
really handle them.

johannes
