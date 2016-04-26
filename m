Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45235 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbcDZIja (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 04:39:30 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mt76: add common code shared between multiple chipsets
References: <1457039737-61262-1-git-send-email-nbd@openwrt.org>
	<87lh4p1hz8.fsf@purkki.adurom.net>
Date: Tue, 26 Apr 2016 11:39:24 +0300
In-Reply-To: <87lh4p1hz8.fsf@purkki.adurom.net> (Kalle Valo's message of "Thu,
	07 Apr 2016 19:50:03 +0300")
Message-ID: <87wpnkzrur.fsf@kamboji.qca.qualcomm.com> (sfid-20160426_103935_987158_044E58B9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Felix Fietkau <nbd@openwrt.org> writes:
>
>> This will be used by drivers for MT76x2e, MT7603e and MT7628
>>
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>
> I applied these to the pending branch in wireless-drivers-next so that
> kbuild can do it's magic.

It found one issue:

>> drivers/net/wireless/mediatek/mt76/built-in.o:(__tracepoints+0x1c): multiple definition of `__tracepoint_reg_read'
   drivers/net/wireless/mediatek/mt7601u/built-in.o:(__tracepoints+0x24c): first defined here
   drivers/net/wireless/mediatek/mt76/built-in.o: In function `mt76_insert_hdr_pad':
>> (.text+0x383): multiple definition of `mt76_insert_hdr_pad'
   drivers/net/wireless/mediatek/mt7601u/built-in.o:(.text+0x8e2d): first defined here
>> drivers/net/wireless/mediatek/mt76/built-in.o:(__tracepoints+0x0): multiple definition of `__tracepoint_reg_write'
   drivers/net/wireless/mediatek/mt7601u/built-in.o:(__tracepoints+0x230): first defined here
   drivers/net/wireless/mediatek/mt76/built-in.o: In function `mt76_remove_hdr_pad':
>> (.text+0x350): multiple definition of `mt76_remove_hdr_pad'
   drivers/net/wireless/mediatek/mt7601u/built-in.o:(.text+0x8dfa): first defined here

More info in the email kbuild sent.

-- 
Kalle Valo
