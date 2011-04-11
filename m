Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51226 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab1DKXXQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 19:23:16 -0400
Received: by pzk9 with SMTP id 9so2174774pzk.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 16:23:16 -0700 (PDT)
Message-ID: <4DA38D97.1030407@gmail.com>
Date: Tue, 12 Apr 2011 09:24:07 +1000
From: Peizhao Hu <peizhao.research@gmail.com>
Reply-To: peizhao.research@gmail.com
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Wei Yin <yinwei@itee.uq.edu.au>
Subject: questions regarding the minstrel implementation on mac80211
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I am studying the minstrel rate control mechinsim in mac80211. I have 
observed a few strange problem with the current implementation of the 
minstrel on the mac80211. They are explained below:

1. Different DIFS values were used by madwifi 0.9.4 and mac80211.
In madwifi 0.9.4, the DIFS is set to 28 from the source code in the 
calc_usecs_unicast_packet() function.

However, according to the IEEE 802.11 2007 standard, the DIFS time for 
OFDM should be 34, which is 2 slot time plus a SIFS time shown in table 
17-15 in page 626 or described in page 271.

Why we have different DIFS values?

2. Another question is on how we calculate the frame transmission time

In the function "ieee80211_frame_duration()" within util.c on the 
mac80211 framework, the frame time is calculated as the following.
dur = 16; /* SIFS + signal ext */
dur += 16; /*  T_PREAMBLE = 16 usec */
dur += 4; /* T_SIGNAL = 4 usec */
dur += 4 * DIV_ROUND_UP((16 + 8 * (len + 4) + 6) * 10, 4 * rate); /* 
T_SYM x N_SYM */

In mac80211 based minstrel implementation, minstrel uses the able 
fuction to calculate the time for sending a data frame as well as 
sending an ack.

to our understanding the normal transmission time is calculated as below 
(assume no retransmission):
DIFS + contentionWindow + dataTime + SIFS + ackTime

where

dataTime=T_PREAMBLE + T_SIGNAL + T_SYM * N_SYM
ackTime is similar

but in Minstrel's implementation (using the above 
"ieee80211_frame_duration()" function), we effectively calculate the 
transmission time as

SIFS + contentionWindow + dataTime + SIFS + ackTime

So why there are two SIFS???

Any idea?

-- 
regards;

Peizhao
