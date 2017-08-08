Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58416 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752427AbdHHWtf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 18:49:35 -0400
Subject: Re: wireless drivers fail to report link speed?
To: james@nurealm.net, Dan Williams <dcbw@redhat.com>,
        linux-wireless@vger.kernel.org
References: <9645388a-2350-8fa0-ca34-e2289743888b@nurealm.net>
 <1502228547.24881.5.camel@redhat.com>
 <3a24351b-6875-fe65-58f1-f624c9f1832f@candelatech.com>
 <5f4422cc-2943-7863-bef3-c2c2653bde24@nurealm.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <5a5cb91f-443c-8cc1-ea1f-50de4d07cb25@candelatech.com> (sfid-20170809_004938_997879_FD12F839)
Date: Tue, 8 Aug 2017 15:49:34 -0700
MIME-Version: 1.0
In-Reply-To: <5f4422cc-2943-7863-bef3-c2c2653bde24@nurealm.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/08/2017 03:25 PM, James Feeney wrote:
> Hey Dan
>
>> ...
>> So one second the wifi might be the "best" link and then when somebody
>> turns on a microwave oven or a baby monitor, it may be the "worst"
>> until the microwave's duty cycle completes a few seconds later then
>> it'll become the "best" again for a couple seconds then "worst" again,
>> repeat until your Easy Mac is nice and warm and creamy.
>>
>> Furthermore, for some drivers IIRC when there isn't any traffic, they
>> might drop the link rate very low because there's no reason keep
>> powering blocks when you're not transmitting/receiving any data.  IIRC
>> the Intel drivers used to do that a couple years ago.
>
> Yes, thanks, but, while all of that is true, it has nothing to do with the
> question asked.
>
> The question is, regardless that the wireless speed may be constantly changing,
> why is it that the kernel ethtool returns an error on get_settings(), instead of
> returning the current wireless speed, whatever that link speed might be at the
> moment?
>
>> Also, "duplex" doesn't mean anything in wireless land.  So no clue what
>> bonding is expecting them to say here.  I would say the modifications
>> to the bonding core made assumptions that simply aren't applicable to
>> mediums other than wired ones.
>
> Since, as Ben mentions,
>
>> Well, wifi acts half-duplex in that only one side can transmit at once.
>
> then the wireless drivers would be expected to simply report "half-duplex".
>
> Again, the issue is not that wireless is half-duplex or full-duplex, but rather,
> why does the kernel ethtool return an error on get_settings()?
>
> And, why is it that it seems get_settings() returns an error with multiple
> wireless drivers?  Is there some assumption, or convention, that causes the
> kernel ethtool to fail with *all* the wireless drivers?
>
> I see that, on bugzilla, Florian is suggesting that wireless network devices
> *cannot* report a speed/duplex, simply because the wireless speed changes on a
> per-packet basis, but that does not seem to me to be a persuasive argument.  A
> wireless connection *does* always have a current speed, even if that speed
> changes frequently.  The kernel ethtool get_settings() should simply report that
> speed, not throw an error, yes?

Some time back, I added some support to ath10k to report some ethtool info.
At least most of this is upstream.  I do report rx and rx link rate, and yes,
it changes, but it does contain some useful info, at least when modest amounts
of packets are being transmitted and received (so that rate-ctrl logic
is working).  I think the stuff not prepended with d_ will show up for any
mac80211 driver.  Someone could improve ethtool to report these through more
normal API than just getting the stats if they wanted...

[root@lf0350-7220 lanforge]# ethtool -S wlan0
NIC statistics:
      rx_packets: 3321
      rx_bytes: 338788
      rx_duplicates: 0
      rx_fragments: 1671
      rx_dropped: 0
      tx_packets: 15
      tx_bytes: 484
      tx_filtered: 0
      tx_retry_failed: 2
      tx_retries: 0
      sta_state: 4
      txrate: 13000000
      rxrate: 0
      signal: 201
      channel: 5180
      noise: 150
      ch_time: 56
      ch_time_busy: 3
      ch_time_ext_busy: 18446744073709551615
      ch_time_rx: 18446744073709551615
      ch_time_tx: 18446744073709551615
      tx_hw_reaped: 1836
      tx_pkts_nic: 157
      tx_bytes_nic: 17639
      tx_bytes_to_fw: 24626
      rx_pkts_nic: 211
      rx_bytes_nic: 17346681
      d_noise_floor: 18446744073709551510
      d_cycle_count: 4138309451
      d_tx_cycle_count: 63796069
      d_rx_cycle_count: 3941659360
      d_busy_count: 4061048026
      d_flags: 0
      d_phy_error: 0
      d_rts_bad: 0
      d_rts_good: 4
      d_tx_power: 46
      d_rx_crc_err: 1518
      d_no_beacon: 0
      d_tx_mpdus_queued: 489
      d_tx_msdu_queued: 494
      d_tx_msdu_dropped: 0
      d_local_enqued: 46
      d_local_freed: 46
      d_tx_ppdu_hw_queued: 1836
      d_tx_ppdu_reaped: 1836
      d_tx_fifo_underrun: 4
      d_tx_ppdu_abort: 0
      d_tx_mpdu_requed: 1587
      d_tx_excessive_retries: 1575
      d_tx_hw_rate: 192
      d_tx_dropped_sw_retries: 51
      d_tx_noack: 0
      d_tx_noack_bytes: 0
      d_tx_discard: 240
      d_tx_discard_bytes: 5763
      d_tx_illegal_rate: 0
      d_tx_continuous_xretries: 0
      d_tx_timeout: 0
      d_tx_mpdu_txop_limit: 0
      d_pdev_resets: 25
      d_rx_mid_ppdu_route_change: 0
      d_rx_status: 0
      d_rx_extra_frags_ring0: 84453
      d_rx_extra_frags_ring1: 0
      d_rx_extra_frags_ring2: 0
      d_rx_extra_frags_ring3: 0
      d_rx_msdu_htt: 211
      d_rx_mpdu_htt: 211
      d_rx_msdu_stack: 84242
      d_rx_mpdu_stack: 84242
      d_rx_phy_err: 0
      d_rx_phy_err_drops: 0
      d_rx_mpdu_errors: 0
      d_fw_crash_count: 0
      d_fw_warm_reset_count: 0
      d_fw_cold_reset_count: 8
      d_fw_powerup_failed: 0
      d_short_tx_retries: 4
      d_long_tx_retries: 1571
      d_fw_adc_temp: 3081417395
[root@lf0350-7220 lanforge]#

Thanks,
Ben

>
>
> Thanks
> James
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
