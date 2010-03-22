Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:64655 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab0CVWUA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 18:20:00 -0400
Received: by ewy8 with SMTP id 8so79050ewy.28
        for <linux-wireless@vger.kernel.org>; Mon, 22 Mar 2010 15:19:58 -0700 (PDT)
Message-ID: <4BA7ED0A.9060804@lwfinger.net>
Date: Mon, 22 Mar 2010 17:19:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Calvin Walton <calvin.walton@gmail.com>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] ssb: Implement virtual SPROM on disk
References: <4ba6aa45.z5Wso1NMth9eMeFG%Larry.Finger@lwfinger.net> <201003220937.55133.mb@bu3sch.de> <4BA7877A.5090703@lwfinger.net> <201003222255.00366.mb@bu3sch.de>
In-Reply-To: <201003222255.00366.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/22/2010 04:55 PM, Michael Buesch wrote:
> 
> I don't see a problem for udev to distinguish the cards. It can do it merely on
> the bus-ID. That's unique. Yeah, it might change if you change the hardware.
> But do we care? I say no, because you cannot actually change the hardware in real life
> for any of these devices. And even if you could reorder the devices on the bus or whatever.
> What would happen? The card would get a new MAC address. That's all. That's acceptable.
> 
> The kernel would (for example) just set the mac address to all-ones. Udev would
> notice this (invalid) mac address and reassign a new persistent one to the device. It then
> stores the address on the harddisk.

What ensures that this persistent name would be unique?

> In fact, if we implement a mechanism in the kernel, we have _exactly_ the same problem.
> However, currently Larry's patches just ignore that problem and assume that there's only
> one card in the system anyway.

As I said in a posting a few minutes ago, that problem is solved.

Larry
