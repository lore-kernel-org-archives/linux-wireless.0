Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50534 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743Ab3FEPAf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 11:00:35 -0400
Message-ID: <51AF528B.1000402@openwrt.org> (sfid-20130605_170038_828267_689F088B)
Date: Wed, 05 Jun 2013 17:00:27 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] ath9k: limit multicast buffer hardware queue depth
References: <1370280714-1594-1-git-send-email-nbd@openwrt.org> <20130605140932.GA8918@w1.fi>
In-Reply-To: <20130605140932.GA8918@w1.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-06-05 4:09 PM, Jouni Malinen wrote:
> On Mon, Jun 03, 2013 at 07:31:54PM +0200, Felix Fietkau wrote:
>> The CAB (Content after Beacon) queue is used for beacon-triggered
>> transmission of buffered multicast frames. If lots of multicast frames
>> were buffered and this queue fills up, it drowns out all regular
>> traffic. To limit the damage that buffered traffic can do, try to limit
>> the queued data to becaon_interval / 8.
> 
> I'm not sure this would be compliant with the standard, but I guess
> something along these lines could be reasonable in some cases. However,
> it could be useful to take into account different DTIM Period parameters
> in the limit and instead of hardcoding this to one eight of the Beacon
> interval, the limit could be set based on Beacon interval * DTIM Period.
> Especially with large DTIM Period values, one eight of a Beacon interval
> may not be sufficient to handle even reasonable amount of group
> addressed frames.
Makes sense.

> Does this commit address More Data field updates when the driver decides
> to stop getting more frames without notifying mac80211 of this? The
> associated STAs would need to know when they can go back to sleep after
> the DTIM Beacon and the More Data field needs to be set to zero in the
> last frame the AP is sending out in the case this new limit is hit.
I'll make a new version of this patch that takes care of the More Data
field.

- Felix
