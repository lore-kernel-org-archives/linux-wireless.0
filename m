Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54731 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbcCFEAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2016 23:00:16 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sun, 06 Mar 2016 09:30:15 +0530
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: move mgmt descriptor limit handle under mgmt_tx
In-Reply-To: <56DAED8E.6020407@candelatech.com>
References: <1457187017-12913-1-git-send-email-rmanohar@qti.qualcomm.com>
 <56DAED8E.6020407@candelatech.com>
Message-ID: <08ae455b4733d8c1607427b10acc759c@codeaurora.org> (sfid-20160306_050020_679521_84757091)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Ben Greear wrote:
> On 03/05/2016 06:10 AM, Rajkumar Manoharan wrote:
>> Firmware reserves few descriptors for management frames transmission.
>> In 16 MBSSID scenario, these slots will be easy exhausted due to 
>> frequent
>> probe responses. So for 10.4 based solutions, probe responses are 
>> limited
>> by a threshold (24).
> 
> Do you mean probe requests or probe responses?
> 
I meant probe responses in AP mode.

> A single hardware scan request with lots of ssids in it will utilize 
> all
> firmware tx management frames (which is 5, it seems).  In my testing, 
> the
> firmware would just never send probe requests for the rest of the ssids
> because the firmware scan state machine logic is broken.
> 
Hmm... firmware expects both ssid and bssid list to be filled for 
multiple probe
requests. Better to try with different probe spacing time, repeat probe 
time and
probe delay and dwell time as these params change prob_req behavior in 
firmware.

Anyway this change is not related to scan functionality.

> If you really do mean responses, then it sounds like it would be better 
> to
> use the normal RX path for mgt frames in the firmware...
> 
Let me clarify. Sending probe responses in AP mode are limited by a 
threshold
for qca99x0 ("ath10k: drop probe responses when too many are queued"). 
This change
moves probe response checks under mgmt_tx from common data path.

-Rajkumar
