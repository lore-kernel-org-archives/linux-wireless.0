Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:48386 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180AbZCaRqD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 13:46:03 -0400
Received: by bwz17 with SMTP id 17so2482677bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2009 10:45:59 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: reinette chatre <reinette.chatre@intel.com>,
	Nico -telmich- Schottelius
	<nico-linux-ipw3945-devel@schottelius.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ipw3945-devel] 2.6.29-wl-36116-g6a982a0: connection loss
References: <20090331044946.GA10616@denkbrett.schottelius.org>
	<1238519733.10366.32.camel@rc-desk>
	<1238520041.5970.112.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 31 Mar 2009 20:45:57 +0300
In-Reply-To: <1238520041.5970.112.camel@johannes.local> (Johannes Berg's message of "Tue\, 31 Mar 2009 19\:20\:41 +0200")
Message-ID: <8763hpsi0a.fsf@litku.valot.fi> (sfid-20090331_194607_701221_3D32CC07)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> Perhaps the new beacon filtering work [1] is changing more than it
>> intended?
>
> I think it only changed the messages here. Previously, that message
> simply wouldn't have been there, instead you'd only have seen the "No
> ProbeResp from current AP - assume out of range" thing.

At least I have been using latest wireless-testing with iwl3945 all the time
(for example right now) and I haven't noticed any problems.

But your comment makes me think is the "beacon loss" message too
verbose. Maybe we should remove it?

BTW, what are the AP settings (beacon interval, DTIM)? Was power save
enabled in the driver? If the beacon interval is really long, like 1
second, our timer is far from optimal and missing beacon only once
might trigger the warning. We should fix that properly at some point.

-- 
Kalle Valo
