Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:8413 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab0CJCNR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 21:13:17 -0500
Subject: RE: Athros wireless stopped working
From: Pavel Roskin <proski@gnu.org>
To: Jimham@porcine.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1268102255.10290.24.camel@localhost>
References: <1268102255.10290.24.camel@localhost>
Content-Type: text/plain
Date: Tue, 09 Mar 2010 21:13:16 -0500
Message-Id: <1268187196.3410.14.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-03-08 at 18:37 -0800, Jim Ham wrote:

> What I have discovered is that if the ESSID is not active, iwconfig sets
> it correctly and it sticks. If the ESSID is one that is locally present,
> iwconfig seems to set it, but it almost immediately reverts to garbage.

Either you have a memory corruption bug in your kernel, or you have some
buggy userspace tool (it could be a misbehaving NetworkManager or wicd)
that changes ESSID on the interface as soon as the driver reports
association.  I haven't seen any similar reports.

> 	Kernel driver in use: ath5k

ath5k is not an example of code quality, but I don't remember any memory
corruption bugs in it fixed since 2.6.32.

I suggest following steps:

1) Check for updates for your distribution, install updates, recheck.

2) Boot to the single user mode, make sure that wpa_supplicant and wicd
are not running (kill them otherwise) and try setting up the connection
manually.

3) Install the latest compat-wireless, recheck.

-- 
Regards,
Pavel Roskin
