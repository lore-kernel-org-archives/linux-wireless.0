Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:35035 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752369AbXK0PHz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 10:07:55 -0500
Message-ID: <474C32CB.9090301@lwfinger.net> (sfid-20071127_150759_398839_55CC30F7)
Date: Tue, 27 Nov 2007 09:07:55 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Mattias Nissler <mattias.nissler@gmx.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [RFC/T][PATCH][V3] mac80211: Exponential moving average	estimate
 for rc80211_simple
References: <1196112605.8318.6.camel@localhost>	 (sfid-20071126_213044_416915_EDBE20FD) <1196172814.6058.23.camel@johannes.berg>
In-Reply-To: <1196172814.6058.23.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Mon, 2007-11-26 at 22:30 +0100, Mattias Nissler wrote:
>> This changes rc80211_simple failed frame percentage estimation to use an
>> exponential moving average method. Failed frames percentage is sampled over
>> time and a smoothed average is computed. This average is examined periodically
>> and the rate adjusted eventually.
>>
>> Compared to the old method this new approach is much more responsive. The old
>> method used plain tx success/failure counters. This made rate control very
>> unresponsive after a short time of using the interface, since old data wouldn't
>> age properly.
> 
> Sounds sane and better than before. If it works we can apply this I
> guess.

I have not done any rigorous testing of this patch; however, it has not caused any harm on my system.

Larry
