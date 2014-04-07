Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48808 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbaDGBFs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Apr 2014 21:05:48 -0400
Message-ID: <5341F9D0.2090808@candelatech.com> (sfid-20140407_030600_474922_1F6B61DA)
Date: Sun, 06 Apr 2014 18:05:20 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>, ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFT 0/4] ath10k: fix flushing and tx stalls
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com> <5341F1A9.2030202@candelatech.com>
In-Reply-To: <5341F1A9.2030202@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/06/2014 05:30 PM, Ben Greear wrote:
> On 04/04/2014 04:37 AM, Michal Kazior wrote:
>> Hi,
>>
>> After digging around I've found what seems to be
>> the problem with WMI Tx credit starvation and
>> inability to properly flush Tx in ath10k_flush().
>
> I applied all four, rebooted AP and Station machine with the
> new kernel (3.14.0-wl-ath+).  I had removed my own tx-hang detection
> hack.

Looks like the problems start with patch 3/4.

All tests were done with all 4 patches applied on the AP machine,
and it appears that works fine.  The station machine worked fine with
the first two patches, but when third was applied, only a few stations
come up and I get behaviour similar to that described in the first email,
but I do not see anything obviously wrong in dmesg...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

