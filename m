Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58470 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbaBFRKU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 12:10:20 -0500
Message-ID: <52F3C1F1.3090509@candelatech.com> (sfid-20140206_181024_055873_00CCB8D3)
Date: Thu, 06 Feb 2014 09:10:09 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH v2] ath9k: Remove ath9k rate control
References: <1391662375-28781-1-git-send-email-sujith@msujith.org> <52F3B155.6010308@candelatech.com> <21235.46879.960127.346448@gargle.gargle.HOWL>
In-Reply-To: <21235.46879.960127.346448@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2014 08:23 AM, Sujith Manoharan wrote:
> Ben Greear wrote:
>> Can you let us know the details on how your set up that TCP
>> traffic?  For instance, number of streams, write size, socket
>> buffer sizes, etc?  Upload, download, or are both similar
>> throughput in your testing?
> 
> Stock OpenWrt (trunk) running on a 3x3 Scorpion board (AP136/AP135) as AP.
> Windows 7 as client, using a 3x3 AR9300 card.
> 
> iperf with window size 512k, 4 parallel threads. With both
> TX and RX, 290+ Mbps is seen. UDP traffic: 330 Mbps in both directions.
> Environment: open air and the station is located about 1 meter from the AP.

We get similar UDP throughput (and maybe up to 340Mbps using ath9k
rate control), but not so good on TCP.

All our tests so far are on 3.9 kernel, so maybe things are better on
later kernels.

Someday soon-ish we'll be moving to newer kernels and will test it
again.

>> I find that those settings influence throughput a great deal,
>> and I have not yet been able to reach 295Mbps of TCP throughput
>> in our testing w/out hacking the tcp-ack logic to increase ack delays.
> 
> By adjusting TCP parameters using sysctl or hacking the code ?

There is no sysctl for this in upstream code as far as I know
...I ended up hacking code by modifying some delayed-ack patches
someone else posted some time back.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

