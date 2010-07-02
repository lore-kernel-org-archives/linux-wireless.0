Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32957 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab0GBSVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 14:21:35 -0400
Received: by bwz1 with SMTP id 1so1745906bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jul 2010 11:21:34 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rt2x00 & mac80211: correct usage of ieee80211_beacon_get_tim?
Date: Fri, 2 Jul 2010 20:20:57 +0200
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006241521.47623.helmut.schaa@googlemail.com> <201007021959.45704.helmut.schaa@googlemail.com> <1278093964.15412.24.camel@jlt3.sipsolutions.net>
In-Reply-To: <1278093964.15412.24.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201007022020.57398.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag 02 Juli 2010 schrieb Johannes Berg:
> On Fri, 2010-07-02 at 19:59 +0200, Helmut Schaa wrote:
> 
> > > unless your
> > > device itself is capable of generating the TIM IE _right before_ the
> > > beacon gets transmitted.
> > 
> > Agreed. At least on rt2800 we can use the pre tbtt interrupt to update the
> > beacon just before it is sent out.
> 
> Careful though. You don't know how far in advance it is triggered (or
> maybe you do) or if the time will be sufficient to generate and upload
> the beacon to the device. You could even hit lock contention I think.

Yeah, the delay is configurable. And yes, we cannot be 100% sure but
I already did some tests and on my MIPS board anything >1ms was
enough to generate + upload a new beacon to the device. And we can still
increase that to a safe default of maybe 5ms or so.

Helmut
