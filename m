Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host.zinkconsulting.com ([209.59.162.221]:32898 "EHLO
	host.zinkconsulting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbZEZAAH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2009 20:00:07 -0400
Received: from c-24-20-185-90.hsd1.wa.comcast.net ([24.20.185.90] helo=[192.168.77.23])
	by host.zinkconsulting.com with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.69)
	(envelope-from <galen@zinkconsulting.com>)
	id 1M8jNp-00008G-0y
	for linux-wireless@vger.kernel.org; Mon, 25 May 2009 19:15:05 -0400
Message-Id: <19A53295-8338-45FA-BBEA-C0D48766DBED@zinkconsulting.com>
From: Galen P Zink <galen@zinkconsulting.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Experimental Changes for Latency & Reliability
Date: Mon, 25 May 2009 16:15:02 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm experimenting with an application where adjusting the retransmit  
and rate control policies could optimize performance. For my  
application, latency, reliability and throughput are all concerns,  
with latency being the largest concern, followed by reliability and  
throughput.

I would appreciate comments on the changes I am considering for  
rc_80211_minstrel.c:

-------------------

A) Increase EWMA level to favor newer data more heavily, as in this  
application the link is in a fixed location (so past data is basically  
flat) but may experience occasional, random interference (generally  
very brief) and we want the best possible retry bitrates.

Change line 536:
mp->ewma_level = 75;
To:
mp->ewma_level = 90;



B) Increase EWMA update interval. The goal is to make the system jump  
to a lower rate much more quickly if needed, to reduce the risk of  
packet loss or very large retransmit delays.

Change line 551:
mp->update_interval = 100;
to:
mp->update_interval = 10;

Question: Is an update interval this tight going to impose a CPU  
performance issue? In these situations, we have plenty of CPU  
available (nor are we concerned about power usage), so I am skeptical  
this will be a major problem, but could this lead to a slowdown in the  
throughput due to internal bottlenecks / lack of threading?



C) Reduce the maximum segment size to reduce air latency and reduce  
the amount of data to be re-transmitted in the event of very brief  
packet losses. 1 ms at 300 mbit (MCS15) with short preambles only  
drops maximum frame size from ~64K to ~16K, which should not be too  
huge a performance impact, though it may be noticeable for some loads.  
I can do this fairly safely as I know I will normally be operating at  
a very high bitrate, whereas if I was at a very low bitrate normally,  
the throughput impact could be much larger.

Change line 539:
mp->segment_size = 6000;
to:
mp->segment_size = 500;

Question: Have I changed all the appropriate code, or does code  
elsewhere need changing to alter the maximum segment size for all  
traffic? Is reducing the maximum segment size going to scale the  
maximum segment size down smoothly, without breaking anything else?



D) Standardize the maximum number of retries

Change line 541:
	if (hw->max_rate_tries > 0)
		mp->max_retry = hw->max_rate_tries;
	else
		/* safe default, does not necessarily have to match hw properties */
		mp->max_retry = 7;

to:

/*	if (hw->max_rate_tries > 0)
		mp->max_retry = hw->max_rate_tries;
	else
		/* safe default, does not necessarily have to match hw properties */
		mp->max_retry = 7;

Question: Will this work properly with all cards?



E) Reduce the lookaround rate, as our link is generally stable, and  
unexpected events that occur are very abrupt and unlikely to be  
detected in advance through the look-around. This will hopefully help  
throughput a bit, without hurting reliability.

Change line 532:
	mp->lookaround_rate = 5;
	mp->lookaround_rate_mrr = 10;
to:
	mp->lookaround_rate = 2;
	mp->lookaround_rate_mrr = 4;



---------------

These changes seem like they'd help with my goals, but I'm not  
experienced with this codebase, so I could be breaking a whole range  
of things. Also, I am intending to use these changes with Atheros  
cards in access point mode and Intel 5300 cards in station mode. Any  
special considerations for those cards, especially

I'd appreciate comments, suggestion, discussion, etc. before I build  
these changes and test in the field. (Field testing is a bit of a  
project...)

-Galen
