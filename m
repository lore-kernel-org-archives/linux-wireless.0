Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 9.mo178.mail-out.ovh.net ([46.105.75.45]:43198 "EHLO
        9.mo178.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751859AbeEPGcJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 02:32:09 -0400
Received: from player746.ha.ovh.net (unknown [10.109.105.75])
        by mo178.mail-out.ovh.net (Postfix) with ESMTP id CBCAF1600B
        for <linux-wireless@vger.kernel.org>; Wed, 16 May 2018 07:55:11 +0200 (CEST)
Reply-To: alexander@wetzel-home.de
Subject: Re: ath10k wake_tx_queue issues
To: Niklas Cassel <niklas.cassel@linaro.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>
Cc: johannes@sipsolutions.net, kvalo@qca.qualcomm.com,
        erik.stromdahl@gmail.com, Felix Fietkau <nbd@nbd.name>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
References: <20180515134516.GA30397@localhost.localdomain>
 <87d0xx0zxf.fsf@toke.dk> <20180515203102.GA20469@localhost.localdomain>
From: Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <668a5f16-52b2-0a43-49d2-236f892fc1f1@wetzel-home.de> (sfid-20180516_083215_181801_9BE0C386)
Date: Wed, 16 May 2018 07:54:54 +0200
MIME-Version: 1.0
In-Reply-To: <20180515203102.GA20469@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

This sounds exactly like the issue I just submitted a patch for.
Can you test https://patchwork.kernel.org/patch/10399613/ if that solves
the issue?



Am 15.05.2018 um 22:31 schrieb Niklas Cassel:
> On Tue, May 15, 2018 at 04:13:48PM +0200, Toke Høiland-Jørgensen wrote:
>> [ Adding Felix ]
>>
>>
>> Niklas Cassel <niklas.cassel@linaro.org> writes:
>>
>>> Hello mac80211 and ath10k people
>>>
>>> Using ath10k, TX stops working when running iperf
>>>
>>> [  3]  0.0- 1.0 sec  2.00 MBytes  16.8 Mbits/sec
>>> [  3]  1.0- 2.0 sec  3.12 MBytes  26.2 Mbits/sec
>>> [  3]  2.0- 3.0 sec  3.25 MBytes  27.3 Mbits/sec
>>> [  3]  3.0- 4.0 sec   655 KBytes  5.36 Mbits/sec
>>> [  3]  4.0- 5.0 sec  0.00 Bytes  0.00 bits/sec
>>> [  3]  5.0- 6.0 sec  0.00 Bytes  0.00 bits/sec
>>> [  3]  6.0- 7.0 sec  0.00 Bytes  0.00 bits/sec
>>> [  3]  7.0- 8.0 sec  0.00 Bytes  0.00 bits/sec
>>> [  3]  8.0- 9.0 sec  0.00 Bytes  0.00 bits/sec
>>> [  3]  9.0-10.0 sec  0.00 Bytes  0.00 bits/sec
>>> [  3]  0.0-10.3 sec  9.01 MBytes  7.32 Mbits/sec
>>>
>>> The problem can be reproduced without specifying a send buffer size,
>>> however, specifying a small send buffer helps to reproduce the problem faster.
>>>
>>> What happens is that iperf gets -EAGAIN on write().
>>> It continues to get -EAGAIN, even if iperf runs for e.g. 300 seconds.
>>> The reason why we get -EAGAIN is because the send socket buffer is full
>>> (iperf uses non-blocking I/O).
>>>
>>> The problem is that the mac80211 wake_tx_queue callback never comes.
>>>
>>> I guess the best way to describe this is to show my ftrace buffer:
>>>
>>>      ksoftirqd/2-21    [002] .ns4    74.711744: ath10k_htt_tx_dec_pending: num_pen: 60
>>>      ksoftirqd/2-21    [002] .ns3    74.711761: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 1 byte_cnt: 1534 f_txq: frame_cnt: 1 byte_cnt: 1534 num_pen: 60 queue: 0
>>>      ksoftirqd/2-21    [002] .ns4    74.711765: ath10k_htt_tx_inc_pending: num_pen: 61
>>>      ksoftirqd/2-21    [002] .ns4    74.711781: ath10k_htt_tx_inc_pending: num_pen: 62
>>>      ksoftirqd/2-21    [002] .ns4    74.711787: ath10k_htt_tx_dec_pending: num_pen: 61
>>>      ksoftirqd/2-21    [002] .ns3    74.711803: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 1 byte_cnt: 1534 f_txq: frame_cnt: 1 byte_cnt: 1534 num_pen: 61 queue: 0
>>>      ksoftirqd/2-21    [002] .ns4    74.711807: ath10k_htt_tx_inc_pending: num_pen: 62
>>>      ksoftirqd/2-21    [002] .ns4    74.711823: ath10k_htt_tx_inc_pending: num_pen: 63
>>>      ksoftirqd/2-21    [002] .ns4    74.711829: ath10k_htt_tx_dec_pending: num_pen: 62
>>>      ksoftirqd/2-21    [002] .ns3    74.711845: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 1 byte_cnt: 1534 f_txq: frame_cnt: 1 byte_cnt: 1534 num_pen: 62 queue: 0
>>>      ksoftirqd/2-21    [002] .ns4    74.711849: ath10k_htt_tx_inc_pending: num_pen: 63
>>>      ksoftirqd/2-21    [002] .ns4    74.711865: ath10k_htt_tx_inc_pending: num_pen: 64
>>>      ksoftirqd/2-21    [002] dns5    74.711870: stop_queue: phy0 queue:0, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711874: stop_queue: phy0 queue:1, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711877: stop_queue: phy0 queue:2, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711880: stop_queue: phy0 queue:3, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711882: stop_queue: phy0 queue:4, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711885: stop_queue: phy0 queue:5, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711887: stop_queue: phy0 queue:6, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711890: stop_queue: phy0 queue:7, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711892: stop_queue: phy0 queue:8, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711895: stop_queue: phy0 queue:9, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711898: stop_queue: phy0 queue:10, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711900: stop_queue: phy0 queue:11, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711903: stop_queue: phy0 queue:12, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711905: stop_queue: phy0 queue:13, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711908: stop_queue: phy0 queue:14, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711910: stop_queue: phy0 queue:15, reason:0
>>>      ksoftirqd/2-21    [002] .ns4    74.711917: ath10k_htt_tx_dec_pending: num_pen: 63
>>>      ksoftirqd/2-21    [002] dns5    74.711922: wake_queue: phy0 queue:0, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711929: wake_queue: phy0 queue:15, reason:0
>>>      ksoftirqd/2-21    [002] .ns3    74.711948: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 1 byte_cnt: 1534 f_txq: frame_cnt: 1 byte_cnt: 1534 num_pen: 63 queue: 0
>>>      ksoftirqd/2-21    [002] .ns4    74.711952: ath10k_htt_tx_inc_pending: num_pen: 64
>>>      ksoftirqd/2-21    [002] dns5    74.711956: stop_queue: phy0 queue:0, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711959: stop_queue: phy0 queue:1, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711962: stop_queue: phy0 queue:2, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711964: stop_queue: phy0 queue:3, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711967: stop_queue: phy0 queue:4, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711969: stop_queue: phy0 queue:5, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711972: stop_queue: phy0 queue:6, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711974: stop_queue: phy0 queue:7, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711977: stop_queue: phy0 queue:8, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711980: stop_queue: phy0 queue:9, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711982: stop_queue: phy0 queue:10, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711985: stop_queue: phy0 queue:11, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711987: stop_queue: phy0 queue:12, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711990: stop_queue: phy0 queue:13, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711992: stop_queue: phy0 queue:14, reason:0
>>>      ksoftirqd/2-21    [002] dns5    74.711995: stop_queue: phy0 queue:15, reason:0
>>>
>>> (since we just called ieee80211_stop_queues(), I wouldn't expect to see
>>> wake_tx_queue being called directly after)
>>>
>>>      ksoftirqd/2-21    [002] .ns3    74.712024: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 1 byte_cnt: 1534 f_txq: frame_cnt: 1 byte_cnt: 1534 num_pen: 64 queue: 0
>>>      ksoftirqd/2-21    [002] .ns3    74.712040: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 2 byte_cnt: 3068 f_txq: frame_cnt: 2 byte_cnt: 3068 num_pen: 64 queue: 0
>>>      ksoftirqd/2-21    [002] .ns3    74.712055: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 3 byte_cnt: 4602 f_txq: frame_cnt: 3 byte_cnt: 4602 num_pen: 64 queue: 0
>>>      ksoftirqd/2-21    [002] .ns3    74.712069: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 4 byte_cnt: 6136 f_txq: frame_cnt: 4 byte_cnt: 6136 num_pen: 64 queue: 0
>>>      ksoftirqd/2-21    [002] .ns3    74.712084: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 5 byte_cnt: 7670 f_txq: frame_cnt: 5 byte_cnt: 7670 num_pen: 64 queue: 0
>>>      ksoftirqd/2-21    [002] .ns3    74.712099: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 6 byte_cnt: 9204 f_txq: frame_cnt: 6 byte_cnt: 9204 num_pen: 64 queue: 0
>>>      ksoftirqd/2-21    [002] .ns3    74.712113: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 7 byte_cnt: 10738 f_txq: frame_cnt: 7 byte_cnt: 10738 num_pen: 64 queue: 0
>>>      ksoftirqd/2-21    [002] .ns3    74.712128: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 8 byte_cnt: 12272 f_txq: frame_cnt: 8 byte_cnt: 12272 num_pen: 64 queue: 0
>>>      ksoftirqd/2-21    [002] .ns3    74.712142: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 9 byte_cnt: 13806 f_txq: frame_cnt: 9 byte_cnt: 13806 num_pen: 64 queue: 0
>>>      ksoftirqd/2-21    [002] .ns3    74.712157: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 10 byte_cnt: 15340 f_txq: frame_cnt: 10 byte_cnt: 15340 num_pen: 64 queue: 0
>>>      ksoftirqd/2-21    [002] .ns3    74.712171: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 11 byte_cnt: 16874 f_txq: frame_cnt: 11 byte_cnt: 16874 num_pen: 64 queue: 0
>>>      ksoftirqd/2-21    [002] .ns3    74.712186: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 12 byte_cnt: 18408 f_txq: frame_cnt: 12 byte_cnt: 18408 num_pen: 64 queue: 0
>>>      ksoftirqd/2-21    [002] .ns3    74.712200: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 13 byte_cnt: 19942 f_txq: frame_cnt: 13 byte_cnt: 19942 num_pen: 64 queue: 0
>>>      ksoftirqd/2-21    [002] .ns3    74.712215: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 14 byte_cnt: 21476 f_txq: frame_cnt: 14 byte_cnt: 21476 num_pen: 64 queue: 0
>>>      ksoftirqd/2-21    [002] .ns3    74.712229: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 15 byte_cnt: 23010 f_txq: frame_cnt: 15 byte_cnt: 23010 num_pen: 64 queue: 0
>>>      ksoftirqd/2-21    [002] .ns3    74.712244: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 16 byte_cnt: 24544 f_txq: frame_cnt: 16 byte_cnt: 24544 num_pen: 64 queue: 0
>>>      ksoftirqd/2-21    [002] .ns3    74.712258: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 17 byte_cnt: 26078 f_txq: frame_cnt: 17 byte_cnt: 26078 num_pen: 64 queue: 0
>>>      ksoftirqd/2-21    [002] .ns3    74.712273: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 18 byte_cnt: 27612 f_txq: frame_cnt: 18 byte_cnt: 27612 num_pen: 64 queue: 0
>>>      ksoftirqd/2-21    [002] .ns3    74.712287: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 19 byte_cnt: 29146 f_txq: frame_cnt: 19 byte_cnt: 29146 num_pen: 64 queue: 0
>>>      ksoftirqd/2-21    [002] .ns3    74.712302: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 20 byte_cnt: 30680 f_txq: frame_cnt: 20 byte_cnt: 30680 num_pen: 64 queue: 0
>>>      ksoftirqd/2-21    [002] .ns3    74.712316: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 21 byte_cnt: 32214 f_txq: frame_cnt: 21 byte_cnt: 32214 num_pen: 64 queue: 0
>>>      ksoftirqd/2-21    [002] .ns3    74.712330: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 22 byte_cnt: 33748 f_txq: frame_cnt: 22 byte_cnt: 33748 num_pen: 64 queue: 0
>>>      ksoftirqd/2-21    [002] .ns3    74.712345: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 23 byte_cnt: 35282 f_txq: frame_cnt: 23 byte_cnt: 35282 num_pen: 64 queue: 0
>>>      ksoftirqd/2-21    [002] .ns3    74.712359: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 24 byte_cnt: 36816 f_txq: frame_cnt: 24 byte_cnt: 36816 num_pen: 64 queue: 0
>>>   ksdioirqd/mmc2-139   [002] ...1    74.712411: ath10k_htt_tx_dec_pending: num_pen: 63
>>>   ksdioirqd/mmc2-139   [002] d..2    74.712417: wake_queue: phy0 queue:0, reason:0
>>>   ksdioirqd/mmc2-139   [002] d..2    74.712424: wake_queue: phy0 queue:15, reason:0
>>>
>>> here we just called ieee80211_wake_queue(), however, wake_tx_queue callback
>>> (ath10k_mac_op_wake_tx_queue) is never seen again...
>>>
>>>   ksdioirqd/mmc2-139   [002] ...1    74.712454: ath10k_htt_tx_dec_pending: num_pen: 62
>>>   ksdioirqd/mmc2-139   [002] ...1    74.712468: ath10k_htt_tx_dec_pending: num_pen: 61
>>>   ksdioirqd/mmc2-139   [002] ...1    74.718078: ath10k_htt_tx_dec_pending: num_pen: 60
>>>   ksdioirqd/mmc2-139   [002] ...1    74.718103: ath10k_htt_tx_dec_pending: num_pen: 59
>>>   ksdioirqd/mmc2-139   [002] ...1    74.718116: ath10k_htt_tx_dec_pending: num_pen: 58
>>>   ksdioirqd/mmc2-139   [002] ...1    74.718131: ath10k_htt_tx_dec_pending: num_pen: 57
>>>   ksdioirqd/mmc2-139   [002] ...1    74.718143: ath10k_htt_tx_dec_pending: num_pen: 56
>>>   ksdioirqd/mmc2-139   [002] ...1    74.718155: ath10k_htt_tx_dec_pending: num_pen: 55
>>>   ksdioirqd/mmc2-139   [002] ...1    74.718250: ath10k_htt_tx_dec_pending: num_pen: 54
>>>   ksdioirqd/mmc2-139   [002] ...1    74.718273: ath10k_htt_tx_dec_pending: num_pen: 53
>>>   ksdioirqd/mmc2-139   [002] ...1    74.718286: ath10k_htt_tx_dec_pending: num_pen: 52
>>>   ksdioirqd/mmc2-139   [002] ...1    74.718298: ath10k_htt_tx_dec_pending: num_pen: 51
>>>   ksdioirqd/mmc2-139   [002] ...1    74.718310: ath10k_htt_tx_dec_pending: num_pen: 50
>>>   ksdioirqd/mmc2-139   [002] ...1    74.718322: ath10k_htt_tx_dec_pending: num_pen: 49
>>>   ksdioirqd/mmc2-139   [002] ...1    74.718334: ath10k_htt_tx_dec_pending: num_pen: 48
>>>   ksdioirqd/mmc2-139   [002] ...1    74.718346: ath10k_htt_tx_dec_pending: num_pen: 47
>>>   ksdioirqd/mmc2-139   [002] ...1    74.718622: ath10k_htt_tx_dec_pending: num_pen: 46
>>>   ksdioirqd/mmc2-139   [002] ...1    74.718647: ath10k_htt_tx_dec_pending: num_pen: 45
>>>   ksdioirqd/mmc2-139   [002] ...1    74.718660: ath10k_htt_tx_dec_pending: num_pen: 44
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719050: ath10k_htt_tx_dec_pending: num_pen: 43
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719154: ath10k_htt_tx_dec_pending: num_pen: 42
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719255: ath10k_htt_tx_dec_pending: num_pen: 41
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719278: ath10k_htt_tx_dec_pending: num_pen: 40
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719371: ath10k_htt_tx_dec_pending: num_pen: 39
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719394: ath10k_htt_tx_dec_pending: num_pen: 38
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719493: ath10k_htt_tx_dec_pending: num_pen: 37
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719516: ath10k_htt_tx_dec_pending: num_pen: 36
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719529: ath10k_htt_tx_dec_pending: num_pen: 35
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719541: ath10k_htt_tx_dec_pending: num_pen: 34
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719554: ath10k_htt_tx_dec_pending: num_pen: 33
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719566: ath10k_htt_tx_dec_pending: num_pen: 32
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719658: ath10k_htt_tx_dec_pending: num_pen: 31
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719681: ath10k_htt_tx_dec_pending: num_pen: 30
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719694: ath10k_htt_tx_dec_pending: num_pen: 29
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719708: ath10k_htt_tx_dec_pending: num_pen: 28
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719803: ath10k_htt_tx_dec_pending: num_pen: 27
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719826: ath10k_htt_tx_dec_pending: num_pen: 26
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719839: ath10k_htt_tx_dec_pending: num_pen: 25
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719851: ath10k_htt_tx_dec_pending: num_pen: 24
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719864: ath10k_htt_tx_dec_pending: num_pen: 23
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719956: ath10k_htt_tx_dec_pending: num_pen: 22
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719978: ath10k_htt_tx_dec_pending: num_pen: 21
>>>   ksdioirqd/mmc2-139   [002] ...1    74.719992: ath10k_htt_tx_dec_pending: num_pen: 20
>>>   ksdioirqd/mmc2-139   [002] ...1    74.720004: ath10k_htt_tx_dec_pending: num_pen: 19
>>>   ksdioirqd/mmc2-139   [002] ...1    74.720096: ath10k_htt_tx_dec_pending: num_pen: 18
>>>   ksdioirqd/mmc2-139   [002] ...1    74.720137: ath10k_htt_tx_dec_pending: num_pen: 17
>>>   ksdioirqd/mmc2-139   [002] ...1    74.720150: ath10k_htt_tx_dec_pending: num_pen: 16
>>>   ksdioirqd/mmc2-139   [002] ...1    74.720163: ath10k_htt_tx_dec_pending: num_pen: 15
>>>   ksdioirqd/mmc2-139   [002] ...1    74.720256: ath10k_htt_tx_dec_pending: num_pen: 14
>>>   ksdioirqd/mmc2-139   [002] ...1    74.720279: ath10k_htt_tx_dec_pending: num_pen: 13
>>>   ksdioirqd/mmc2-139   [002] ...1    74.720292: ath10k_htt_tx_dec_pending: num_pen: 12
>>>   ksdioirqd/mmc2-139   [002] ...1    74.720304: ath10k_htt_tx_dec_pending: num_pen: 11
>>>   ksdioirqd/mmc2-139   [002] ...1    74.720316: ath10k_htt_tx_dec_pending: num_pen: 10
>>>   ksdioirqd/mmc2-139   [002] ...1    74.720396: ath10k_htt_tx_dec_pending: num_pen: 9
>>>   ksdioirqd/mmc2-139   [002] ...1    74.720503: ath10k_htt_tx_dec_pending: num_pen: 8
>>>   ksdioirqd/mmc2-139   [002] ...1    74.720527: ath10k_htt_tx_dec_pending: num_pen: 7
>>>   ksdioirqd/mmc2-139   [002] ...1    74.720540: ath10k_htt_tx_dec_pending: num_pen: 6
>>>   ksdioirqd/mmc2-139   [002] ...1    74.720552: ath10k_htt_tx_dec_pending: num_pen: 5
>>>   ksdioirqd/mmc2-139   [002] ...1    74.720645: ath10k_htt_tx_dec_pending: num_pen: 4
>>>   ksdioirqd/mmc2-139   [002] ...1    74.720668: ath10k_htt_tx_dec_pending: num_pen: 3
>>>   ksdioirqd/mmc2-139   [002] ...1    74.720681: ath10k_htt_tx_dec_pending: num_pen: 2
>>>   ksdioirqd/mmc2-139   [002] ...1    74.720694: ath10k_htt_tx_dec_pending: num_pen: 1
>>>   ksdioirqd/mmc2-139   [002] ...1    74.720709: ath10k_htt_tx_dec_pending: num_pen: 0
>>>
>>> ath10k just finished transmission of pending frames.
>>>
>>> Half a second later, the send buffer is full, and we start seeing errors
>>> in iperf.
>>>
>>>            iperf-181   [001] ....    75.191606: tcp_sendmsg_locked: err: -11
>>>            iperf-181   [001] ....    75.701511: tcp_sendmsg_locked: err: -11
>>>            iperf-181   [001] ....    76.211648: tcp_sendmsg_locked: err: -11
>>>
>>>
>>>
>>> Sure, the regular way ath10k_mac_op_wake_tx_queue is called is via
>>> ieee80211_subif_start_xmit => __ieee80211_subif_start_xmit => ieee80211_xmit_fast
>>> => ieee80211_queue_skb => drv_wake_tx_queue.
>>>
>>> But I was expecting the call to ieee80211_wake_queue to somehow trigger a call
>>> to ath10k_mac_op_wake_tx_queue, since there is still data in the send buffer/
>>> in the ieee80211_txq that needs to be sent, to allow more data to be written to
>>> the socket. But obviously the callback never comes.
>>> Or how else is this supposed to work?
>>
>> The driver should reschedule itself before/after calling
>> ieee80211_wake_queue. mt76 does this; I'm not actually sure if ath9k
>> does the right thing either, I'm not too familiar with that part of the
>> code. There's no direct call to reschedule that I can see, but there may
>> be another reason why this is not needed for ath9k. I'm sure Felix
>> knows?
> 
> Hello Toke
> 
> Unfortunately, it doesn't look like mt76 uses any ieee80211_* function to
> reschedule.
> 
> I just came across a ieee80211_schedule_txq() function in
> e937b8da5a59 ("mac80211: Add TXQ scheduling API").
> However, this commit was reverted. Any plans on resubmitting this?
> 
> Regards,
> Niklas
> 
>>
>>> However, since the only wireless drivers using wake_tx_queue are:
>>> ath9k, ath10k, and mt76, perhaps it is not such a bad idea to use the
>>> tx callback instead of the wake_tx_queue callback.
>>
>> On the contrary, we want more drivers to move to wake_tx_queue :)
>>
>> -Toke
