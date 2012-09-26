Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37085 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2IZHa4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 03:30:56 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20578.44784.141822.850065@gargle.gargle.HOWL> (sfid-20120926_093100_556510_54660B65)
Date: Wed, 26 Sep 2012 12:59:52 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: Sujith Manoharan <c_manoha@qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: Notify new IBSS network creation
In-Reply-To: <1348643666.10548.2.camel@jlt4.sipsolutions.net>
References: <20578.31128.207010.660580@gargle.gargle.HOWL>
	<1348643666.10548.2.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Interesting, I guess this makes sense. Never seemed to come up, maybe it
> doesn't matter all that much since we sync once we receive some other
> beacon, so worst case we just transmit a few spuriously?

Yes, that was the reported problem:
http://www.spinics.net/lists/linux-wireless/msg96846.html

ath9k programs the TBTT timers etc. based on the HW TSF, but this needs to
be done after a sync has been done (in joiner mode, that is). We do it for
station mode, but IBSS needs to fixed.

Sujith
