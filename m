Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:45761 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbcBWNxy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 08:53:54 -0500
Message-ID: <56CC6471.8050204@candelatech.com> (sfid-20160223_145357_371772_A4F93510)
Date: Tue, 23 Feb 2016 05:53:53 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: akolli@qti.qualcomm.com, ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Reduce number of peers to support peer stats
 feature
References: <1456210197-27892-1-git-send-email-akolli@qti.qualcomm.com>
In-Reply-To: <1456210197-27892-1-git-send-email-akolli@qti.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/22/2016 10:49 PM, akolli@qti.qualcomm.com wrote:
> From: Anilkumar Kolli <akolli@qti.qualcomm.com>
>
> To enable per peer stats feature we are reducing the number of peers.
> Firmware has introduced tx stats feature. We have memory limitation in
> firmware to add these additional bytes.

Maybe this is OK for defaults, but we should also give the user the ability
to configure various things, including disabling pktlog, setting number
of vdevs, peers, tids, etc.  Maybe something like the parseable config file
patch I linked too earlier?

http://dmz2.candelatech.com/?p=linux-4.4.dev.y/.git;a=commit;h=6708e4047d91edf234239943332bc2f0d124d009

You can also save a lot of RAM in your firmware if you naturally pack your structs
better, and remove un-used members from various structures, etc.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
