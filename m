Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60744 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab1AFXjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 18:39:04 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p06Nd3Vt019207
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 6 Jan 2011 15:39:04 -0800
Message-ID: <4D265297.4010009@candelatech.com>
Date: Thu, 06 Jan 2011 15:39:03 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k and stuck xmit queue?
References: <4D23C3A9.9020007@candelatech.com>
In-Reply-To: <4D23C3A9.9020007@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/04/2011 05:04 PM, Ben Greear wrote:
> I added a patch to my tree to print out some extra info,
> in particular the 'axq-stopped' bit. I notice that when
> I have 60 STA interfaces sometimes it seems to get stuck
> and cannot send any data. A printout of the debug in that
> case is below.

I found a similar scenario, but to me even weirder:

Note that the queue is stopped, but has no depth, and not
even any pending frames?

I do notice that the hw-tx-start is less than the number of
processed descriptors.  That seems to normally go along with
the tx-hang issues..perhaps caused by chip resets or similar?

hw-tx-start:             53128          0         0     37325
hw-tx-proc-desc:         53103          0         0     37200
txq-memory-address:   de70b3d0   de70b464  de70b33c  de70b2a8
axq-qnum:                    2          3         1         0
axq-depth:                   0          0         0         0
axq-ampdu_depth:             0          0         0         0
axq-stopped                  1          0         0         0
tx-in-progress               0          0         0         0
pending-frames               0          0         0         0
txq_headidx:                 0          0         0         0
txq_tailidx:                 0          0         0         0
axq_q empty:                   0          1         1         0
axq_acq empty:                 1          1         1         1
txq_fifo_pending:              1          1         1         1
txq_fifo[0] empty:             1          1         1         1
txq_fifo[1] empty:             1          1         1         1
txq_fifo[2] empty:             1          1         1         1
txq_fifo[3] empty:             1          1         1         1
txq_fifo[4] empty:             1          1         1         1
txq_fifo[5] empty:             1          1         1         1
txq_fifo[6] empty:             1          1         1         1
txq_fifo[7] empty:             1          1         1         1

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

