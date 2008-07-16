Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outbound-mail-102.bluehost.com ([69.89.22.12]:45492 "HELO
	outbound-mail-102.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753885AbYGPSsv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2008 14:48:51 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH 5/5] Ath5k: suspend/resume fixes
Date: Wed, 16 Jul 2008 11:41:59 -0700
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
References: <1216136661-10930-1-git-send-email-jirislaby@gmail.com> <200807160931.11473.jbarnes@virtuousgeek.org> <1216229703.29744.23.camel@dv>
In-Reply-To: <1216229703.29744.23.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807161141.59385.jbarnes@virtuousgeek.org> (sfid-20080716_204859_187558_014AC909)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, July 16, 2008 10:35 am Pavel Roskin wrote:
> On Wed, 2008-07-16 at 09:31 -0700, Jesse Barnes wrote:
> > On Wednesday, July 16, 2008 9:15 am Nick Kossifidis wrote:
> > > It's ok for now, but have in mind that on my upcoming patch series i'm
> > > disabling msi (commented out) since it results no interrupts on pci-e
> > > cards (seems there is a bug in kernel's msi implementation).
> >
> > Hm, would be good to get details here.  MSI is being used by other
> > drivers successfully...
>
> That's true, but no driver uses the same interrupt handler with and
> without MSI.  Either it's different handlers or the handler checks if
> MSI is enabled and does something differently.

Yeah, using MSI on your device can mean that you have to make some changes 
(like on Intel graphics you have to disable regular interrupts or bad things 
happen), but you can still share the handler or at least most of it in some 
cases.

> Checks is any interrupts are pending are different for MSI.  It may be
> not hard to do (it's probably easier than for real interrupts), but it
> has to be figured out.  Somebody has to do it right.  Until MSI is
> supported by the interrupt handler, it should not be enabled by the
> driver, or we get a non-functioning driver for AR5006.

Sure, that's fine.  I just wanted to make sure that there weren't some weird 
generic MSI problems.

Thanks,
Jesse
