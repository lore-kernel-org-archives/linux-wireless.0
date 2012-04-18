Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47285 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab2DROiN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 10:38:13 -0400
Message-ID: <4F8ED1D0.1070401@sipsolutions.net> (sfid-20120418_163818_235359_0D59661D)
Date: Wed, 18 Apr 2012 07:38:08 -0700
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RFCv1] mac80211: Adds Software / Virtual AMP 80211
References: <1334059909-20513-1-git-send-email-Andrei.Emeltchenko.news@gmail.com> <1334059909-20513-2-git-send-email-Andrei.Emeltchenko.news@gmail.com> <4F846257.1060807@sipsolutions.net> <1334092668.16897.54.camel@aeonflux> <4F84A422.3030900@sipsolutions.net> <4F84A52A.7050905@sipsolutions.net> <20120411071119.GC17779@aemeltch-MOBL1> <1334714611.3725.34.camel@jlt3.sipsolutions.net> <20120418121551.GE19228@aemeltch-MOBL1>
In-Reply-To: <20120418121551.GE19228@aemeltch-MOBL1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/18/2012 5:15 AM, Andrei Emeltchenko wrote:
>> It's never in your best interest to run one supplicant per virtual
>> interface, you want to run one per piece of hardware so it can
>> coordinate between virtual interfaces.
>
> Do I understand it right that virtual interfaces are like separate devices from
> user point of view? If I create virtual interface and assign MAC I can
> transfer data through it without affecting other interfaces? Then
> wpa_supplicant does not need to know about it at all.

No, this is incorrect. If one device wants to connect on one channel, 
the other typically has to use the same channel. If one device wants to 
scan, the other will be affected. Some hardware may support switching 
around between two channels, but might also support more than 2 virtual 
interfaces, so again they won't be independent.

Therefore, you need something managing all this concurrency. This is in 
a small part the driver which will enforce restrictions (it will reject 
new impossible things), but mostly the supplicant which can make policy 
decisions about which usage should win.

johannes
