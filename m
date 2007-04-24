Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4831 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423049AbXDXTWE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2007 15:22:04 -0400
Date: Tue, 24 Apr 2007 14:59:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Andy Green <andy@warmcat.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 03/13] mac80211: fix virtual interface related locking
Message-ID: <20070424185957.GD22681@tuxdriver.com>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net> <200704231722.07280.flamingice@sourmilk.net> <462E47D0.8030800@warmcat.com> <200704241425.01152.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200704241425.01152.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 24, 2007 at 02:24:56PM -0400, Michael Wu wrote:
> On Tuesday 24 April 2007 14:09, Andy Green wrote:
> > =============================================
> > [ INFO: possible recursive locking detected ]
> > 2.6.21-rc7 #11
> > ---------------------------------------------
> > ip/2600 is trying to acquire lock:
> >   (&dev->_xmit_lock){-+..}, at: [<e09199c5>]
> > ieee80211_set_multicast_list+0x46/0x167 [mac80211]
> >
> > but task is already holding lock:
> >   (&dev->_xmit_lock){-+..}, at: [<c05abc05>] dev_mc_upload+0x14/0x3c
> >
> This is fine, though it would be nice if we can shut the warning off. Virtual 
> interfaces can try to take the xmit lock of the master device, but the master 
> device will never try to take the xmit lock of the virtual interfaces and 
> especially not while holding its own xmit lock.

Hmmm...there is probably some lockdep annotation foo to take care of
this, but I don't know it.

Anyone?

John
-- 
John W. Linville
linville@tuxdriver.com
