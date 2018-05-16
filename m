Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36470 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbeEPR3M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 13:29:12 -0400
Received: by mail-wm0-f67.google.com with SMTP id n10-v6so3639446wmc.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 May 2018 10:29:11 -0700 (PDT)
Subject: Re: ath10k wake_tx_queue issues
To: Niklas Cassel <niklas.cassel@linaro.org>,
        johannes@sipsolutions.net, kvalo@qca.qualcomm.com, toke@toke.dk
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
References: <20180515134516.GA30397@localhost.localdomain>
From: Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <6b81aa2e-09a3-ae48-7626-8ceb33a2a6b5@gmail.com> (sfid-20180516_192916_455943_EC936C5E)
Date: Wed, 16 May 2018 19:28:21 +0200
MIME-Version: 1.0
In-Reply-To: <20180515134516.GA30397@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Niklas

Quick question:
Are you using my patch: "ath10k: add htt_tx num_pending window"?

I assume (from your logs below) that you are not...

See more comments below.

<snip>
> 
> I guess the best way to describe this is to show my ftrace buffer:
> 
>       ksoftirqd/2-21    [002] .ns4    74.711744: ath10k_htt_tx_dec_pending: num_pen: 60
>       ksoftirqd/2-21    [002] .ns3    74.711761: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 1 byte_cnt: 1534 f_txq: frame_cnt: 1 byte_cnt: 1534 num_pen: 60 queue: 0
>       ksoftirqd/2-21    [002] .ns4    74.711765: ath10k_htt_tx_inc_pending: num_pen: 61
>       ksoftirqd/2-21    [002] .ns4    74.711781: ath10k_htt_tx_inc_pending: num_pen: 62
>       ksoftirqd/2-21    [002] .ns4    74.711787: ath10k_htt_tx_dec_pending: num_pen: 61
>       ksoftirqd/2-21    [002] .ns3    74.711803: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 1 byte_cnt: 1534 f_txq: frame_cnt: 1 byte_cnt: 1534 num_pen: 61 queue: 0
>       ksoftirqd/2-21    [002] .ns4    74.711807: ath10k_htt_tx_inc_pending: num_pen: 62
>       ksoftirqd/2-21    [002] .ns4    74.711823: ath10k_htt_tx_inc_pending: num_pen: 63
>       ksoftirqd/2-21    [002] .ns4    74.711829: ath10k_htt_tx_dec_pending: num_pen: 62
>       ksoftirqd/2-21    [002] .ns3    74.711845: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 1 byte_cnt: 1534 f_txq: frame_cnt: 1 byte_cnt: 1534 num_pen: 62 queue: 0
>       ksoftirqd/2-21    [002] .ns4    74.711849: ath10k_htt_tx_inc_pending: num_pen: 63
>       ksoftirqd/2-21    [002] .ns4    74.711865: ath10k_htt_tx_inc_pending: num_pen: 64
For high latency devices, when the num_pending counter reaches this point (64),
ath10k calls ieee80211_stop_queues (from ath10k_htt_tx_inc_pending -> ath10k_mac_tx_lock).
This will stop all per-TID queues (16 in total).

>       ksoftirqd/2-21    [002] dns5    74.711870: stop_queue: phy0 queue:0, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711874: stop_queue: phy0 queue:1, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711877: stop_queue: phy0 queue:2, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711880: stop_queue: phy0 queue:3, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711882: stop_queue: phy0 queue:4, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711885: stop_queue: phy0 queue:5, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711887: stop_queue: phy0 queue:6, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711890: stop_queue: phy0 queue:7, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711892: stop_queue: phy0 queue:8, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711895: stop_queue: phy0 queue:9, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711898: stop_queue: phy0 queue:10, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711900: stop_queue: phy0 queue:11, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711903: stop_queue: phy0 queue:12, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711905: stop_queue: phy0 queue:13, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711908: stop_queue: phy0 queue:14, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711910: stop_queue: phy0 queue:15, reason:0
>       ksoftirqd/2-21    [002] .ns4    74.711917: ath10k_htt_tx_dec_pending: num_pen: 63
At this point, the driver have received a TX_COMPL_IND (since num_pending has been decremented to 63).
Without the patch I mentioned above, the logic is that the TX queues will be re-enabled immediately.
This is achieved by calling ieee80211_stop_queues.

