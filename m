Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canuck.infradead.org ([209.217.80.40]:46639 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbXDPAyL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2007 20:54:11 -0400
Subject: Re: [PATCH] bcm43xx-mac80211: Fix machine checks on PPC with rev   1 PHYs
From: David Woodhouse <dwmw2@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <larry.finger@lwfinger.net>
In-Reply-To: <1176681998.7929.81.camel@pmac.infradead.org>
References: <461d0815.ip3FDr8RDQXyCT4U%Larry.Finger@lwfinger.net>
	 <20070413113638.10db9767@localhost>  <461F9C58.6050106@lwfinger.net>
	 <1176477466.7052.114.camel@johannes.berg>
	 <1176681998.7929.81.camel@pmac.infradead.org>
Content-Type: text/plain
Date: Mon, 16 Apr 2007 01:53:53 +0100
Message-Id: <1176684833.3304.9.camel@pmac.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-04-16 at 01:06 +0100, David Woodhouse wrote:
> On Fri, 2007-04-13 at 17:17 +0200, Johannes Berg wrote:
> > With phy rev == 1, the gmode bit is assumed unset when initialising a
> > G PHY. Maybe that is the crucial difference. David will send me some
> > backtraces of this problem, once he does I'll look at it again.
> 
> http://david.woodhou.se/bcm43xx-mac80211.dmesg-3.txt 
> 
> The module itself is at http://david.woodhou.se/bcm43xx-mac80211.ko so
> you can find line numbers where they're not immediately obvious.

That was without Larry's latest patch applied. If I apply Larry's patch,
we get fewer machine checks...

http://david.woodhou.se/bcm43xx-mac80211-lf.dmesg.txt 
http://david.woodhou.se/bcm43xx-mac80211-lf.ko

Strange, I thought that when I'd tested Larry's patch I was left with
_no_ machine checks. Perhaps at that point I still had a printk on every
PHY read or write and the machine checks were lost in the noise.

-- 
dwmw2

