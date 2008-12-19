Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:57458 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbYLSPoM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 10:44:12 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: Fix some MAC locking
Date: Fri, 19 Dec 2008 16:40:07 +0100
Cc: linville@tuxdriver.com, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
References: <200812182213.39260.mb@bu3sch.de> <494BC02B.4000906@lwfinger.net>
In-Reply-To: <494BC02B.4000906@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812191640.07863.mb@bu3sch.de> (sfid-20081219_164415_966707_692826DC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 19 December 2008 16:39:23 Larry Finger wrote:
> Michael Buesch wrote:
> > This fixes some locking w.r.t. the lower MAC (firmware).
> > It also removes a lot of ancient IRQ-locking that's not needed anymore.
> > We simply suspend the MAC. That's easier and causes less trouble.
> 
> When booting with this patch and the RFKILL switch off, I got these b43dbg messages:
> 
> kernel: b43-phy0 debug: PHY/RADIO register access with enabled MAC.
> kernel: Pid: 7, comm: events/0 Not tainted 2.6.28-rc8-wl #55
> kernel: Call Trace:
> kernel:  [<ffffffffa02d6b15>] b43_phy_read+0x33/0x46 [b43]
> kernel:  [<ffffffffa02d8350>] b43_gphy_op_software_rfkill+0xde/0x131 [b43]
> kernel:  [<ffffffffa02d66d8>] b43_software_rfkill+0x20/0x2d [b43]

Thanks.
I guess suspending MAC before killing RF is a good thing anyway. I'll do a patch.

-- 
Greetings, Michael.
