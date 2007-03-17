Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:59101 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933104AbXCQEug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 00:50:36 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HSQqO-0007Bg-9A
	for linux-wireless@vger.kernel.org; Sat, 17 Mar 2007 00:48:40 -0400
Subject: Re: prism54pci fails to read eeprom on PowerPC, then bugs in pci  code
From: Pavel Roskin <proski@gnu.org>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Paul TBBle Hampson <Paul.Hampson@pobox.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200703170037.14875.flamingice@sourmilk.net>
References: <20070317034607.GA1522@keitarou>
	 <200703170037.14875.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Sat, 17 Mar 2007 00:50:32 -0400
Message-Id: <1174107032.17023.14.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-03-17 at 00:37 -0400, Michael Wu wrote:
> On Friday 16 March 2007 23:46, Paul TBBle Hampson wrote:
> > The (built-in) bcm43xx-mac80211 driver works, but when I try to load a
> > CardBus Atheros card I've got lying around with dadwifi-openhal, it
> > fails with some sort of hardware error.  (ie. it _might_ be a dodgey
> > Cardbus port, although both cardbus cards used to work in this machine,
> > using prism54 hardmac and the dadwifi with atheros hal driver
> > respectively)
> >
> Can you rule out the port first? Load the fullmac driver first, bring it up & 
> down, unload it, and then try p54.

Oh, and I'm amazed that somebody is using dadwifi-openhal verify the
hardware!  It's in a pretty poor shape right now.  It prints some
warnings because it starts with channel 0.  The interface can be brought
up if you set a valid channel, and I think it might scan.

And if you want to use madwifi-old-openhal for the purpose of testing,
please use today's revision, or it will corrupt memory due to incorrect
get_order() rounding that Linus has reverted in 2.6.21-rc4 (the fix is
not in wireless-dev.git yet).

-- 
Regards,
Pavel Roskin

