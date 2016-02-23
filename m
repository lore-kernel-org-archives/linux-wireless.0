Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:42959 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbcBWTDI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 14:03:08 -0500
Subject: Re: [PATCH 1/2] mac80211: add A-MSDU tx support
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1455820762-22876-1-git-send-email-nbd@openwrt.org>
 <1456226757.2041.35.camel@sipsolutions.net> <56CC4CAC.4080501@openwrt.org>
 <1456232731.9910.4.camel@sipsolutions.net>
Cc: egrumbach@gmail.com
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56CCACE9.5040404@openwrt.org> (sfid-20160223_200312_796889_4E53B37A)
Date: Tue, 23 Feb 2016 20:03:05 +0100
MIME-Version: 1.0
In-Reply-To: <1456232731.9910.4.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-02-23 14:05, Johannes Berg wrote:
>> Yes. If A-MSDU in A-MPDU is not supported, dealing with starting and
>> stopping of A-MPDU sessions leaves all kinds of nasty corner cases
>> (since the txq is not flushed between sessions). In that case it's
>> better to just leave it disabled from that point on.
> 
> Fair enough. You should be able to deal with it with the SSN, but that
> might be difficult.
> 
> Actually, mac80211 on its own assigns the seqno so frames already on
> the txq would not become part of the session, so we should be OK
> without much effort?
seqno is assigned on txq dequeue, not enqueue.

- Felix
