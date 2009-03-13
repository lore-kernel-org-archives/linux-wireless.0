Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42090 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbZCMGFb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 02:05:31 -0400
Received: from mail.atheros.com ([10.10.20.86])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 23:05:30 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18873.63152.836875.231557@gargle.gargle.HOWL> (sfid-20090313_070535_616053_EC131036)
Date: Fri, 13 Mar 2009 11:31:20 +0530
To: Sujith <m.sujith@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Subject: Re: ath9k fragmentation
In-Reply-To: <18873.48952.353253.595670@gargle.gargle.HOWL>
References: <1236881434.25931.1.camel@johannes.local>
	<18873.48952.353253.595670@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith wrote:
> Johannes Berg wrote:
> > Just a quick note -- was testing fragmentation and happened to use ath9k
> > as the test station, this failed utterly, it sent increasing sequence
> > numbers and no fragment number.
> 
> Sequence number handling is pretty much borked in ath9k.
> There is a comment in assign_aggr_tid_seqno@xmit.c - and it doesn't make much sense.
> Removing all crappy code in ath9k dealing with this and leaving everything
> to mac80211 would certainly be the better option, but we still have to figure
> out how to manage BA windows.
> 

And a quick hack to fix this would be to not increment the internal sequence
number when the frame is fragmented. But that is what it would be, a hack. :)

Sujith
