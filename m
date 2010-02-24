Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:58214 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261Ab0BXHQM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2010 02:16:12 -0500
Subject: Re: [PATCH] ath9k: never read from the AR_IMR_S2 register
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <43e72e891002231554o7b1b8bc5g865381c1b0a9e019@mail.gmail.com>
References: <20100223231527.8028.84024.stgit@mj.roinet.com>
	 <43e72e891002231554o7b1b8bc5g865381c1b0a9e019@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 24 Feb 2010 02:15:58 -0500
Message-Id: <1266995758.12741.39.camel@ct>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-02-23 at 15:54 -0800, Luis R. Rodriguez wrote:
> On Tue, Feb 23, 2010 at 3:15 PM, Pavel Roskin <proski@gnu.org> wrote:
> > The AR_IMR_S2 register sometimes cannot be read correctly.  Instead of a
> > valid value, 0xdeadbeef is returned.  The driver has been observed
> > writing that value back to AR_IMR_S2 after changing a few bits.
> >
> > Cache the register value in ah->imrs2_reg and always write chached value
> > to the register.
> >
> > Signed-off-by: Pavel Roskin <proski@gnu.org>
> 
> What hardware was this seen with ? Can you enable PS debug to see if
> perhaps PS is left enabled when we try to configure hardware. When we
> touch some registers PS needs to be enabled, this could be a PS issue,
> unless of course you see this also when PS is disabled by default.

I saw reading 0xdeadbeef from AR_IMR_S2 on AR5416 (CardBus D-Link
DWA-645) and on AR9220 (miniPCI Ubiquiti SR71-12).  I can confirm it on
AR9285 (ExpressCard) now.

Power saving is disabled by default (and never enabled) on all systems
where I checked for reading 0xdeadbeef.

There are other cases where 0xdeadbeef is read from other registers.
For instance, the "wiphy" file on debugfs is full of that stuff when the
interface is in managed mode and not associated.

cat /sys/kernel/debug/ath9k/phy3/wiphy 
primary: phy3 (ACTIVE chan=0 ht=0)
addr: ef:be:ad:de:ef:be
addrmask: ef:be:ad:de:ef:be

However, the problem with AR_IMR_S2 is that a derivative of 0xdeadbeef
is written back to the register (0xdeadbc00 is written in my tests).  I
don't know of any observable negative consequences of that fact, but I
think it's better not to set bits we don't know about.

-- 
Regards,
Pavel Roskin
