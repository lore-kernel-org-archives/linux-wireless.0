Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:45364 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757826Ab0LBOqJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 09:46:09 -0500
Received: from [172.21.40.213] (esdhcp040213.research.nokia.com [172.21.40.213])
	by mgw-da02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oB2Ek78W010504
	for <linux-wireless@vger.kernel.org>; Thu, 2 Dec 2010 16:46:07 +0200
Subject: Re: wl12xx tree has been rebased in 02.12
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1291300798.16140.6.camel@chilepepper>
References: <1291300798.16140.6.camel@chilepepper>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 16:47:03 +0200
Message-ID: <1291301223.16140.9.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-02 at 16:39 +0200, ext Luciano Coelho wrote:
> Hi,
> 
> I have rebased the wl12xx tree so that it is better aligned with the
> latest wireless-testing and wireless-next trees.
> 
> Please rebase or reset your local trees.

And, BTW, this now includes a change on the MMC subsystem that requires
the cards that can be powered off (which is the case of wl1271) to have
the MMC_CAP_POWER_OFF_CARD flag set in the capabilities.

So, check the omap2_hsmmc_info structure in your board file and, if the
flag is not there, add it to the .caps element otherwise your card will
fail to power on.

-- 
Cheers,
Luca.

