Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23977 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbZCMKxD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 06:53:03 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2009 03:53:02 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18874.14867.311121.242263@gargle.gargle.HOWL> (sfid-20090313_115305_972812_894CAE13)
Date: Fri, 13 Mar 2009 16:18:51 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Subject: Re: ath9k fragmentation
In-Reply-To: <1236934984.25931.48.camel@johannes.local>
References: <1236881434.25931.1.camel@johannes.local>
	<18873.48952.353253.595670@gargle.gargle.HOWL>
	<1236934984.25931.48.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> > Removing all crappy code in ath9k dealing with this and leaving everything
> > to mac80211 would certainly be the better option, but we still have to figure
> > out how to manage BA windows.
> 
> Can you explain a little what is required?
> 

Managing per-TID state to handle Block ACKs, failed sub-frames,
sub-frame retries and other window management stuff.
ath9k manages all this internally.

> For ampdu_action(), I recently saw something, somewhere, saying
> "mac80211 expects us to fill in the seqno variable" or so, but this is
> only true if you don't use mac80211's sequence numbers, otherwise it is
> fine to leave it at the pre-assigned value.

ampdu_action() requires the driver to set the starting sequence number
for initiating an ADDBA session, ath9k was filling it incorrectly.
This was fixed in the patch, "ath9k: Fix bug in TX aggregation".

Sujith
