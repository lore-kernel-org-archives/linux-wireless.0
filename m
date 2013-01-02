Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:55973 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3ABNul (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 08:50:41 -0500
Date: Wed, 2 Jan 2013 07:50:31 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com
Subject: Re: WARNING: at drivers/net/wireless/brcm80211/brcmsmac/main.c:7539
Message-ID: <20130102135031.GA11439@thinkpad-t410> (sfid-20130102_145045_076356_9EFFBF9C)
References: <CA+55aFwpdyrtvE=86e1aHE9L5TR+_xP7e4PBBKtdcey3=f+Suw@mail.gmail.com>
 <50E4229D.5000900@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50E4229D.5000900@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 02, 2013 at 01:05:49PM +0100, Arend van Spriel wrote:
> On 12/28/2012 07:07 AM, Linus Torvalds wrote:
> > Ok, maybe somebody is interested in this.. I don't know what triggered
> > it, but maybe the few lines around it give some clue.
> 
> Hi Linus,
> 
> I am interested (being paid for it kinda helps). The warning itself does
> not necessarily have to be a problem, but the frameid mismatch between
> tx status info and the related buffer taken from the DMA ring does.
> Smells like a race condition, but I need to investigate that.
> 
> > I think it's new to 3.8-rc1, because I haven't seen it before (well,
> > I'm running current -git - v3.8.0-rc1-00035-g101e5c7470eb to be exact
> > - but the networking changes since -rc1 are small and seem unrelated).
> > But maybe it just happens under certain circumstances.
> 
> We had a big contribution from Canonical (cc-ed Seth) in brcmsmac
> itself. Not playing the blame game, but I suspect it has altered
> circumstances making the real issue (that was already there) more likely
> to happen. Hope that helps us nailing it down.

I'm certain that both problems existed prior to 3.8-rc1. The warning
itself has generated a fairly consistent trickle of bug reports for a
while now. I haven't noticed any increased frequency of these messages;
if anything I'd say I'm hitting the WARN_ON less often (though I've been
doing a lot of testing under heavy load so my observations may not be
typical).

The channel mismatch errors are something I plan to look into, but I've
been distracted by some background scanning problems (not specific to
brcmsmac).

Seth
