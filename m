Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49066 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230Ab0GBOPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 10:15:11 -0400
Date: Fri, 2 Jul 2010 10:12:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Question on 'iw reg get/set'
Message-ID: <20100702141216.GB2381@tuxdriver.com>
References: <4C2CFAEB.9070302@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C2CFAEB.9070302@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 01, 2010 at 01:30:35PM -0700, Ben Greear wrote:
> I'm using an ath9k NIC on a slightly hacked 2.6.34 kernel, Fedora 13 32-bit.
> I'm using the stock 'iw' command that comes with Fedora 13.
> 
> As far as I can tell, the results of 'iw reg get'
> are funky:
> 
> [root@atom lanforge]# iw reg get
> country 98:
> 	(2402 - 2472 @ 40), (N/A, 20)
> 	(5170 - 5250 @ 20), (N/A, 17)
> 	(5250 - 5330 @ 20), (N/A, 18), DFS
> 
> What is '98'?  It doesn't correspond to anything I can find
> in the numeric or ascii lists of country codes.
> 
> Also, setting the domain doesn't seem to do anything, although
> there are no errors:
> 
> [root@atom lanforge]# iw reg get
> country 98:
> 	(2402 - 2472 @ 40), (N/A, 20)
> 	(5170 - 5250 @ 20), (N/A, 17)
> 	(5250 - 5330 @ 20), (N/A, 18), DFS
> [root@atom lanforge]# iw reg set US
> [root@atom lanforge]# iw reg get
> country 98:
> 	(2402 - 2472 @ 40), (N/A, 20)
> 	(5170 - 5250 @ 20), (N/A, 17)
> 	(5250 - 5330 @ 20), (N/A, 18), DFS
> 
> Anyone know if this is *supposed* to work?

The ath9k driver is setting its own regulatory restrictions based on
its EEPROM.  Setting the domain from userland can only further restrict
the regulatory settings.  The '98' value represents a synthesized
regulatory domain, based on the intersection of the available source
of regulatory information (which can include the EEPROM, the userland
setting, and a country IE from your AP).

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
