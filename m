Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38749 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbbEYINm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2015 04:13:42 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jakub Kicinski <moorray3@wp.pl>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jakub Kicinski <kubakici@wp.pl>
Subject: Re: [PATCHv2 0/2] add mt7601u driver
References: <1430571690-9054-1-git-send-email-moorray3@wp.pl>
	<1430857363-30844-1-git-send-email-moorray3@wp.pl>
Date: Mon, 25 May 2015 11:13:32 +0300
In-Reply-To: <1430857363-30844-1-git-send-email-moorray3@wp.pl> (Jakub
	Kicinski's message of "Tue, 5 May 2015 22:22:41 +0200")
Message-ID: <87fv6l3wib.fsf@kamboji.qca.qualcomm.com> (sfid-20150525_101347_180216_4827E69A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Kicinski <moorray3@wp.pl> writes:

> From: Jakub Kicinski <kubakici@wp.pl>
>
>> This miniseries adds support for the simplest of MediaTek Wi-Fi
>> devices.  MT7601U is a single stream bgn chip with no bells or whistles.
>> My driver is partially based on Felix's mt76 but IMHO it doesn't
>> make sense to merge the two right now because MT7601U is a design
>> somewhere between old Ralink devices and new Mediatek chips.  There
>> wouldn't be all that much code sharing with the devices mt76 supports.
>> Situation may obviously change when someone decides to extend m76 with
>> support for the more recent USB dongles.
>> 
>> The driver supports only station mode.  I'm hoping to add AP support
>> when time allows.
>> 
>> This driver sat on GitHub for quite a while and got some testing there.
>> If anyone is interested in full git history and such here's a link:
>> 
>> http://github.com/kuba-moo/mt7601u
>> 
>> I split the submission into the build things and meta data (kconfig,
>> Makefiles, MAINTAINERS update etc.) and the actual code to make the
>> reviewing a little easier.
>
> v2:
>  - don't zero parts of just allocated skb (Johannes)
>  - add delay to polling of MAC state (Johannes)
>  - use paged RX (Johannes)
>  - add more device IDs (Jose)
>  - reduce number of RX buffers
>  - increase max length of USB dma aggregate

It doens't compile anymore due to a mac80211 change. Can you rebase,
please?

drivers/net/wireless/mediatek/mt7601u/main.c: In function 'mt76_configure_filter':
drivers/net/wireless/mediatek/mt7601u/main.c:122:31: error: 'FIF_PROMISC_IN_BSS' undeclared (first use in this function)
drivers/net/wireless/mediatek/mt7601u/main.c:122:31: note: each undeclared identifier is reported only once for each function it appears in

-- 
Kalle Valo
