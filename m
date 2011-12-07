Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1113 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902Ab1LGPxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 10:53:50 -0500
Date: Wed, 7 Dec 2011 21:23:27 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: Fix race in bss timeout
Message-ID: <20111207155325.GC12498@chvasanth-lnx> (sfid-20111207_165353_871819_CC9FCF85)
References: <1323270687-5989-1-git-send-email-vthiagar@qca.qualcomm.com>
 <1323271070.3404.40.camel@jlt3.sipsolutions.net>
 <20111207153052.GB12498@chvasanth-lnx>
 <1323272248.3404.43.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1323272248.3404.43.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 07, 2011 at 04:37:28PM +0100, Johannes Berg wrote:
> > 
> > These warnings are added in cfg80211_roamed().
> 
> But this can be called directly by the driver with a NULL BSS.
> 
> Ohh. I see what you did, you didn't allow drivers calling this now. I
> think you should export this function still since otherwise the race
> windows might get tiny, but isn't actually completely closed (the first
> get_bss() might find it, the next a millisecond later not)

I can understand the millisecond delay between cfg80211_get_bss() in driver and
__cfg80211_roamed() as there can be delay in event_work getting
scheduled. I don't understand the delay between driver and
cfg80211_roamed() as the later one is direct call. Or this can be
done later if experienced the delay?.

Vasanth
