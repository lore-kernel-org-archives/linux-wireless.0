Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36687 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753411Ab0BZVuu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 16:50:50 -0500
Date: Fri, 26 Feb 2010 13:50:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: =?ISO-8859-15?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal
 DMA  errors
In-Reply-To: <alpine.LFD.2.00.1002261337460.4513@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1002261345300.4513@localhost.localdomain>
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain>  <4B881C70.9030004@lwfinger.net> <alpine.LFD.2.00.1002261112590.4513@localhost.localdomain>  <alpine.LFD.2.00.1002261205160.4513@localhost.localdomain> <69e28c911002261209m2b10ca27j5a62c91350e3597c@mail.gmail.com>
 <alpine.LFD.2.00.1002261246330.4513@localhost.localdomain> <4B8836BF.7000403@lwfinger.net> <alpine.LFD.2.00.1002261337460.4513@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 26 Feb 2010, Linus Torvalds wrote:
> 
> so even if mmiotrace fixes it for others, it's not working for me.

Side note: In case this is timing-related: the machine in question is a 
dual-core 1.3Ghz CPU (Core 2 Duo U1400). I think SMP has always been 
enabled, I don't think I ever tried UP.

Also, in addition to the PIO fallback code, that particular mmiotrace test 
was done with the "udelay(10)" added to the b43_write*() functions. So it 
was even slower.

Maybe the bug only happens on slow machines (and then the udelay obviously 
wouldn't help!), but that would not explain why mmiotrace might then 
_hide_ the bug for some people.

			Linus
