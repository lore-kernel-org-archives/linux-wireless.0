Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49917 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbZKCSPF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 13:15:05 -0500
Date: Tue, 3 Nov 2009 13:00:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: CSights <csights@fastmail.fm>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath5k and ".local" dropout
Message-ID: <20091103180055.GC4839@tuxdriver.com>
References: <200911021907.16271.csights@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200911021907.16271.csights@fastmail.fm>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 02, 2009 at 07:07:16PM -0500, CSights wrote:
> Hello,
> 	I'm having a problem with the ath5k module found in kernel 2.6.31.5 and 
> accessing ".local" addresses on the network.
> 	What I've observed so far is that when I first boot the computer I can 
> successfully access (e.g. ping) other .local computers.  If the computer with 
> the ath5k card sits for a few minutes I can no longer access .local 
> computers.  (Trying to ping, ping returns "ping: unknown host")  Also, other 
> computers on the network can no longer ping the ath5k computer (also "ping: 
> unknown host")
> 	Pinging the .local computers by their IP address (e.g. 192.168.1.3) does 
> work.
> 	Access to computers "on the internet" (e.g. www.case.edu) also works.

Curious...if you ping a .local address before the failure, it is
still accessible after other .local addresses become unavailable?
I'm wondering if mdns results might be cached...

The .local address relationship suggests multicast DNS, which suggests
that ath5k might have a problem where it stops receiving multicast
frames.  Does this "ring any bells" for anyone?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
