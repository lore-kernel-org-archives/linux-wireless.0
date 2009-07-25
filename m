Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:37700 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbZGYVwh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 17:52:37 -0400
Subject: Re: [BUG] Current head of wireless testing unusable
From: Pavel Roskin <proski@gnu.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1248531054.15242.16.camel@maxim-laptop>
References: <1248531054.15242.16.camel@maxim-laptop>
Content-Type: text/plain
Date: Sat, 25 Jul 2009 17:52:35 -0400
Message-Id: <1248558755.11389.21.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-07-25 at 17:10 +0300, Maxim Levitsky wrote:
> I probably should work more to did these bugs out myself, but anyway I
> want to let you know what I currently see.
> 
> First system oopses just after NM starts up, happens always, and after
> planting few test points bug happens somewhere in following lines. 

We are discussing a bug in the scan state machine in another thread,
which could have nasty consequences in not caught.  And I don't quite
understand why my system was catching it immediately, maybe because I'm
using gcc 4.4, which has array bounds checking.

I have also seen two oopses in the code unrelated to wireless
networking, one of which lead to my .bash_history becoming empty.

So please be extra careful.  It would be great if somebody could test
the current kernel extensively with kmemcheck an other options and
bisect the bad commit, whether it's wireless related or not.

-- 
Regards,
Pavel Roskin
