Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:62248 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933144Ab1ETOp3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 10:45:29 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 20 May 2011 07:44:59 -0700
From: Kalle Valo <kalle.valo@atheros.com>
To: Marcel Holtmann <marcel@holtmann.org>
CC: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"gregkh\@suse.de" <gregkh@suse.de>,
	"linville\@tuxdriver.com" <linville@tuxdriver.com>,
	"devel\@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: Plan for ath6kl cleanup
References: <4DD668F4.6090308@atheros.com> <1305901563.2681.9.camel@aeonflux>
Date: Fri, 20 May 2011 17:45:07 +0300
In-Reply-To: <1305901563.2681.9.camel@aeonflux> (Marcel Holtmann's message of
	"Fri, 20 May 2011 07:26:03 -0700")
Message-ID: <87liy1qvm4.fsf@atheros.com> (sfid-20110520_164533_568162_24CC8DB0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcel Holtmann <marcel@holtmann.org> writes:

> Hi Kalle,

Hi Marcel,

>> We have been thinking about how to get ath6kl out from staging and get
>> it to a first class citizen under drivers/net/wireless. There's quite a
>> lot of work to do get ath6kl cleaned up and the prospect of doing all
>> that through the staging-next tree wasn't that exciting. We would be
>> sending hundreds of patches and it would take a long time to cleanup the
>> driver. And the disconnection from the wireless core development also
>> sounded very daunting (cfg80211 API changes etc.).
>
> my main question is why do you still bother with this driver and not
> re-write it as a mac80211 driver from scratch. It seems to be more
> softmac than fullmac anyway. Or am I mistaken here?

Actually ar6003, the chip ath6kl supports, is a fullmac. It can take
ethernet frames, all authentication/association frames are created by
the firmware and firmware manages the roaming as well. So there isn't
anything mac80211 could do.

> The source code of the current staging driver is 5 MB in size. That is
> by far the largest staging driver. Even brcm80211 is smaller.

Yeah, the driver is huge. But once the cleanup is done it will be a lot
smaller.

Kalle
