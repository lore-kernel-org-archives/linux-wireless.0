Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48002 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab1BIOWk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 09:22:40 -0500
Message-ID: <4D52A328.3010009@candelatech.com>
Date: Wed, 09 Feb 2011 06:22:32 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: implicit band switch or not
References: <op.vqmzowhl3ri7v4@arend-laptop>
In-Reply-To: <op.vqmzowhl3ri7v4@arend-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2011 04:59 AM, Arend van Spriel wrote:
> Hi Johannes,
>
> With our mac80211-based driver I was associated with 5GHz AP and ran into an assert. Investigating this I found that a software scan was initiated and our
> driver got a probe request from mac80211 to be transmitted. However, it turned out that the transmit rate was a 2GHz rate and our driver was still configured to
> 5GHz band. The ieee80211_tx_info also contained the band and indeed that was for 2GHz. Given the comment for the band attribute I am wondering whether we should
> a band switch implicitly or not:
>
> * @band: the band to transmit on (use for checking for races)
>
> Any suggestions? Are we have a race condition here?

What kernel revision was this happening in?  I just changed the scanning logic
a bit in wireless-testing...I don't think I would have caused this, but it's possible.

Thanks,
Ben

>
> Gr. AvS


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
