Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46913 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab1ASAdq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 19:33:46 -0500
Message-ID: <4D363165.1010306@openwrt.org>
Date: Wed, 19 Jan 2011 01:33:41 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Subject: Re: [PATCH 1/2] ath9k: try more than one tid when scheduling a new
 aggregate
References: <1295098215-98910-1-git-send-email-nbd@openwrt.org> <4D362FC5.3090003@candelatech.com>
In-Reply-To: <4D362FC5.3090003@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-01-19 1:26 AM, Ben Greear wrote:
> On 01/15/2011 05:30 AM, Felix Fietkau wrote:
>> Sometimes the first TID in the first AC's list is not available for forming
>> a new aggregate (the BAW might not allow it), however other TIDs may have
>> data available for sending.
>> Prevent a slowdown of other TIDs by going through multiple entries until
>> we've either hit the last one or enough AMPDUs are pending in the hardware
>> queue.
> 
> I had attempted a similar patch, but I was thinking we should iterate
> through all of the txq->axq_acq entries, not just use the first one?
> 
> If you agree, I can merge my patch with your patch below
> and re-post.
My patch was merged, how about sending an incremental patch on top of it
for review?

- Felix
