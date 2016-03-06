Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56669 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbcCFG07 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 01:26:59 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sun, 06 Mar 2016 11:56:58 +0530
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: move mgmt descriptor limit handle under mgmt_tx
In-Reply-To: <56DBADE6.5060507@candelatech.com>
References: <1457187017-12913-1-git-send-email-rmanohar@qti.qualcomm.com>
 <56DAED8E.6020407@candelatech.com>
 <08ae455b4733d8c1607427b10acc759c@codeaurora.org>
 <56DBADE6.5060507@candelatech.com>
Message-ID: <6515868944c103e2b5bf0ed4e6f22924@codeaurora.org> (sfid-20160306_072703_204635_2C5F5DAC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Ben Greear wrote:
> On 03/05/2016 08:00 PM, Rajkumar Manoharan wrote:
>> On , Ben Greear wrote:
>>> On 03/05/2016 06:10 AM, Rajkumar Manoharan wrote:
>>>> Firmware reserves few descriptors for management frames 
>>>> transmission.
>>>> In 16 MBSSID scenario, these slots will be easy exhausted due to 
>>>> frequent
>>>> probe responses. So for 10.4 based solutions, probe responses are 
>>>> limited
>>>> by a threshold (24).
>>> 
>>> Do you mean probe requests or probe responses?
>>> 
>> I meant probe responses in AP mode.
>> 
>>> A single hardware scan request with lots of ssids in it will utilize 
>>> all
>>> firmware tx management frames (which is 5, it seems).  In my testing, 
>>> the
>>> firmware would just never send probe requests for the rest of the 
>>> ssids
>>> because the firmware scan state machine logic is broken.
>>> 
>> Hmm... firmware expects both ssid and bssid list to be filled for 
>> multiple probe
>> requests. Better to try with different probe spacing time, repeat 
>> probe time and
>> probe delay and dwell time as these params change prob_req behavior in 
>> firmware.
> 
> It was easier to just fix the firmware than to hack the
> rest of the stack.
> 
I didn't mean to hack the stack :) but scan params should not be 
constant for all type
of scan requests.

>> Anyway this change is not related to scan functionality.
>> 
>>> If you really do mean responses, then it sounds like it would be 
>>> better to
>>> use the normal RX path for mgt frames in the firmware...
>>> 
>> Let me clarify. Sending probe responses in AP mode are limited by a 
>> threshold
>> for qca99x0 ("ath10k: drop probe responses when too many are queued"). 
>> This change
>> moves probe response checks under mgmt_tx from common data path.
> 
> Ok, I'll take a look at that.  I've implemented MGT frames over the 
> completely
> normal HTT data-path transport, so probably I won't hit that in my 
> systems
> anyway (there should be no internal mgt-frame limitation, except for 
> locally
> created things like probe requests during scan).  But, I could be 
> missing
> something...I'm really just getting started with 10.4...
> 
Great.. just noticed that this change needs to be rebased on top of 
Michal's recent
data path series. Let me send next version.

-Rajkumar
