Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:38861 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757486Ab0GWW4G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 18:56:06 -0400
Subject: Re: [PATCH] zd1211rw: make CR_INTERRUPT cast explicit
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
In-Reply-To: <20100722190339.GD2616@tuxdriver.com>
References: <1279724935-16581-1-git-send-email-linville@tuxdriver.com>
	 <1279730218.9003.7.camel@mj>  <20100722190339.GD2616@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Jul 2010 18:55:36 -0400
Message-ID: <1279925736.23722.5.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-07-22 at 15:03 -0400, John W. Linville wrote:
> On Wed, Jul 21, 2010 at 12:36:58PM -0400, Pavel Roskin wrote:
> > I think __force should be used sparingly, especially outside headers.  I
> > tried other ways to prevent the warning.  I tried declaring int_num as
> > zd_addr_t, but sparse keeps complaining about the same comparison.
> 
> Actually, it looks like it works w/o the "__force" as well.
> Any objection to a version like that?

Ideally, I would avoid any workarounds for sparse.  The bug was
acknowledged by a sparse developer, so I expect it to be fixed.
http://www.spinics.net/lists/linux-sparse/msg02167.html

However, a version without __force would be more acceptable than a
version with __force.

-- 
Regards,
Pavel Roskin
