Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:48884 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab1AaW6T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 17:58:19 -0500
Message-ID: <4D473E83.1050703@davizone.at>
Date: Mon, 31 Jan 2011 23:58:11 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 04/18] wl1251: add sysfs interface for bluetooth coexistence
 mode configuration
References: <4D45A5A5.5090909@davizone.at> <87mxmhdrdz.fsf@purkki.adurom.net>
In-Reply-To: <87mxmhdrdz.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 2011-01-31 16:28, schrieb Kalle Valo:
> Sorry, but this was an awful hack in the fremantle kernel and I really
> would not like to see this in the upstream driver. We should do better
> than that :) And besides, who would use it? The only user I know is
> maemo's wlancond and maemo is dead and buried anyway. RIP
> 
> I'm not saying that we don't need this, I just want to understand
> where we need this. And also sysfs is not the best choise imho, maybe
> debugfs is better?

I understand that you don't like this patch upstream, but I also think that it
is a very useful feature to switch btcoex on/off. Moreover I think 3 states
aren't needed at all, but we should at least be able to disable it completely.
Maybe we could also detect if bt is enabled/disabled in kernel and switch the
btcoex automatically?
By the way, how is this problem solved in other drivers?

>> It should be noted that this driver always enabled bt-coexistence before
>> and enabled bt-coexistence directly affects the receiving performance,
>> rendering it unusable in some low-signal situations. Especially monitor
>> mode is affected very badly with bt-coexistence enabled.
> 
> Yes, btcoex is very tricky to get right. Also one problem is that
> wl1251's btcoex implementation significantly increases power
> consumption.

One more point to make it switchable.
