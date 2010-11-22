Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41522 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab0KVUOP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 15:14:15 -0500
Date: Mon, 22 Nov 2010 18:13:31 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: pull request: bluetooth-2.6 2010-11-22
Message-ID: <20101122201330.GE23109@vigoh>
References: <20101122181411.GD23109@vigoh>
 <20101122193029.GE2117@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101122193029.GE2117@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* John W. Linville <linville@tuxdriver.com> [2010-11-22 14:30:30 -0500]:

> On Mon, Nov 22, 2010 at 04:14:11PM -0200, Gustavo F. Padovan wrote:
> > Hi John,
> > 
> > Following batch is intended to 2.6.37, it includes a very trivial return
> > err fix from myself and an remote name request fix from Johan Hedberg.
> > This fix move the remote name request (during the connection creation
> > process) to the kernelspace. In addition we have removed this operation
> > from BlueZ in userspace. Quoting part of Johan's patch which already
> > explain the change:
> > 
> >    "So far userspace has been responsible for this extra name request but
> >     tighter control is needed in order not to flood Bluetooth controllers
> >     with two many commands during connection creation. It has been shown
> >     that some controllers simply fail to function correctly if they get too
> >     many (almost) simultaneous commands during connection creation. The
> >     simplest way to acheive better control of these commands is to move
> >     their sending completely to the kernel side."
> > 
> > As side effect, we have a clean up patch in preparation to this fix.
> > 
> > Please pull, or let me know any problems you find here. Thanks.
> 
> The return code fix seems reasonable -- small and obvious, etc.
> 
> The other fixes are larger than I would like to see.  What is the
> effect of the bug?  Does the Bluetooth controller stop completely?
> Does it cause a crash?
> 
> Is this a newly-introduced bug?  Or one that has been around for
> a while?

No, it is not serious like that. By not having this patch we won't have
the remote name request command during connection setup, The remote name
request was done by bluetoothd, but we already removed it from
userspace. It is not a really big problem once we also cache the remote
devices names in bluetoothd.
So I'm seeing no way to convince you tou pull this patch (actually I'm
now also covinced to queue this to bluetooth-next).  I'll sent a new
pull request soon, after wait some time for new patches.

-- 
Gustavo F. Padovan
http://profusion.mobi
