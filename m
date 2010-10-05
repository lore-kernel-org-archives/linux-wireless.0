Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50454 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab0JEUle (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 16:41:34 -0400
Subject: Re: [PATCH wireless-2.6] mac80211: delete AddBA response timer
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CAB8C39.5090201@candelatech.com>
References: <1286307633.3641.29.camel@jlt3.sipsolutions.net>
	 <1286309408.3641.31.camel@jlt3.sipsolutions.net>
	 <4CAB8C39.5090201@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 22:41:29 +0200
Message-ID: <1286311289.3641.34.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-05 at 13:36 -0700, Ben Greear wrote:

> >> I've reproduced the scenario and tested the fix.

> > This fixes the crash reported at
> > http://mid.gmane.org/4CAB6F96.6090701@candelatech.com
> 
> I can no longer reproduce that problem, so it looks fixed
> to me.

Yeah .. I did actually go and reproduce the crash by strategically
adding an msleep(200) to the mac80211 code and then doing some things
from userspace :-)

> The data corruption issue still exists, however...

That looks very much like an ath9k issue, it seems like it's doing DMA
into already freed SKBs. Come to think of it, maybe that wmb() patch
might help?:

johannes

