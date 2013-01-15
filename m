Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57247 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432Ab3AOMGv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jan 2013 07:06:51 -0500
Message-ID: <50F5464C.4020608@openwrt.org> (sfid-20130115_130658_131481_AF1578CF)
Date: Tue, 15 Jan 2013 13:06:36 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Tx AMSDU Support
References: <CABPxzYL1LM-XAAb1RomgcM=O9Ma=KJZcbmEgTA678FSFuT8QMg@mail.gmail.com>
In-Reply-To: <CABPxzYL1LM-XAAb1RomgcM=O9Ma=KJZcbmEgTA678FSFuT8QMg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-01-15 11:20 AM, Krishna Chaitanya wrote:
> Hi Johannes,
> 
> Is there any work in progress/planned related to Tx AMSDU logic in mac80211?
> Even though only Rx is mandatory, but to test the Rx we need the Tx.
> 
> I see that the support is there in mwifiex(marvell's) driver. So is
> there any patent/legal issue before we can implement one?
The issue with AMSDU Tx is a technical one, not a legal one: A-MSDU
aggregation needs a queue and some buffering to properly work, A-MPDU
needs the same. A-MPDU is typically implemented in the driver/firmware.

Doing extra buffering/queueing in mac80211 is not a good idea, as it
would add significant extra latency in the Tx path, so A-MSDU
aggregation really needs to be done on the same queue.

For implementing A-MSDU in ath9k, my plan is to share the per-sta-tid
A-MPDU driver queues between mac80211 and ath9k. That way I can keep the
logic inside mac80211 with no added buffering/latency. I might even be
able to have an A-MSDU aggregation fastpath that happens before 802.11
header encapsulation.

The problem with this approach is that it doesn't work with drivers
using hardware/firmware based A-MPDU aggregation. Such drivers will
probably either have to do A-MSDU in firmware as well, or

- Felix
