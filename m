Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:40823 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbZH2FWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Aug 2009 01:22:47 -0400
Received: by bwz19 with SMTP id 19so1937622bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2009 22:22:48 -0700 (PDT)
To: tim.gardner@canonical.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
	reinette chatre <reinette.chatre@intel.com>,
	"linville\@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] cfg80211: initialize rate control after station inserted
References: <1251416094-10420-1-git-send-email-reinette.chatre@intel.com>
	<1251445557.4189.14.camel@johannes.local>
	<1251474321.3805.73.camel@rc-desk>
	<1251493298.3456.34.camel@johannes.local>
	<4A984EBA.9040608@canonical.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 29 Aug 2009 08:22:46 +0300
In-Reply-To: <4A984EBA.9040608@canonical.com> (Tim Gardner's message of "Fri\, 28 Aug 2009 15\:40\:10 -0600")
Message-ID: <874orrjis9.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tim Gardner <tim.gardner@canonical.com> writes:

>> Interesting. I've been thinking about making it go the other way --
>> remove rate scaling hooks completely. wl1271 apparently has rate scaling
>> completely in the firmware, so the RS algorithm on the host is just
>> overhead. I've been thinking putting 4965+ RS into the _driver_ makes
>> more sense since it really does a lot in the firmware and not on the
>> host.
>>
>> Do you think we should try to go that route? I'd think it would probably
>> be a hardware flag ("no RS algo please") and then we'd skip all the
>> hooks and put things into the driver. The advantage is that we don't
>> care about the mac80211 API any more, things get cleaner and we can just
>> do all RS init from sta_notify().
>>
>
> Wouldn't that make it difficult to experiment with external rate
> scaling algorithms? Not that minstrel or the other in-driver rate
> scaling algorithms always get it right, but they are certainly more
> transparent (and changeable) then firmware.

In wl1271 you are forced to use the rate scaling algorithm from the
firmware. IIRC tx descriptor doesn't even have a field for the bitrate.

-- 
Kalle Valo
