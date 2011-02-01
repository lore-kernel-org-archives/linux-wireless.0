Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:58708 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806Ab1BAWrP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 17:47:15 -0500
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 17/18] wl1251: enable tx path in monitor mode if necessary for packet injection
References: <4D45A79A.1030102@davizone.at> <4D45B7DC.3060303@davizone.at>
	<8762t5dptt.fsf@purkki.adurom.net> <4D473F16.4010102@davizone.at>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 02 Feb 2011 00:47:13 +0200
In-Reply-To: <4D473F16.4010102@davizone.at> (David Gnedt's message of "Tue\, 01 Feb 2011 00\:00\:38 +0100")
Message-ID: <87bp2vbcem.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Gnedt <david.gnedt@davizone.at> writes:

> Am 2011-01-31 17:02, schrieb Kalle Valo:
>
>> I would like to step back and first look at the problem you are trying
>> to solve and maybe there's a way we can fix the join command. Was it
>> something to do with firmware sending extra frames? Unfortunately TI
>> firmwares are notorious for that.
>
> Yeah, you are right, but I don't think the JOIN command can be
> fixed. Even if we use it with a zero BSSID and zero SSID, it sends
> some frames.

What frames are we talking about exactly? (I can't test this right now.)

> All in all I think the JOIN command was only meant to be used when you really
> want to associate.

Yes, that has been my impression as well. But I really don't know if
we have any better options. Adding the hack you did to tx path is
really awkward as well.

> It would be really unpleasant if the firmware keeps sending frames
> while channel hopping (through user-space software) in monitor mode.

I don't see it as that bad really, but of course it depends what
frames are sent.

-- 
Kalle Valo
