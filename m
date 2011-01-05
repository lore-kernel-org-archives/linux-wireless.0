Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53432 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab1AEBEo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 20:04:44 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p0514f8A013701
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 4 Jan 2011 17:04:41 -0800
Message-ID: <4D23C3A9.9020007@candelatech.com>
Date: Tue, 04 Jan 2011 17:04:41 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath9k and stuck xmit queue?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I added a patch to my tree to print out some extra info,
in particular the 'axq-stopped' bit.  I notice that when
I have 60 STA interfaces sometimes it seems to get stuck
and cannot send any data.  A printout of the debug in that
case is below.

This is from today's wireless-testing (2.6.37-rc8)

[root@lec2010-ath9k-1 ~]# cat /debug/ieee80211/wiphy0/ath9k/xmit
                             BE         BK        VI        VO

MPDUs Queued:             1534          0         0      8949
MPDUs Completed:          1534          0         0      8949
Aggregates:                 90          0         0         0
AMPDUs Queued:            1544          0         0         0
AMPDUs Completed:          896          0         0         0
AMPDUs Retried:             90          0         0         0
AMPDUs XRetried:             0          0         0         0
FIFO Underrun:               0          0         0         0
TXOP Exceeded:               0          0         0         0
TXTIMER Expiry:              0          0         0         0
DESC CFG Error:              0          0         0         0
DATA Underrun:               0          0         0         0
DELIM Underrun:              0          0         0         0
TX-Pkts-All:              2430          0         0      8949
TX-Bytes-All:          1473128          0         0    288734
axq-qnum:                    2          3         1         0
axq-depth:                   0          0         0         0
axq-stopped                  1          0         0         0
tx-in-progress               0          0         0         0
pending-frames             396          0         0         0

A minute or two later and it seems to recover, and traffic starts
going again.  I'm curious if anyone has any clues as to where the problem
might lie based on the output above.


[root@lec2010-ath9k-1 ~]# cat /debug/ieee80211/wiphy0/ath9k/xmit
                             BE         BK        VI        VO

MPDUs Queued:             1940          0         0     10360
MPDUs Completed:          1940          0         0     10360
Aggregates:                 95          0         0         0
AMPDUs Queued:            1895          0         0         0
AMPDUs Completed:         1153          0         0         0
AMPDUs Retried:             94          0         0         0
AMPDUs XRetried:            64          0         0         0
FIFO Underrun:               0          0         0         0
TXOP Exceeded:               0          0         0         0
TXTIMER Expiry:              0          0         0         0
DESC CFG Error:              0          0         0         0
DATA Underrun:               0          0         0         0
DELIM Underrun:              0          0         0         0
TX-Pkts-All:              3157          0         0     10360
TX-Bytes-All:          2184232          0         0    323587
axq-qnum:                    2          3         1         0
axq-depth:                   0          0         0         0
axq-stopped                  0          0         0         0
tx-in-progress               0          0         0         0
pending-frames              27          0         0         0


...but then it gets stuck again...

[root@lec2010-ath9k-1 ~]# cat /debug/ieee80211/wiphy0/ath9k/xmit
                             BE         BK        VI        VO

MPDUs Queued:             1943          0         0     12161
MPDUs Completed:          1943          0         0     12161
Aggregates:                 96          0         0         0
AMPDUs Queued:            2289          0         0         0
AMPDUs Completed:         1323          0         0         0
AMPDUs Retried:             94          0         0         0
AMPDUs XRetried:            64          0         0         0
FIFO Underrun:               0          0         0         0
TXOP Exceeded:               0          0         0         0
TXTIMER Expiry:              0          0         0         0
DESC CFG Error:              0          0         0         0
DATA Underrun:               0          0         0         0
DELIM Underrun:              0          0         0         0
TX-Pkts-All:              3330          0         0     12161
TX-Bytes-All:          2369384          0         0    368479
axq-qnum:                    2          3         1         0
axq-depth:                   0          0         0         0
axq-stopped                  1          0         0         0
tx-in-progress               0          0         0         0
pending-frames             248          0         0         0


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