>       ksoftirqd/2-21    [002] dns5    74.711922: wake_queue: phy0 queue:0, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711929: wake_queue: phy0 queue:15, reason:0
2 queues have been enabled here. I don't know why not all queues have been re-enabled.
Perhaps it is due to that mac80211 immediately gets more data on one of the just re-enabled queues,
resulting in...
>       ksoftirqd/2-21    [002] .ns3    74.711948: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 1 byte_cnt: 1534 f_txq: frame_cnt: 1 byte_cnt: 1534 num_pen: 63 queue: 0
...the the wake_tx_queue op beeing invoked again ...
>       ksoftirqd/2-21    [002] .ns4    74.711952: ath10k_htt_tx_inc_pending: num_pen: 64
... and the num_pending counter beeing incremented as a result of this.
This results in all queues beeing ...
>       ksoftirqd/2-21    [002] dns5    74.711956: stop_queue: phy0 queue:0, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711959: stop_queue: phy0 queue:1, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711962: stop_queue: phy0 queue:2, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711964: stop_queue: phy0 queue:3, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711967: stop_queue: phy0 queue:4, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711969: stop_queue: phy0 queue:5, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711972: stop_queue: phy0 queue:6, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711974: stop_queue: phy0 queue:7, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711977: stop_queue: phy0 queue:8, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711980: stop_queue: phy0 queue:9, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711982: stop_queue: phy0 queue:10, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711985: stop_queue: phy0 queue:11, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711987: stop_queue: phy0 queue:12, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711990: stop_queue: phy0 queue:13, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711992: stop_queue: phy0 queue:14, reason:0
>       ksoftirqd/2-21    [002] dns5    74.711995: stop_queue: phy0 queue:15, reason:0
... stopped again (since we reached the upper limit of 64).
> 
> (since we just called ieee80211_stop_queues(), I wouldn't expect to see
> wake_tx_queue being called directly after)
> 
Below looks really odd indeed.
If ath10k_mac_op_wake_tx_queue is beeing called several times with num_pending == 64,
those calls will fail (nothing will be transmitted).

