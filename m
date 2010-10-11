Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60007 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab0JKSmp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 14:42:45 -0400
Subject: Re: [PATCH] wireless:  Print wiphy name in sysfs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4CB355EA.5050902@candelatech.com>
References: <1286818139-1746-1-git-send-email-greearb@candelatech.com>
	 <1286819927.3634.79.camel@jlt3.sipsolutions.net>
	 <4CB351B2.4070803@candelatech.com>
	 <1286820600.3634.80.camel@jlt3.sipsolutions.net>
	 <4CB355EA.5050902@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 20:42:45 +0200
Message-ID: <1286822565.3634.83.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-11 at 11:22 -0700, Ben Greear wrote:

> > basename $(readlink /sys/class/net/wlan0/phy80211)
> 
> It looks like that could work, but it seems a lot easier to probe
> network devices via normal manner, and then check if I can just
> open and read /sys/class/net/[dev-name]/phy80211/name
> 
> I can do that easily from within a C/C++ program, where as
> doing system calls and grabbing standard output is more of
> a pain (and more overhead).
> 
> But, if you don't want to add my patch, it's not a big deal.

I don't really mind, it just didn't seem necessary. FWIW, readlink(2) is
also a system call that your C program could use, but if you want the
patch instead I guess that's fine.

johannes

