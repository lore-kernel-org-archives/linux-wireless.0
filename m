Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42027 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab0IUFZW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 01:25:22 -0400
Message-ID: <4C9841BA.4080700@candelatech.com>
Date: Mon, 20 Sep 2010 22:25:14 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath9k, multiple stations, and AMPDUs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think I have narrowed down some problems I see when I create
two STA interfaces on the same radio and associate with the
same AP.

I'm using wireless-testing plus some patches to the rx logic
I posted earlier.

It appears that the ath9k NIC does not transport AMPDUs properly,
and after a few seconds, it's backlog is exhausted and the queues
are stopped in ath_tx_start.

debugfs seems to agree:

[root@atom ~]# cat /debug/ath9k/phy0/xmit
                             BE         BK        VI        VO

MPDUs Queued:                2          0         0        85
MPDUs Completed:             2          0         0        85
Aggregates:                  0          0         0         0
AMPDUs Queued:             144          0         0         0
AMPDUs Completed:           20          0         0         0
AMPDUs Retried:             18          0         0         0
AMPDUs XRetried:             0          0         0         0
FIFO Underrun:               0          0         0         0
TXOP Exceeded:               0          0         0         0
TXTIMER Expiry:              0          0         0         0
DESC CFG Error:              0          0         0         0
DATA Underrun:               0          0         0         0
DELIM Underrun:              0          0         0         0
[root@atom ~]#


I can still receive packets on the interface, but nothing is
transmitted.

I tested against an a/b/g AP (instead of N), and it ran clean
for many minutes.

Any ideas how to debug this further?

Thanks,
Ben
	
-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
