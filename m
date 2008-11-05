Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:28011 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbYKEUnH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 15:43:07 -0500
Received: by yw-out-2324.google.com with SMTP id 9so116548ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2008 12:43:06 -0800 (PST)
Message-ID: <43e72e890811051243y65f8b51cy2f80279ecbebc8e4@mail.gmail.com> (sfid-20081105_214324_604741_07550D14)
Date: Wed, 5 Nov 2008 12:43:06 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Thoughts about mac80211 client PS implementation
Cc: "Kalle Valo" <kalle.valo@nokia.com>,
	linux-wireless@vger.kernel.org, "Felix Fietkau" <nbd@openwrt.org>
In-Reply-To: <1225917235.3619.180.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <87k5bhkjf1.fsf@nokia.com>
	 <1225917235.3619.180.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 5, 2008 at 12:33 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-11-05 at 22:27 +0200, Kalle Valo wrote:

BTW who defines "Dynamic Power Save"? Is there a standard approach or
more an implementation approach to the concept of doing PS while
active?

>> PS should be disabled while associated and running software scan, and
>> naturally re-enabled after the scan has finished. I assume hardware
>> scanning implementations are clever enough to disable PS when scanning
>> and we don't have to worry about that case.

BTW we need to check if in ath5k/ath9k if the beacon miss interrupt
will actually be triggered *if* the beacon filter is *off*. Not sure
about this yet. Also I'm not sure if triggering scanning will enable
beaconing filter in our hardware if its off and then disable it after
scanning too.

  Luis
