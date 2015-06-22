Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34624 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbbFVKiH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 06:38:07 -0400
Received: by pabvl15 with SMTP id vl15so85399585pab.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 03:38:07 -0700 (PDT)
Received: from [10.244.11.15] ([196.12.45.164])
        by mx.google.com with ESMTPSA id ho10sm19390347pbc.27.2015.06.22.03.38.05
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jun 2015 03:38:06 -0700 (PDT)
Message-ID: <5587E598.1050805@gmail.com> (sfid-20150622_123811_517649_B3DB4CFF)
Date: Mon, 22 Jun 2015 16:08:16 +0530
From: Raghavendra Rao <raghav3276@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: IEEE1609.4 support for Linux
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

We are developing IEEE1609.4 [1] protocol as a part of Wireless Access in
Vehicular Environment (WAVE) stack for the Linux Kernel.

The responsibilities of the protocol are as follows :
-- Channel Co-ordination and synchronization
-- Channel Routing

The protocol generally holds two kinds of channels: Service Channel (SCH)
and Control Channel (CCH). SCH is mainly used to send the data packets,
while the CCH is used to send control as well as data packets. The radio
switches between these two channels as configured.

Channel Co-ordination and synchronization
==========================
The switching between SCH and CCH can be achieved in many
modes (Continuous CCH, SCH, Alternating, Immediate SCH). Each of the
channel slot is given 50 ms of time slice, where in which, the first 4 
ms is
generally used as a guard band for changing the channel. The end objective
is such that, two or more communicating devices should be synchronized
at the same channel for the exchange of data. This is where the concept
of channel synchronization and coordination comes.

Problem :
As mentioned earlier, a guard band of 4ms is introduced to switch the 
channels.
But, few of the devices might complete it in 2.5ms (say) and few in 
3.5ms (say),
depending on the load of the system. Now, to achieve the 
synchronization, we need
to make sure that no device is transmitting the data during this 4ms, 
even though
it has switched the channel before 4ms. Thus, we need to switch off the 
transmitter
some how for these 4ms. The other side of the story is, we need to keep 
the Tx
packet queuing, and also the Rx ON during these period.

So, the queries are as follows :
How this can be achieved?
How to disable the transmitter?
Will it be driver specific?

Any help is appreciated.

Thanks and Regards,
Raghavendra

[1] : http://ieeexplore.ieee.org/xpl/mostRecentIssue.jsp?punumber=5712767
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
