Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39578 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbYIVGsf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 02:48:35 -0400
Date: Sun, 21 Sep 2008 23:48:31 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Steven Noonan <steven@uplinklabs.net>
CC: Howard Chu <hyc@symas.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k problems
Message-ID: <20080922064831.GB19580@tesla> (sfid-20080922_084851_296146_650B4F02)
References: <48D5CAD0.1080909@symas.com> <f488382f0809202122v4c77bc96r54edd24bdf365724@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <f488382f0809202122v4c77bc96r54edd24bdf365724@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 20, 2008 at 09:22:56PM -0700, Steven Noonan wrote:
> On Sat, Sep 20, 2008 at 9:17 PM, Howard Chu <hyc@symas.com> wrote:
> > With the 2.6.27-rc6 kernel I find that my wireless connection dies after a
> > few minutes. Using nm-applet I have to disable wireless and re-enable it
> > before I can re-establish a session (using WPA).
> 
> Yeah, you need this patch:
> http://marc.info/?l=linux-wireless&m=122163541519736&w=2
> 
> > I tried pulling the wireless-testing branch and found it behaved strangely
> > as well - within about 30 seconds of idle time it would die. But, it would
> > usually immediately begin to reconnect (and succeed). My logs were full of
> > "ForceXPAon: 0" messages which I found were from ath9_hw_reset(), which were
> > all being called from set_channel, during the scan that took place when the
> > card was not associated with the AP. It typically occurred every 30-35
> > seconds.
> 
> I'm sure the ath9k guys can be more informative about what
> 'ForceXPAon: 0' is all about,

Its set *all the time* for our newer chipsets and can be safely ignored.
Not sure what the register is exactly for but its always set on
our newer chipsets upon reset.

> but wireless-testing is pretty outdated

This is not accurate.

It lacks new patches from Linus' tree, but it has the latest
and greatest possible wireless patches. John maintains Linux
wireless so he'll always have more updated patches for wireless than
Linus.

  Luis
