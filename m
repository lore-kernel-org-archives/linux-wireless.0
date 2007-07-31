Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:46646
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930AbXGaVbH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 17:31:07 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] zd1211rw-mac80211: debug output for mac80211 ops
Date: Tue, 31 Jul 2007 23:30:48 +0200
Cc: Andy Green <andy@warmcat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <20070730023128.99E927B409F@zog.reactivated.net> <46AE7361.90406@warmcat.com> <20070731231249.121d55d4@logostar.upir.cz>
In-Reply-To: <20070731231249.121d55d4@logostar.upir.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707312330.48698.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 31 July 2007 23:12:49 Jiri Benc wrote:
> On Tue, 31 Jul 2007 00:25:21 +0100, Andy Green wrote:
> > The "soft" one is a faked up repeating of incoming (and outgoing!
> > twice!) packets
> 
> You mean you see each outgoing packet twice on soft monitor interface? That
> would be a bug.
> 
> > It really would be much better if the device
> > is kicked to hardware promisc if ANY virtual interface is in Monitor
> > mode, therefore the results are consistent regardless of the number of
> > virtual interfaces that happen to be around.
> 
> Of course. If the hardware supports that.

The device should _not_ be kicked to promisc, if we have a monitor
interface. The promisc bit is a completely seperate setting
and must be handled seperate from the monitor stuff.
Userspace does take care of setting the promisc bit, if it's
required.
We recently fixed this bug in bcm43xx.

-- 
Greetings Michael.
