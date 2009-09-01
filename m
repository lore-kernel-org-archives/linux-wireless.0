Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:53692 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbZIASnM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 14:43:12 -0400
Subject: Re: wireless_send_event kmemleaks
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890909011024p7b7176a6vfad3902ac714df79@mail.gmail.com>
References: <43e72e890909011024p7b7176a6vfad3902ac714df79@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 01 Sep 2009 14:43:05 -0400
Message-Id: <1251830585.14862.2.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-09-01 at 10:24 -0700, Luis R. Rodriguez wrote:
> Can't tell you how to reproduce yet.
> 
> unreferenced object 0xffff88003ba5fd00 (size 256):
>   comm "events/0", pid 9, jiffies 4297130623
>   backtrace:
>     [<ffffffff8112200d>] create_object+0x13d/0x2d0
>     [<ffffffff811222c5>] kmemleak_alloc+0x25/0x60
>     [<ffffffff81118a63>] kmem_cache_alloc_node+0x193/0x200
>     [<ffffffff81446cca>] __alloc_skb+0x4a/0x180
>     [<ffffffff81506be2>] wireless_send_event+0x1f2/0x410

I wonder if we can translate it to the line numbers.  Together with the
git revision, it would be quite useful.  addr2line can do it for an
individual address, but to process the whole dump, a script would be
needed.

-- 
Regards,
Pavel Roskin
