Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58842
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755479AbXKTHmD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 02:42:03 -0500
Date: Mon, 19 Nov 2007 23:42:01 -0800 (PST)
Message-Id: <20071119.234201.19874188.davem@davemloft.net> (sfid-20071120_074209_978638_C785A8FC)
To: jt@hpl.hp.com
Cc: johannes@sipsolutions.net, shaddy_baddah@hotmail.com,
	linux-wireless@vger.kernel.org, dsd@gentoo.org
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071119223554.GA21844@bougret.hpl.hp.com>
References: <1195484582.8642.18.camel@johannes.berg>
	<20071119.142046.188284555.davem@davemloft.net>
	<20071119223554.GA21844@bougret.hpl.hp.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jean Tourrilhes <jt@hpl.hp.com>
Date: Mon, 19 Nov 2007 14:35:54 -0800

> I don't have a 64 bit box.

Let me know when you have joined us in the 21st century.

> Bug reports are *very* difficult to get because

I guess writing a dummy wireless driver with just some printk()'s and
some test userland programs to make sure the data goes to and
from the handlers with the proper layout is thinking way too far
outside the box for you.

Since you're not interested proactively doing things and everyone else
is also pushing the problem away from themselves I'll fix all of this.

Nothing using iw_point in these request objects can possibly work in
compat situations, for example.  I think it works by accident on
little-endian.
