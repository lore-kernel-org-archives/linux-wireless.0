Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59678 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453AbbEZOCt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 10:02:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jakub Kicinski <moorray3@wp.pl>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jakub Kicinski <kubakici@wp.pl>
Subject: Re: [PATCHv3 0/2] add mt7601u driver
References: <1430571690-9054-1-git-send-email-moorray3@wp.pl>
	<1432546473-18081-1-git-send-email-moorray3@wp.pl>
Date: Tue, 26 May 2015 13:26:00 +0300
In-Reply-To: <1432546473-18081-1-git-send-email-moorray3@wp.pl> (Jakub
	Kicinski's message of "Mon, 25 May 2015 11:34:31 +0200")
Message-ID: <87d21n3a9z.fsf@kamboji.qca.qualcomm.com> (sfid-20150526_160255_342950_5A48F9C5)
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
>
> v3:
>  - rebase
>
> Jakub Kicinski (2):
>   add mt7601u driver
>   add mt7601u kbuild and others

I pushed v4 (a squashed version of these patches which didn't make it to
the list for some reason) to the pending branch:

https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?h=pending&id=1feab03d9ecce61ec9a64a56fda7717e703135a9

I'm planning to apply this soon. So if anyone has concerns or comments
about this driver better to speak up now.

-- 
Kalle Valo
