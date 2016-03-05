Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:48931 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbcCEOak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2016 09:30:40 -0500
Message-ID: <56DAED8E.6020407@candelatech.com> (sfid-20160305_153129_951778_59AA5AA8)
Date: Sat, 05 Mar 2016 06:30:38 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org, rmanohar@codeaurora.org
Subject: Re: [PATCH] ath10k: move mgmt descriptor limit handle under mgmt_tx
References: <1457187017-12913-1-git-send-email-rmanohar@qti.qualcomm.com>
In-Reply-To: <1457187017-12913-1-git-send-email-rmanohar@qti.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 03/05/2016 06:10 AM, Rajkumar Manoharan wrote:
> Firmware reserves few descriptors for management frames transmission.
> In 16 MBSSID scenario, these slots will be easy exhausted due to frequent
> probe responses. So for 10.4 based solutions, probe responses are limited
> by a threshold (24).

Do you mean probe requests or probe responses?

A single hardware scan request with lots of ssids in it will utilize all
firmware tx management frames (which is 5, it seems).  In my testing, the
firmware would just never send probe requests for the rest of the ssids
because the firmware scan state machine logic is broken.

If you really do mean responses, then it sounds like it would be better to
use the normal RX path for mgt frames in the firmware...


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
