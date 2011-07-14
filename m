Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:59876 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754882Ab1GNNp0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 09:45:26 -0400
Date: Thu, 14 Jul 2011 15:45:20 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: carl9170 firmware: WoWLAN and adding fields to
 carl9170_tx_superdesc
Message-ID: <20110714134520.GA3649@zenon.in.qult.net> (sfid-20110714_154529_898198_701BF169)
References: <20110714122803.GA31692@zenon.in.qult.net>
 <201107141518.03757.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201107141518.03757.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 14, 2011 at 03:18:03PM +0200, thus spake Christian Lamparter:
> On Thursday, July 14, 2011 02:28:03 PM Ignacy Gawedzki wrote:
> > Hi,
> > 
> > I'm still working on an extension of the carl9170 firmware to enable TX
> > service time measurements.  This implies the addition of a u32 field to
> > carl9170_tx_superdesc to record the TSF value at the time the frame is
> > received by the firmware.
> > 
> > The problem with WoWLAN, more specifically with changes introduced by
> > af915846d44d23adc02c7ded807282d607b46faa, is that adding that field makes
> > carl9170_sram_reserved::cmd larger than CARL9170_MAX_CMD_LEN.
> > 
> > I still don't see an easy way out other than disabling WoWLAN altogether.
> > If anyone has any suggestion, I'd be happy to read it.
> Well, I think there's enough space in the rsp [fw->driver] buffer.

Okay, so I moved null to the rsp union and adapted wlan.c accordingly.  It
compiles just fine indeed.

> After all in WoWLAN mode, this buffer will be unused as well?

It sounds like it makes sense.  For the moment, I can only say that it works
for normal use.  I would still have to check WoWLAN, though.

Thanks for your help.

Ignacy

-- 
The groove will take you through times without money
much better than money will take you through times without groove.
