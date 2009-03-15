Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46392 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbZCOR7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2009 13:59:43 -0400
Subject: Re: [RFC PATCH v2 4/4] mac80211: add beacon filtering support
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <87r60z1c8x.fsf@nokia.com>
References: <20090314171234.11126.21125.stgit@tikku>
	 <20090314171452.11126.11618.stgit@tikku>
	 <43e72e890903141318n25fa5f4bi7903eee2ef216040@mail.gmail.com>
	 <87r60z1c8x.fsf@nokia.com>
Content-Type: text/plain
Date: Sun, 15 Mar 2009 18:59:15 +0100
Message-Id: <1237139955.24381.2.camel@johannes.local> (sfid-20090315_185947_740829_819A9CF9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-03-15 at 09:22 +0200, Kalle Valo wrote:
> "Luis R. Rodriguez" <lrodriguez@atheros.com> writes:
> 
> > Last we reviewed this it seemed we were set on only allowing this for
> > hardware which supports beacon filtering with support for checksumming
> > of the beacons. Reason checksumming is important is for considerations
> > of DFS with the channel switch announcements, HT with with channel width
> > changes. In fact I'm curious why checksumming would be required for 2.4 GHz
> > single band devices. Kalle, do you happen to know?
> 
> In my opinion also 2.4 GHz band needs checksum support. At least ERP
> protection changes come to my mind, but maybe there are also others.

Also, the virtual hardware support Jouni is working on might use quiet
elements, and these would have to be detected by the stations. We really
want beacon change detection somewhere.

> I think this is future stuff, I would like to get the basic (and the
> simplest) implementation to the tree first and then we can start
> improving and extending it.

Agreed, anything that is more complex than this basic stuff which
requires proper beacon change watching by the firmware is too much for
the first cut here -- we're having enough trouble as-is, for example
with the BSS struct stuff.

johannes

