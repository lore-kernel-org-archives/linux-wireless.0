Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35597 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab1AFUGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 15:06:20 -0500
Message-ID: <4D2620BA.8000804@candelatech.com>
Date: Thu, 06 Jan 2011 12:06:18 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: ath9k ath_tx_complete_poll_work doesn't always run.
References: <4D261E22.1090300@candelatech.com>
In-Reply-To: <4D261E22.1090300@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/06/2011 11:55 AM, Ben Greear wrote:
> It seems that the ath_tx_complete_poll_work method is supposed to
> run every 1 second to check for stale xmit buffers.
>
> However, I noticed that sometimes it is stopped, perhaps
> because the mac80211 workqueue is flushed and ath9k
> doesn't know to re-setup the work.
>
> I am curious if anyone knows how this is *supposed* to
> function?

Hrm, this may be my fault..a bug in my attempt to
not do so much channel-change code when the channel
has not in fact changed...

I'll look some more..

Ben

>
> Thanks,
> Ben
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

