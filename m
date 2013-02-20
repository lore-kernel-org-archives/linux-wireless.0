Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47307 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3BTWvR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 17:51:17 -0500
Message-ID: <51255360.6060603@candelatech.com> (sfid-20130220_235121_277559_3DBF4FBE)
Date: Wed, 20 Feb 2013 14:51:12 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 3.7.6+:  ath9k:  tx logic locks up after taking attenuation very
 high.
References: <511935F2.8080103@candelatech.com> <20761.34987.125000.908722@gargle.gargle.HOWL> <511BC243.8010409@candelatech.com> <20770.57339.20017.225929@gargle.gargle.HOWL>
In-Reply-To: <20770.57339.20017.225929@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/18/2013 06:14 PM, Sujith Manoharan wrote:
> Ben Greear wrote:
>> On 02/11/2013 04:11 PM, Sujith Manoharan wrote:
>>> Ben Greear wrote:
>>>> axq-qnum:                    2          3         1         0
>>>> axq-depth:                   0          0         0         0
>>>> axq-ampdu_depth:             0          0         0         0
>>>> axq-stopped                  1          0         0         0
>>>> tx-in-progress               0          0         0         0
>>>> pending-frames             125          0         0         0
>>>
>>> The frames appear to be stuck in the pending queue.
>>
>> Any ideas on what code to go poking at?
>
> xmit.c would be a good place. Can you also post the kernel log with some
> debugging information ? debug=0x8f49 would be good.

I started working on this again.  Here's a better description of the test
case:

I have 32 stations connected to an AP, both ath9k, 3.7.9+ kernel.

Each station is configured to pass 64kbps traffic bi-directional
UDP traffic, 1500 byte packets.  The traffic is generated externally
(the AP is bridged to an ethernet device, the stations are bridged
in software using AF_PACKET sockets.

At attenuator sits between the two systems.

I ramp up the attenuation in 10db increments from 0 to 95.

At some point, the AP wedges it's xmit queue.  It appears it still
receives traffic fine (I see lots of packets coming in the AP
interface and going out the ethernet port).

On a second run, it was the station machine that locked up.
One thing that may be interesting:  queue V0 appears to be
passing traffic fine (at least as far as the ath9k xmit debugfs
file shows), but queue BE is wedged.

 From the AP lockup case, dmesg is full of stuff like this:

[ 1819.538577] vap1: delba from 00:3f:d1:e4:32:51 (initiator) tid 0 reason code 37
[ 1819.640602] vap1: Rx A-MPDU request on 00:6f:f9:68:b1:31 tid 0 result 0
[ 1819.690601] vap1: Rx A-MPDU request on 00:01:ab:ba:da:d3 tid 0 result 0
[ 1819.778013] vap1: RX session timer expired on 00:59:82:d1:d8:8c tid 0
[ 1819.778040] vap1: Rx BA session stop requested for 00:59:82:d1:d8:8c tid 0 recipient reason: 39
[ 1819.814600] vap1: delba from 00:59:82:d1:d8:8c (initiator) tid 0 reason code 37
[ 1819.820010] vap1: RX session timer expired on 00:eb:69:fc:4b:db tid 0
[ 1819.820034] vap1: Rx BA session stop requested for 00:eb:69:fc:4b:db tid 0 recipient reason: 39
[ 1819.863631] vap1: delba from 00:eb:69:fc:4b:db (initiator) tid 0 reason code 37
[ 1819.978012] vap1: RX session timer expired on 00:39:9a:d1:0e:10 tid 0
[ 1819.978035] vap1: Rx BA session stop requested for 00:39:9a:d1:0e:10 tid 0 recipient reason: 39
[ 1820.014580] vap1: delba from 00:39:9a:d1:0e:10 (initiator) tid 0 reason code 37
[ 1820.184596] vap1: Rx A-MPDU request on 00:3f:d1:e4:32:51 tid 0 result 0
[ 1820.192554] vap1: Rx A-MPDU request on 00:00:c5:89:c5:93 tid 0 result 0
[ 1820.578013] vap1: RX session timer expired on 00:dc:23:64:e2:f5 tid 0
[ 1820.578041] vap1: Rx BA session stop requested for 00:dc:23:64:e2:f5 tid 0 recipient reason: 39
[ 1820.610580] vap1: delba from 00:dc:23:64:e2:f5 (initiator) tid 0 reason code 37
[ 1820.635016] vap1: RX session timer expired on 00:fb:a4:41:62:1a tid 0
[ 1820.635045] vap1: Rx BA session stop requested for 00:fb:a4:41:62:1a tid 0 recipient reason: 39
[ 1820.664631] vap1: Rx BA session stop requested for 00:22:b6:3c:26:13 tid 0 inititator reason: 0
[ 1820.763599] vap1: Rx A-MPDU request on 00:22:b6:3c:26:13 tid 0 result 0
[ 1820.857649] vap1: Rx A-MPDU request on 00:e3:11:12:3a:14 tid 0 result 0


# From the AP lockup case:

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

