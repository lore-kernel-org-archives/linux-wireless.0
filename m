Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx71.mail.ru ([94.100.176.85]:61974 "EHLO mx71.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760082AbZIPVEh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 17:04:37 -0400
Date: Thu, 17 Sep 2009 01:11:28 +0300
From: Nikolai ZHUBR <zhubr@mail.ru>
Message-ID: <152337350.20090917011128@mail.ru>
To: linux-wireless@vger.kernel.org
CC: Hin-Tak Leung <hintak.leung@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Gaurav Jauhar <gaurav.jauhar@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: Re[8]: cfg80211 and rfkill_backport question.
In-reply-To: <3ace41890909160824w146d63e6haddabe645d3e27d2@mail.gmail.com>
References: <174470396.20090916030952@mail.ru>
 <43e72e890909151614l9820e2y7031e09de11653@mail.gmail.com>
 <792649359.20090916034611@mail.ru>
 <43e72e890909151649x66321b6emdc2977473e22872a@mail.gmail.com>
 <90263558.20090916050213@mail.ru>
 <43e72e890909151817u375cd847r7cdf78b53f26fe2f@mail.gmail.com>
 <1382256815.20090916121443@mail.ru>
 <3ace41890909160824w146d63e6haddabe645d3e27d2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wednesday, September 16, 2009, 6:24:11 PM, Hin-Tak Leung wrote:
>> From what I checked it all looks fine to me, except that there is
>> a circular dependency between cfg80211 and rfkill_backport (which
>> is confirmed by nm output I suppose). Is this circular dependency
>> intentional? Or, could it be avoided? (My understanding was that
>> as module loader loads one file at a time, it just have no way
>> to resolve such symbols, maybe I'm wrong on this)

> Hmm, yes and no... insmod loads modules one at a time; but as long as
> you run depmod, modprobe loads dependent modules automatically. I
> don't know if modprobe works for circular dependency, but it probably
> works correctly (since AFAIK, it reference-counts)?
Well, maybe modprobe is smart enough these days already, but openwrt
doesn't have it.
Anyway.
Circular dependency issue is now gone together with rfkill_backport
as I don't need rfkill at this point.
"Unable to reserve mem region" error was probably MIPS-related or
PCI-related and gone after cold reboot.

Now here is another:
 in function wiphy_register (net/wireless/core.c):
   device_add returns an error (-22)

Looks like some problem in mac80211<-->kernel_2.6.25 communication?
 
regards,
 Nikolai


