Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([193.35.52.29]:38081 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaJFOyk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 10:54:40 -0400
Date: Mon, 6 Oct 2014 16:54:34 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v6 2/2] mac80211: support DTPC IE (from Cisco Client
 eXtensions)
Message-ID: <20141006145434.GA35618@sesse.net> (sfid-20141006_165443_577345_74ADB65C)
References: <20140903133328.GC18933@sesse.net>
 <E1XPB2h-0008WO-MS@pannekake.samfundet.no>
 <1410166400.7983.9.camel@jlt4.sipsolutions.net>
 <20140916234647.GA2238@sesse.net>
 <1412607134.3098.25.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1412607134.3098.25.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 06, 2014 at 04:52:14PM +0200, Johannes Berg wrote:
>> I found what I believe is an edge case: What happens if the element suddenly
>> goes away from one beacon to another? Shouldn't there be a reset of the power
>> level and then a new call to __ieee80211_recalc_txpower()?
>> 
>> (If so, I believe this bug was already present in the code before my first
>> patch, as I understand the existing logic.)
> I'm not sure it's worth worrying about, but if you want to write a patch
> I'd take it :)

It actually happened to me in a real situation, which is why I noticed.
It seems neither power element is typically sent at all if the value is 0.
(Well, Aruba seems to do. I haven't found anyone else who does.)

/* Steinar */
-- 
Homepage: http://www.sesse.net/
