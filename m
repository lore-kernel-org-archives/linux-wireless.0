Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33724 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab1CJNPS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 08:15:18 -0500
Message-ID: <4D78CEE4.1070706@openwrt.org>
Date: Thu, 10 Mar 2011 14:15:16 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 4/4] ath9k: improve reliability of beacon transmission
 and stuck beacon handling
References: <1299717303-42430-1-git-send-email-nbd@openwrt.org> <1299717303-42430-2-git-send-email-nbd@openwrt.org> <1299717303-42430-3-git-send-email-nbd@openwrt.org> <1299717303-42430-4-git-send-email-nbd@openwrt.org> <20110310094629.GE28100@vasanth-laptop> <4D78CC61.2050201@openwrt.org>
In-Reply-To: <4D78CC61.2050201@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-03-10 2:04 PM, Felix Fietkau wrote:
> On 2011-03-10 10:46 AM, Vasanthakumar Thiagarajan wrote:
>> On Thu, Mar 10, 2011 at 06:05:03AM +0530, Felix Fietkau wrote:
>>> ath9k calls ath9k_hw_stoptxdma every time it sends a beacon, however there
>>> is not much point in doing that if the previous beacon and mcast traffic
>>> went out properly. On AR9380, calling that function too often can result
>>> in an increase of stuck beacons due to differences in the handling of the
>>> queue enable/disable functionality.
>>> 
>>> With this patch, the queue will only be explicitly stopped if the previous
>>> data frames were not sent successfully. With the beacon code being the
>>> only remaining user of ath9k_hw_stoptxdma, this function can be simplified
>>> in order to remove the now pointless attempts at waiting for transmission
>>> completion, which would never happen at this point due to the different
>>> method of tx scheduling of the beacon queue.
>> 
>> Thanks. Can this patch be split into two, one which possibly fixes btsuck
>> (a stable fix) and the other one which is a cleanup?.
> OK. I'll split it up, but won't propose it for stable yet, I want to see
> how well it works for users first.
Actually, now that I think about it, it can't easily be split up without
introducing potential side-effects. The unmodified ath9k_hw_stoptxdma
should not be called when a beacon is stuck, because then it will hit
the code path that tries to kill pending frames by setting various flags
and waiting for a while, which is absolutely counterproductive when
being done to the beacon queue.
I think it's better to leave the patch as a whole, the changes to
ath9k_hw_stoptxdma do not fix anything without the changes to beacon.c.

- Felix
