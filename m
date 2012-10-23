Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41887 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678Ab2JWHWl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2012 03:22:41 -0400
Message-ID: <1350976995.10322.2.camel@jlt4.sipsolutions.net> (sfid-20121023_092244_631398_249B60FF)
Subject: Re: Add option to have more than one process listen for beacons per
 wiphy?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 23 Oct 2012 09:23:15 +0200
In-Reply-To: <5085DB66.7020400@candelatech.com> (sfid-20121023_014858_488231_EE4955D4)
References: <5085DB66.7020400@candelatech.com>
	 (sfid-20121023_014858_488231_EE4955D4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-10-22 at 16:48 -0700, Ben Greear wrote:

> A simple means would be a fixed-length array of nlpids (with max of maybe
> 16 or so).  Or, could do a variable length array, or list, or some other
> way to register more than one at a time.  If it were up to me, I'd choose
> a fixed-length array just to keep the code simple.
> 
> Any opinions on this?

Fixed-length seems like a bad idea, you'll eventually complain about it
again :P

A list of small structures like the management frame registrations seems
like the best option?

Alternatively, we could have a new multicast group but that'd also
require hostapd changes.

johannes

