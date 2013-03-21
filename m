Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:43842 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087Ab3CUNg5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 09:36:57 -0400
Received: by mail-ee0-f49.google.com with SMTP id d41so1706281eek.36
        for <linux-wireless@vger.kernel.org>; Thu, 21 Mar 2013 06:36:54 -0700 (PDT)
Message-ID: <514B0CF4.40806@gmail.com> (sfid-20130321_143701_138755_EF50814A)
Date: Thu, 21 Mar 2013 14:36:52 +0100
From: Giovanni Di Stasi <gdistasi@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: neighbor deleted from arp table after ibss leave
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone,

I  have noticed a different behaviour related to the way the arp table 
is managed depending on the tool I use to configure the interfaces 
(iwconfig or iw).

In particular, I considered the following two cases (ath5k used for both).

First case: I create the interface with iw (in ad-hoc mode), then I set 
the essid and the channel with iwconfig. After a while (several minutes) 
I change the channel with iwconfig in order to join a different ibss 
(with the same essid) on the new channel. The kernel used was 3.0.

Second case: I create the interface with iw (in ad-hoc mode), then I 
join an ibss (on a certain essid) setting at the same time the freq (in 
fixed-freq mode), with iw. After a while I leave the ibss and join 
another ibss on a different channel with iw (by first issuing iw ibss 
leave and then iw ibss join on the new channel). The kernel used was 3.2.

It seemed to me that in both cases the "current" ibss was left and the 
new one was joined (by looking at dmesg output). However, in the second 
case, I noticed some arp requests just after the ibss join, while in the 
first case no arp request at all. Is it due to the fact that in the 
second scenario the arp table was erased? Is that a known behavior?
It would be useful for me to know that as unfortunately I cannot easily 
repeat the two tests;  I would therefore be glad if some of you could 
give me some hints on what has been happening in the second case that 
triggered the arp requests (I can say almost for sure that it was not 
due to the arp timeout because the timeout was larger and I got the same 
results for different repetitions, i.e. arp request just after the ibss 
join).

Thanks in advance,
Giovanni

