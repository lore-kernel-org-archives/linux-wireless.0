Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57497 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbcCFELV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2016 23:11:21 -0500
Message-ID: <56DBADE6.5060507@candelatech.com> (sfid-20160306_051125_548601_10EC0725)
Date: Sat, 05 Mar 2016 20:11:18 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
CC: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: move mgmt descriptor limit handle under mgmt_tx
References: <1457187017-12913-1-git-send-email-rmanohar@qti.qualcomm.com> <56DAED8E.6020407@candelatech.com> <08ae455b4733d8c1607427b10acc759c@codeaurora.org>
In-Reply-To: <08ae455b4733d8c1607427b10acc759c@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 03/05/2016 08:00 PM, Rajkumar Manoharan wrote:
> On , Ben Greear wrote:
>> On 03/05/2016 06:10 AM, Rajkumar Manoharan wrote:
>>> Firmware reserves few descriptors for management frames transmission.
>>> In 16 MBSSID scenario, these slots will be easy exhausted due to frequent
>>> probe responses. So for 10.4 based solutions, probe responses are limited
>>> by a threshold (24).
>>
>> Do you mean probe requests or probe responses?
>>
> I meant probe responses in AP mode.
>
>> A single hardware scan request with lots of ssids in it will utilize all
>> firmware tx management frames (which is 5, it seems).  In my testing, the
>> firmware would just never send probe requests for the rest of the ssids
>> because the firmware scan state machine logic is broken.
>>
> Hmm... firmware expects both ssid and bssid list to be filled for multiple probe
> requests. Better to try with different probe spacing time, repeat probe time and
> probe delay and dwell time as these params change prob_req behavior in firmware.

It was easier to just fix the firmware than to hack the
rest of the stack.

> Anyway this change is not related to scan functionality.
>
>> If you really do mean responses, then it sounds like it would be better to
>> use the normal RX path for mgt frames in the firmware...
>>
> Let me clarify. Sending probe responses in AP mode are limited by a threshold
> for qca99x0 ("ath10k: drop probe responses when too many are queued"). This change
> moves probe response checks under mgmt_tx from common data path.

Ok, I'll take a look at that.  I've implemented MGT frames over the completely
normal HTT data-path transport, so probably I won't hit that in my systems
anyway (there should be no internal mgt-frame limitation, except for locally
created things like probe requests during scan).  But, I could be missing
something...I'm really just getting started with 10.4...

Thanks,
Ben


>
> -Rajkumar
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
