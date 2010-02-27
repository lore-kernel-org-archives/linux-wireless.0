Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38007 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968470Ab0B0PEv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 10:04:51 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal DMA  errors
Date: Sat, 27 Feb 2010 16:04:37 +0100
Cc: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain> <69e28c911002261408j4f5fa5cdo6a69a43749d99f3f@mail.gmail.com> <alpine.LFD.2.00.1002261430430.4513@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002261430430.4513@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201002271604.37585.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 26 February 2010 23:46:57 Linus Torvalds wrote:
> Well, I'd love to give you a register dump. It _looks_ like it should be 
> possible write some script to dump all the registers by accessing
> 
> 	/sys/kernel/debug/b43/phy0/[mmio,shm][16,32]read

It is easily possible using libb43.py
http://bu3sch.de/gitweb?p=b43-tools.git;a=blob;f=debug/libb43.py;h=e5c563823a5f67aea30587a22e0eabab063358fb;hb=HEAD
See class B43.

However, dumping registers in b43 is not as easy as it looks like.
There is a _lot_ of indirect addressing and it has the tendency to
lock up on certain machines and cards, if you access dangling registers.

-- 
Greetings, Michael.
