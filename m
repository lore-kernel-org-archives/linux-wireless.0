Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47480 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbeG0KuE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 06:50:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 27 Jul 2018 17:29:00 +0800
From: Wen Gong <wgong@codeaurora.org>
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: ath10k@lists.infradead.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi chips
In-Reply-To: <87zhye1aqg.fsf@toke.dk>
References: <1532589677-16428-1-git-send-email-wgong@codeaurora.org>
 <1532589677-16428-3-git-send-email-wgong@codeaurora.org>
 <87zhye1aqg.fsf@toke.dk>
Message-ID: <e5f8de75e2464393e8664d8bf913a827@codeaurora.org> (sfid-20180727_112905_255460_7DAB6A7D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-07-26 19:45, Toke Høiland-Jørgensen wrote:
> Wen Gong <wgong@codeaurora.org> writes:
> 
>> Upstream kernel has an interface to help adjust sk_pacing_shift to 
>> help
>> improve TCP UL throughput.
>> The sk_pacing_shift is 8 in mac80211, this is based on test with 11N
>> WiFi chips with ath9k. For QCA6174/QCA9377 PCI 11AC chips, the 11AC
>> VHT80 TCP UL throughput testing result shows 6 is the optimal.
>> Overwrite the sk_pacing_shift to 6 in ath10k driver.
> 
> When I tested this, a pacing shift of 8 was quite close to optimal as
> well for ath10k. Why are you getting different results?

the default value is still 8 in the patch:
https://patchwork.kernel.org/patch/10545361/

In my test, pacing shift 6 is better than 8.
The test is for ath10k/11AC WiFi chips.
Test result is show in the commit logs before.
> 
>> Tested with QCA6174 PCI with firmware
>> WLAN.RM.4.4.1-00109-QCARMSWPZ-1, but this will also affect QCA9377 
>> PCI.
>> It's not a regression with new firmware releases.
>> 
>> There have 2 test result of different settings:
>> 
>> ARM CPU based device with QCA6174A PCI with different
>> sk_pacing_shift:
>> 
>>  sk_pacing_shift  throughput(Mbps)             CPU utilization
>>          6            500(-P5)      ~75% idle, Focus on CPU1: ~14%idle
>>          7            454(-P5)      ~80% idle, Focus on CPU1: ~4%idle
>>          8               288        ~90% idle, Focus on CPU1: ~35%idle
>>          9              ~200        ~92% idle, Focus on CPU1: ~50%idle
> 
> Your tests do not include latency values; please try running a test 
> that
> also measures latency. The tcp_nup test in Flent (https://flent.org)
> will do that, for instance. Also, is this a single TCP flow?
> 

It is not a single TCP flow, it is 500Mbps with 5 flows.

below is result show in commit log before:
5G TCP UL VTH80 on X86 platform with QCA6174A PCI with sk_packing_shift
set to 6:

   tcp_limit_output_bytes            throughput(Mbps)
  default(262144)+1 Stream                 336
  default(262144)+2 Streams                558
  default(262144)+3 Streams                584
  default(262144)+4 Streams                602
  default(262144)+5 Streams                598
  changed(2621440)+1 Stream                598
  changed(2621440)+2 Streams               601

> -Toke
