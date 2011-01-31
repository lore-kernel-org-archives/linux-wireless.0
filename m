Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:35431 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670Ab1AaXAq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 18:00:46 -0500
Message-ID: <4D473F16.4010102@davizone.at>
Date: Tue, 01 Feb 2011 00:00:38 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 17/18] wl1251: enable tx path in monitor mode if necessary
 for packet injection
References: <4D45A79A.1030102@davizone.at> <4D45B7DC.3060303@davizone.at> <8762t5dptt.fsf@purkki.adurom.net>
In-Reply-To: <8762t5dptt.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 2011-01-31 17:02, schrieb Kalle Valo:
> David Gnedt <david.gnedt@davizone.at> writes:
> 
>> If necessary enable the tx path in monitor mode for packet injection using
>> the JOIN command with BSS_TYPE_STA_BSS and zero BSSID.
> 
> Ok, this answers my question, you send TX_ENABLE command during the
> first frame transmission. I have to admit that it sounds a bit
> hackish. I would prefer to keep the driver as simple as possible,
> makes it easier to maintain it that way.
> 
> I would like to step back and first look at the problem you are trying
> to solve and maybe there's a way we can fix the join command. Was it
> something to do with firmware sending extra frames? Unfortunately TI
> firmwares are notorious for that.

Yeah, you are right, but I don't think the JOIN command can be fixed. Even if we
use it with a zero BSSID and zero SSID, it sends some frames. Then there are not
much parameters left, which can influence it's behaviour.

All in all I think the JOIN command was only meant to be used when you really
want to associate.

It would be really unpleasant if the firmware keeps sending frames while channel
hopping (through user-space software) in monitor mode.
That's why I use RX_ENABLE to switch channels in monitor mode, but that again
results in a disabled TX path. My testing showed that it also can't be enabled
again with TX_ENABLE, only a JOIN command enables the TX path again.

By the way, I only split up RX_ENABLE and TX_ENABLE to reduce the amount of
firmware commands sent.

So summing up, I think the JOIN command is the only command which enables the TX
path, but with the drawback of also transmitting some extra frames.

Nevertheless I am going to experiment with the JOIN command again, maybe I have
overlooked something.
