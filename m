Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:44075 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbYFQSmL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 14:42:11 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 0/7] IEEE 802.11w / management frame protection
Date: Tue, 17 Jun 2008 20:41:48 +0200
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
References: <20080617154008.883383150@localhost> <200806172027.50312.mb@bu3sch.de> <1213727507.3803.108.camel@johannes.berg>
In-Reply-To: <1213727507.3803.108.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200806172041.48622.mb@bu3sch.de> (sfid-20080617_204215_786599_EB4EF0ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 17 June 2008 20:31:47 Johannes Berg wrote:
> On Tue, 2008-06-17 at 20:27 +0200, Michael Buesch wrote:
> > On Tuesday 17 June 2008 20:23:22 Jouni Malinen wrote:
> > > On Tue, Jun 17, 2008 at 07:52:52PM +0200, Michael Buesch wrote:
> > > 
> > > > Well, as long as the checksum will fail in that case we're OK for b43,
> > > > as the driver will notify the need for software crypto for those packets.
> > > 
> > > Yes, MIC won't match (or well, in theory it could, but in practice..)
> > > and if the original frame is available after failed hw-decryption
> > > attempt, this is indeed all that's needed here. Some hardware designs
> > > are not able to deliver the unmodified frame due to the way AES hwaccel
> > > is implemented in them and that gets bit tricky to handle in software
> > > for IEEE 802.11w.
> > 
> > Yeah I see. Probably need to disable HW crypto for them.
> > (If firmware modification to pass MGMT frames untouched is impossible)
> 
> Broadcom's firmware already passes MGMT frames through untouched (unless
> they are auth frames and those aren't protected in 802.11w I think.)

Ah I see. Makes sense.

-- 
Greetings Michael.
