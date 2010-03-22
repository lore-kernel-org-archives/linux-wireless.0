Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:56735 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460Ab0CVVzJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 17:55:09 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V2] ssb: Implement virtual SPROM on disk
Date: Mon, 22 Mar 2010 22:55:00 +0100
Cc: Calvin Walton <calvin.walton@gmail.com>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <4ba6aa45.z5Wso1NMth9eMeFG%Larry.Finger@lwfinger.net> <201003220937.55133.mb@bu3sch.de> <4BA7877A.5090703@lwfinger.net>
In-Reply-To: <4BA7877A.5090703@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201003222255.00366.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 22 March 2010 16:06:34 Larry Finger wrote:
> Avoiding the use of a new user-space program would be desirable, but I cannot
> think of any way that a udev rule could distinguish one card from another. If we
> had any unique features such as a serial number, then we wouldn't need user
> space at all. Any suggestions?

I don't see a problem for udev to distinguish the cards. It can do it merely on
the bus-ID. That's unique. Yeah, it might change if you change the hardware.
But do we care? I say no, because you cannot actually change the hardware in real life
for any of these devices. And even if you could reorder the devices on the bus or whatever.
What would happen? The card would get a new MAC address. That's all. That's acceptable.

The kernel would (for example) just set the mac address to all-ones. Udev would
notice this (invalid) mac address and reassign a new persistent one to the device. It then
stores the address on the harddisk.

In fact, if we implement a mechanism in the kernel, we have _exactly_ the same problem.
However, currently Larry's patches just ignore that problem and assume that there's only
one card in the system anyway.

-- 
Greetings, Michael.
