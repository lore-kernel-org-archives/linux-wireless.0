Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39730 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaBFP7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Feb 2014 10:59:42 -0500
Message-ID: <52F3B155.6010308@candelatech.com> (sfid-20140206_165945_152500_0C12400A)
Date: Thu, 06 Feb 2014 07:59:17 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>,
	John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH v2] ath9k: Remove ath9k rate control
References: <1391662375-28781-1-git-send-email-sujith@msujith.org>
In-Reply-To: <1391662375-28781-1-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/05/2014 08:52 PM, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> There is no benefit in retaining the legacy rate control module
> in the driver codebase.
>
> It is known to be buggy and has less than optimal performance
> in real-world environments compared with minstrel. The only
> reason that it was kept when we made the switch to minstrel
> as default was that it showed higher throughput numbers in a
> clean/ideal environment.
>
> This is no longer the case and minstrel can push ath9k to
> the same throughput levels. In TCP, with 3-stream cards, more than
> 295 Mbps can be obtained in open air, with 2-stream cards,
> 210 Mbps is easily reached. To test performance issues,
> instead of using a broken rate control module, it is better
> to use the fixed-rate interface provided by mac80211 anyway.

Can you let us know the details on how your set up that TCP
traffic?  For instance, number of streams, write size, socket
buffer sizes, etc?  Upload, download, or are both similar
throughput in your testing?

I find that those settings influence throughput a great deal,
and I have not yet been able to reach 295Mbps of TCP throughput
in our testing w/out hacking the tcp-ack logic to increase ack delays.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

