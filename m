Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:51855 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab0IUMTg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 08:19:36 -0400
Message-ID: <4C98A2C4.8060108@openwrt.org>
Date: Tue, 21 Sep 2010 14:19:16 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [ath9k-devel] ath9k, multiple stations, and AMPDUs
References: <4C9841BA.4080700@candelatech.com> <4C98848C.70005@openwrt.org> <4C98A022.7020106@candelatech.com>
In-Reply-To: <4C98A022.7020106@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-09-21 2:08 PM, Ben Greear wrote:
> On 09/21/2010 03:10 AM, Felix Fietkau wrote:
>> On 2010-09-21 7:25 AM, Ben Greear wrote:
>>> I think I have narrowed down some problems I see when I create
>>> two STA interfaces on the same radio and associate with the
>>> same AP.
>>>
>>> I'm using wireless-testing plus some patches to the rx logic
>>> I posted earlier.
>>>
>>> It appears that the ath9k NIC does not transport AMPDUs properly,
>>> and after a few seconds, it's backlog is exhausted and the queues
>>> are stopped in ath_tx_start.
>> ath9k currently looks up the sta by hw and not by vif on tx completion.
>> That completely breaks aggregation in such a setup. Unfortunately I
>> don't know an easy way to fix this yet.
>>
>> This will be fixed by my sw aggregation rewrite, but I don't know when
>> I'll get that completed yet.
> 
> If you have any more details on this, please let me know.  I'm going to
> attempt to fix it...I certainly have a good test case :)
ath_tx_complete_aggr completes an A-MPDU frame, which typically triggers
the release of the next A-MPDU to the hw queue.
To keep track of the Block ACK window, it needs to look up the TID, for
which it needs a STA pointer. At that level, the driver typically
doesn't have access to the vif.

It might be possible to fix this by adding another sta lookup helper
function in mac80211 that takes another address argument for the BSSID,
so that it can get the sta entry for the correct vif. I don't know if
Johannes wants something like that though.

- Felix