>       ksoftirqd/2-21    [002] .ns3    74.712024: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 1 byte_cnt: 1534 f_txq: frame_cnt: 1 byte_cnt: 1534 num_pen: 64 queue: 0
>       ksoftirqd/2-21    [002] .ns3    74.712040: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 2 byte_cnt: 3068 f_txq: frame_cnt: 2 byte_cnt: 3068 num_pen: 64 queue: 0
>       ksoftirqd/2-21    [002] .ns3    74.712055: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 3 byte_cnt: 4602 f_txq: frame_cnt: 3 byte_cnt: 4602 num_pen: 64 queue: 0
>       ksoftirqd/2-21    [002] .ns3    74.712069: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 4 byte_cnt: 6136 f_txq: frame_cnt: 4 byte_cnt: 6136 num_pen: 64 queue: 0
>       ksoftirqd/2-21    [002] .ns3    74.712084: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 5 byte_cnt: 7670 f_txq: frame_cnt: 5 byte_cnt: 7670 num_pen: 64 queue: 0
>       ksoftirqd/2-21    [002] .ns3    74.712099: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 6 byte_cnt: 9204 f_txq: frame_cnt: 6 byte_cnt: 9204 num_pen: 64 queue: 0
>       ksoftirqd/2-21    [002] .ns3    74.712113: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 7 byte_cnt: 10738 f_txq: frame_cnt: 7 byte_cnt: 10738 num_pen: 64 queue: 0
>       ksoftirqd/2-21    [002] .ns3    74.712128: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 8 byte_cnt: 12272 f_txq: frame_cnt: 8 byte_cnt: 12272 num_pen: 64 queue: 0
>       ksoftirqd/2-21    [002] .ns3    74.712142: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 9 byte_cnt: 13806 f_txq: frame_cnt: 9 byte_cnt: 13806 num_pen: 64 queue: 0
>       ksoftirqd/2-21    [002] .ns3    74.712157: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 10 byte_cnt: 15340 f_txq: frame_cnt: 10 byte_cnt: 15340 num_pen: 64 queue: 0
>       ksoftirqd/2-21    [002] .ns3    74.712171: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 11 byte_cnt: 16874 f_txq: frame_cnt: 11 byte_cnt: 16874 num_pen: 64 queue: 0
>       ksoftirqd/2-21    [002] .ns3    74.712186: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 12 byte_cnt: 18408 f_txq: frame_cnt: 12 byte_cnt: 18408 num_pen: 64 queue: 0
>       ksoftirqd/2-21    [002] .ns3    74.712200: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 13 byte_cnt: 19942 f_txq: frame_cnt: 13 byte_cnt: 19942 num_pen: 64 queue: 0
>       ksoftirqd/2-21    [002] .ns3    74.712215: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 14 byte_cnt: 21476 f_txq: frame_cnt: 14 byte_cnt: 21476 num_pen: 64 queue: 0
>       ksoftirqd/2-21    [002] .ns3    74.712229: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 15 byte_cnt: 23010 f_txq: frame_cnt: 15 byte_cnt: 23010 num_pen: 64 queue: 0
>       ksoftirqd/2-21    [002] .ns3    74.712244: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 16 byte_cnt: 24544 f_txq: frame_cnt: 16 byte_cnt: 24544 num_pen: 64 queue: 0
>       ksoftirqd/2-21    [002] .ns3    74.712258: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 17 byte_cnt: 26078 f_txq: frame_cnt: 17 byte_cnt: 26078 num_pen: 64 queue: 0
>       ksoftirqd/2-21    [002] .ns3    74.712273: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 18 byte_cnt: 27612 f_txq: frame_cnt: 18 byte_cnt: 27612 num_pen: 64 queue: 0
>       ksoftirqd/2-21    [002] .ns3    74.712287: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 19 byte_cnt: 29146 f_txq: frame_cnt: 19 byte_cnt: 29146 num_pen: 64 queue: 0
>       ksoftirqd/2-21    [002] .ns3    74.712302: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 20 byte_cnt: 30680 f_txq: frame_cnt: 20 byte_cnt: 30680 num_pen: 64 queue: 0
>       ksoftirqd/2-21    [002] .ns3    74.712316: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 21 byte_cnt: 32214 f_txq: frame_cnt: 21 byte_cnt: 32214 num_pen: 64 queue: 0
>       ksoftirqd/2-21    [002] .ns3    74.712330: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 22 byte_cnt: 33748 f_txq: frame_cnt: 22 byte_cnt: 33748 num_pen: 64 queue: 0
>       ksoftirqd/2-21    [002] .ns3    74.712345: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 23 byte_cnt: 35282 f_txq: frame_cnt: 23 byte_cnt: 35282 num_pen: 64 queue: 0
>       ksoftirqd/2-21    [002] .ns3    74.712359: ath10k_mac_op_wake_tx_queue: txq: frame_cnt: 24 byte_cnt: 36816 f_txq: frame_cnt: 24 byte_cnt: 36816 num_pen: 64 queue: 0
>    ksdioirqd/mmc2-139   [002] ...1    74.712411: ath10k_htt_tx_dec_pending: num_pen: 63
Here we get another TX_COMP_IND resulting in a re-enable of the queues.
>    ksdioirqd/mmc2-139   [002] d..2    74.712417: wake_queue: phy0 queue:0, reason:0
>    ksdioirqd/mmc2-139   [002] d..2    74.712424: wake_queue: phy0 queue:15, reason:0
> 
> here we just called ieee80211_wake_queue(), however, wake_tx_queue callback
> (ath10k_mac_op_wake_tx_queue) is never seen again...
> 
Below we get TX_COMP_IND's for all outstanding TX messages:
>    ksdioirqd/mmc2-139   [002] ...1    74.712454: ath10k_htt_tx_dec_pending: num_pen: 62
>    ksdioirqd/mmc2-139   [002] ...1    74.712468: ath10k_htt_tx_dec_pending: num_pen: 61
>    ksdioirqd/mmc2-139   [002] ...1    74.718078: ath10k_htt_tx_dec_pending: num_pen: 60
>    ksdioirqd/mmc2-139   [002] ...1    74.718103: ath10k_htt_tx_dec_pending: num_pen: 59
>    ksdioirqd/mmc2-139   [002] ...1    74.718116: ath10k_htt_tx_dec_pending: num_pen: 58
>    ksdioirqd/mmc2-139   [002] ...1    74.718131: ath10k_htt_tx_dec_pending: num_pen: 57
...
<snip>
> 
> ath10k just finished transmission of pending frames.
> 
It would be interesting to see what happens if the max_num_pending value was incremented.

It is defined by TARGET_TLV_NUM_MSDU_DESC_HL in hw.h

I have tried a value of 105 (used in more recent version of qcacld) and it seems to work fine.
When combined with the patch I mentioned above, it will create a num_pending window,
that potentially can mitigate this problem.

Another thing you could try to tweak is the HTC_HOST_MAX_MSG_PER_TX_BUNDLE constant (only present in my patch).
If you set it to a high enough value (let's say 24 in your case, since you have 24 wake_tx_queue
invocations after the queues have been stopped), ath10k will be able to handle those extra frames
(at least 24 of them), since the queues will be stopped before the maximum num_pending limit is reached.

--
Erik
