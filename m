Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56221 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbcDAFNl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 01:13:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 01 Apr 2016 10:43:38 +0530
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] ath10k: remove unnecessary warning for probe response
 drops
In-Reply-To: <56FD5716.6030406@candelatech.com>
References: <1459352551-11773-1-git-send-email-rmanohar@qti.qualcomm.com>
 <1459352551-11773-2-git-send-email-rmanohar@qti.qualcomm.com>
 <56FD5716.6030406@candelatech.com>
Message-ID: <43fd44912f230a28f0f49e303c0078f5@codeaurora.org> (sfid-20160401_071344_474729_9306AA3A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-03-31 22:27, Ben Greear wrote:
> On 03/30/2016 08:42 AM, Rajkumar Manoharan wrote:
>> qca99x0 and qca4019 solutions limit probe responses transmissions.
>> Logging warning message for each probe response drop is flooding
>> kernel log unnecessary with " failed to increase tx mgmt pending
>> count: -16, dropping". Hence reducing log level to debug.
> 
> Is there any realistic way to see this message if we are not running
> many vAP on one radio?
> 
As of now this message can be seen only with qca99x0 which has 24 as 
max_probe_resp_desc_thres. Only possible way in single vAP is that in 
congested environment when DUT is receiving probe requests more 
frequently.

> I guess many probe requests or other management frames could also
> cause this problem?
> 
Exactly.

-Rajkumar
