Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:56640 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933295Ab0BPV2p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 16:28:45 -0500
Subject: Re: [PATCH] mwl8k: disable softirqs when accessing sta_notify_list
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Lennert Buytenhek <buytenh@marvell.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <43e72e891002161203w4498ae09wc7d14d12dd75be09@mail.gmail.com>
References: <1266117186.13902.21.camel@mj>
	 <43e72e891002161203w4498ae09wc7d14d12dd75be09@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 16 Feb 2010 16:28:32 -0500
Message-Id: <1266355712.2659.16.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-02-16 at 12:03 -0800, Luis R. Rodriguez wrote:
> On Sat, Feb 13, 2010 at 7:13 PM, Pavel Roskin <proski@gnu.org> wrote:
> > Use spin_[un]lock_bh in mwl8k_sta_notify().  The sta_notify handler is
> > required to be atomic, yet it can be called in process context, so make
> > sure one call won't preempt another.
> 
> Is this for stable as well?

Since it wasn't tested on real hardware, I would say no, unless Lennert
says otherwise.

-- 
Regards,
Pavel Roskin
