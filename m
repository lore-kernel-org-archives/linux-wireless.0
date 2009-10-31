Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx71.mail.ru ([94.100.176.85]:51262 "EHLO mx71.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040AbZJaRed (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 13:34:33 -0400
Date: Sat, 31 Oct 2009 20:42:09 +0300
From: Nikolai ZHUBR <zhubr@mail.ru>
Message-ID: <48920002.20091031204209@mail.ru>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re[4]: ieee80211_tx_status: headroom too small
In-reply-To: <1257003344.3555.136.camel@johannes.local>
References: <1094614475.20091030230028@mail.ru>
 <200910310959.43260.IvDoorn@gmail.com>
 <1256981113.3555.92.camel@johannes.local>
 <200910311030.45582.IvDoorn@gmail.com>
 <1256981677.3555.94.camel@johannes.local>  <7724371.20091031172437@mail.ru>
 <1257003344.3555.136.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Saturday, October 31, 2009, 6:35:44 PM, Johannes Berg wrote:
>> net/mac80211/main.c:
>>         local->tx_headroom = max_t(unsigned int , local->hw.extra_tx_headroom,
>>                                    sizeof(struct ieee80211_tx_status_rtap_hdr));
>> 
>> drivers/net/wireless/rt*pci.c:
>>         rt2x00dev->hw->extra_tx_headroom = 0;
>> 
>> So, as a quick-and-dirty fix, should I replace "max_t(..." by "4 + max_t(...."
>> or "= 0" by "= 4" ?

> 4 + max ... should work if it's what we think it is. Let us know.

Yes, it removed those messages.
The actual speed is still not very high (like at 10Mbit maybe,
though 54Mbit is shown and the distance from the AP is very small,
so signal quality should be good I suppose) but it is ok for me.

Thank you!

Nikolai ZHUBR


> johannes


