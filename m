Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60952 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758709Ab3BKSS1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 13:18:27 -0500
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r1BIIQHW031452
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2013 10:18:26 -0800
Message-ID: <511935F2.8080103@candelatech.com> (sfid-20130211_191831_024754_819F1A9C)
Date: Mon, 11 Feb 2013 10:18:26 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: 3.7.6+:  ath9k:  tx logic locks up after taking attenuation very
 high.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have a test where we have 30 or so stations each passing slow
speed UDP traffic.  Between AP and station is an attenuator.

We automatically take the attenuation from 0 to 95 (actual rx signal
goes to around -80 due to RF leakage).

When the test is complete, attenuation is set back to 20, which is near
perfect for throughput.  However, none of the station interfaces can transmit
anything.  It seems the ath9k is hung with packets waiting to
be transmitted but no progress.

Kernel is moderately hacked 3.7.6+.

Bouncing the driver (resetting all interfaces on it, which causes
driver reset of one type or another), 'fixes' the problem.


[root@ct521-5359-F17x64 lanforge]# cat /debug/ieee80211/wiphy0/ath9k/xmit
Num-Tx-Queues: 10  tx-queues-setup: 0x10f poll-work-seen: 351348
                             BE         BK        VI        VO

MPDUs Queued:           169897          0         0    322175
MPDUs Completed:        168456          0         0    317321
MPDUs XRetried:           1441          0         0      4854
Aggregates:             309356          0         0         0
AMPDUs Queued HW:       419263          0         0         0
AMPDUs Queued SW:      2438246          0         0         0
AMPDUs Completed:      2850615          0         0         0
AMPDUs Retried:         151074          0         0         0
AMPDUs XRetried:          6060          0         0         0
TXERR Filtered:              0          0         0         0
FIFO Underrun:               5          0         0         0
TXOP Exceeded:               0          0         0         0
TXTIMER Expiry:              0          0         0         0
DESC CFG Error:              4          0         0         0
DATA Underrun:               0          0         0         0
DELIM Underrun:              5          0         0         0
TX-Pkts-All:           3026572          0         0    322175
TX-Bytes-All:       2199375974          0         0  14207045
hw-put-tx-buf:         1268553          0         0    306333
hw-tx-start:                 0          0         0         0
hw-tx-proc-desc:             0          0         0         0
TX-Failed:                   0          0         0         0
txq-memory-address:ffff88021583b018ffff88021583b128ffff88021583af08ffff88021583adf8
axq-qnum:                    2          3         1         0
axq-depth:                   0          0         0         0
axq-ampdu_depth:             0          0         0         0
axq-stopped                  1          0         0         0
tx-in-progress               0          0         0         0
pending-frames             125          0         0         0
txq_headidx:                 1          0         0         5
txq_tailidx:                 1          0         0         5
axq_q empty:                   1          1         1         1
axq_acq empty:                 1          1         1         1
txq_fifo[0] empty:             1          1         1         1
txq_fifo[1] empty:             1          1         1         1
txq_fifo[2] empty:             1          1         1         1
txq_fifo[3] empty:             1          1         1         1
txq_fifo[4] empty:             1          1         1         1
txq_fifo[5] empty:             1          1         1         1
txq_fifo[6] empty:             1          1         1         1
txq_fifo[7] empty:             1          1         1         1
[root@ct521-5359-F17x64 lanforge]#


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

