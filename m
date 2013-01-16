Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41627 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089Ab3APEIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jan 2013 23:08:16 -0500
Received: by mail-wi0-f180.google.com with SMTP id hj13so822279wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2013 20:08:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50F5464C.4020608@openwrt.org>
References: <CABPxzYL1LM-XAAb1RomgcM=O9Ma=KJZcbmEgTA678FSFuT8QMg@mail.gmail.com>
 <50F5464C.4020608@openwrt.org>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 16 Jan 2013 09:37:54 +0530
Message-ID: <CABPxzYJFCQhYtpm6_nbpMg5i0cDDaVetXGTDi6yoTywnJdShkw@mail.gmail.com> (sfid-20130116_114554_653303_C1A136B4)
Subject: Re: Tx AMSDU Support
To: Felix Fietkau <nbd@openwrt.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 15, 2013 at 5:36 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2013-01-15 11:20 AM, Krishna Chaitanya wrote:
>> Hi Johannes,
>>
>> Is there any work in progress/planned related to Tx AMSDU logic in mac80211?
>> Even though only Rx is mandatory, but to test the Rx we need the Tx.
>>
>> I see that the support is there in mwifiex(marvell's) driver. So is
>> there any patent/legal issue before we can implement one?
> The issue with AMSDU Tx is a technical one, not a legal one: A-MSDU
> aggregation needs a queue and some buffering to properly work, A-MPDU
> needs the same. A-MPDU is typically implemented in the driver/firmware.
>
> Doing extra buffering/queueing in mac80211 is not a good idea, as it
> would add significant extra latency in the Tx path, so A-MSDU
> aggregation really needs to be done on the same queue.
>
> For implementing A-MSDU in ath9k, my plan is to share the per-sta-tid
> A-MPDU driver queues between mac80211 and ath9k. That way I can keep the
> logic inside mac80211 with no added buffering/latency. I might even be
> able to have an A-MSDU aggregation fastpath that happens before 802.11
> header encapsulation.
>
> The problem with this approach is that it doesn't work with drivers
> using hardware/firmware based A-MPDU aggregation. Such drivers will
> probably either have to do A-MSDU in firmware as well, or
>
> - Felix

Thanks Felix for the inputs. I suggest we can have a Tx AMSDU in mac80211
for only *Testing Purposes* of Rx AMSDU where we do not care about the
performance implications. But for commercial use drivers/firmware
can handle the same.
