Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:49397 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859AbZCNPdQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 11:33:16 -0400
Message-ID: <49BBCE18.4090606@nokia.com> (sfid-20090314_163320_627684_A72A886B)
Date: Sat, 14 Mar 2009 17:32:40 +0200
From: Kalle Valo <kalle.valo@nokia.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: don't drop null frames during software scan
References: <20090314144405.670.16447.stgit@tikku> <1237043931.5235.67.camel@johannes.local>
In-Reply-To: <1237043931.5235.67.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sat, 2009-03-14 at 16:44 +0200, Kalle Valo wrote:
>> ieee80211_tx_h_check_assoc() was dropping everything else than probe
>> requests during software scan. So the null frame with the power save
>> bit was dropped and AP never received it. This meant that AP never
>> buffered any frames for the station during software scan.
>>
>> Fix this by allowing to transmit both probe request and null frames
>> during software scan. Tested with stlc45xx.
> 
> Would it make sense to reorder the scan code instead?

Perhaps. I chose this path only because it was simple to implement :) 
I'll take a look at the scan code in more detail and fix it there.

Kalle

