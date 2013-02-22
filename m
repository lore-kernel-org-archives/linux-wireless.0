Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41092 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab3BVALS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 19:11:18 -0500
Message-ID: <5126B7A1.6030301@candelatech.com> (sfid-20130222_011122_476291_8AFAAC0A)
Date: Thu, 21 Feb 2013 16:11:13 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Sujith Manoharan <sujith@msujith.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 3.7.6+: ath9k: tx logic locks up after taking attenuation very
 high.
References: <511935F2.8080103@candelatech.com> <20761.34987.125000.908722@gargle.gargle.HOWL> <511BC243.8010409@candelatech.com> <20770.57339.20017.225929@gargle.gargle.HOWL> <51255360.6060603@candelatech.com> <51257304.10109@candelatech.com> <20773.31380.740958.31338@gargle.gargle.HOWL> <5125B39F.3010200@candelatech.com> <51265AC3.5030304@candelatech.com> <5126A993.8060408@candelatech.com> <CAJ-Vmo=FC=jdJ9VyZtZy_nbdGhCCfJ9dhS3993fwneGhFjoBJg@mail.gmail.com> <5126B368.9010209@candelatech.com> <CAJ-Vmom3v1+==u0RS8d6m+P-=DR8A755--t2_gQR+6Szf5N5VQ@mail.gmail.com>
In-Reply-To: <CAJ-Vmom3v1+==u0RS8d6m+P-=DR8A755--t2_gQR+6Szf5N5VQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/21/2013 03:56 PM, Adrian Chadd wrote:
> Right. As you increase attenuation, two things happen:
>
> * You're going to see lots more filtered frames pop up; which may
> involve pause/unpause of the queue;
> * You're going to see BAR frames go out, which will involve
> pausing/unpausing the queue.
>
> So you may have found some very nice way to reproduce pause/unpause
> related problems that are brought on by lots of TX failures leading to
> BARs and filtered frames.
>
> (Having your BAR frames be filtered .. god I hope not.)
>
> So see whether there's some odd scenario where a queue is unpaused and
> things aren't drained from the pending queue?

The hang I see is where the stats sit like this (below) and never change (for the first queue)


To me, the interesting part is that the BE queue is stopped while
axq-depth and axq-ampdu depth are zero.  I don't fully understand
this code..but I sort of expected the depths to be non-zero when
packets were being processed by the hardware..maybe that's totally
incorrect...

It seems to hang forever once it gets stuck in this case unless
I reset the chip.

I'm not sure if it's related, but the tx rates do not drop as low
as I believe they should.  These systems are using ath9k rate control,
and I plan to change that to minstrel_ht once I can get the current
config to at least recover when attenuation gets better....


[root@lf0301-demo1 ~]# cat /debug/ieee80211/wiphy0/ath9k/xmit ;sleep 10; cat /debug/ieee80211/wiphy0/ath9k/xmit ;
Num-Tx-Queues: 10  tx-queues-setup: 0x10f poll-work-seen: 1823
                             BE         BK        VI        VO

MPDUs Queued:              500          0         0      4102
MPDUs Completed:           473          0         0      4102
MPDUs XRetried:             27          0         0         0
Aggregates:                200          0         0         0
AMPDUs Queued HW:        97039          0         0         0
AMPDUs Queued SW:        11299          0         0         0
AMPDUs Completed:       107982          0         0         0
AMPDUs Retried:            410          0         0         0
AMPDUs XRetried:           116          0         0         0
TXERR Filtered:            224          0         0         0
FIFO Underrun:               0          0         0         0
TXOP Exceeded:               0          0         0         0
TXTIMER Expiry:              0          0         0         0
DESC CFG Error:              0          0         0         0
DATA Underrun:               0          0         0         0
DELIM Underrun:              0          0         0         0
TX-Pkts-All:            108598          0         0      4102
TX-Bytes-All:        164436206          0         0    304838
hw-put-tx-buf:          107863          0         0      4096
hw-tx-start:                 0          0         0         0
hw-tx-proc-desc:             0          0         0         0
TX-Failed:                   0          0         0         0
txq-memory-address:   f2b724e8   f2b725a4  f2b7242c  f2b72370
axq-qnum:                    2          3         1         0
axq-depth:                   0          0         0         0
axq-ampdu_depth:             0          0         0         0
axq-stopped                  1          0         0         0
tx-in-progress               0          0         0         0
pending-frames             123          0         0         0
txq_headidx:                 7          0         0         0
txq_tailidx:                 7          0         0         0
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
Num-Tx-Queues: 10  tx-queues-setup: 0x10f poll-work-seen: 1833
                             BE         BK        VI        VO

MPDUs Queued:              500          0         0      4140
MPDUs Completed:           473          0         0      4140
MPDUs XRetried:             27          0         0         0
Aggregates:                200          0         0         0
AMPDUs Queued HW:        97039          0         0         0
AMPDUs Queued SW:        11299          0         0         0
AMPDUs Completed:       107982          0         0         0
AMPDUs Retried:            410          0         0         0
AMPDUs XRetried:           116          0         0         0
TXERR Filtered:            224          0         0         0
FIFO Underrun:               0          0         0         0
TXOP Exceeded:               0          0         0         0
TXTIMER Expiry:              0          0         0         0
DESC CFG Error:              0          0         0         0
DATA Underrun:               0          0         0         0
DELIM Underrun:              0          0         0         0
TX-Pkts-All:            108598          0         0      4140
TX-Bytes-All:        164436206          0         0    306788
hw-put-tx-buf:          107863          0         0      4134
hw-tx-start:                 0          0         0         0
hw-tx-proc-desc:             0          0         0         0
TX-Failed:                   0          0         0         0
txq-memory-address:   f2b724e8   f2b725a4  f2b7242c  f2b72370
axq-qnum:                    2          3         1         0
axq-depth:                   0          0         0         0
axq-ampdu_depth:             0          0         0         0
axq-stopped                  1          0         0         0
tx-in-progress               0          0         0         0
pending-frames             123          0         0         0
txq_headidx:                 7          0         0         6
txq_tailidx:                 7          0         0         6
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

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

