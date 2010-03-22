Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:60350 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab0CVW2m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 18:28:42 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH V2] ssb: Implement virtual SPROM on disk
Date: Mon, 22 Mar 2010 23:28:40 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Calvin Walton <calvin.walton@gmail.com>,
	linux-wireless@vger.kernel.org
References: <4ba6aa45.z5Wso1NMth9eMeFG%Larry.Finger@lwfinger.net> <201003222255.00366.mb@bu3sch.de> <4BA7ED0A.9060804@lwfinger.net>
In-Reply-To: <4BA7ED0A.9060804@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003222328.40703.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 22 March 2010 23:19:54 Larry Finger wrote:
> On 03/22/2010 04:55 PM, Michael Buesch wrote:
> > 
> > I don't see a problem for udev to distinguish the cards. It can do it merely on
> > the bus-ID. That's unique. Yeah, it might change if you change the hardware.
> > But do we care? I say no, because you cannot actually change the hardware in real life
> > for any of these devices. And even if you could reorder the devices on the bus or whatever.
> > What would happen? The card would get a new MAC address. That's all. That's acceptable.
> > 
> > The kernel would (for example) just set the mac address to all-ones. Udev would
> > notice this (invalid) mac address and reassign a new persistent one to the device. It then
> > stores the address on the harddisk.
> 
> What ensures that this persistent name would be unique?

The same mechanism that ensures that an UUID is unique: A good random number generator.

> > In fact, if we implement a mechanism in the kernel, we have _exactly_ the same problem.
> > However, currently Larry's patches just ignore that problem and assume that there's only
> > one card in the system anyway.
> 
> As I said in a posting a few minutes ago, that problem is solved.

Well. You distinguish by bus-ID, right? That's exactly the thing that udev does.

-- 
Greetings, Michael.
