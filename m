Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:54722 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762603AbXGTMMJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 08:12:09 -0400
Subject: Re: bcm4301: A mac80211 driver using V3 firmware
From: David Woodhouse <dwmw2@infradead.org>
To: Pavel Roskin <proski@gnu.org>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
In-Reply-To: <1184906596.9511.42.camel@dv>
References: <46963C0F.3080104@lwfinger.net>
	 <20070719215801.GB12449@tuxdriver.com> <20070720012714.0dc0298a@morte>
	 <46A01209.4030200@lwfinger.net>  <1184906596.9511.42.camel@dv>
Content-Type: text/plain
Date: Fri, 20 Jul 2007 13:12:04 +0100
Message-Id: <1184933524.14697.119.camel@pmac.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-07-20 at 00:43 -0400, Pavel Roskin wrote:
> 
> That's a very good goal.
> 
> I would also consider the option to use different names for v3 and v4
> firmware.  I have a file /etc/modprobe.d/bcm43xx that reads
> 
> options bcm43xx fwpostfix=.3
> options bcm43xx_mac80211 fwpostfix=.4
> 
> but we cannot expect every distro (let alone every user) to take care
> of the naming conflict.  Users don't expect the need to rename
> firmware, and we shouldn't create a problem for them.

Yes. Please use a suitable postfix for v3 and v4 firmware so that they
can coexist. You can always make each driver fall back to the old
filename if it doesn't find the firmware with the postfix.

We can make the fwcutter write out files with appropriate names too.

-- 
dwmw2

