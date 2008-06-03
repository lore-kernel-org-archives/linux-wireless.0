Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47592
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752314AbYFCVQx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 17:16:53 -0400
Date: Tue, 03 Jun 2008 14:16:52 -0700 (PDT)
Message-Id: <20080603.141652.245225529.davem@davemloft.net> (sfid-20080603_231657_152244_5290E3A5)
To: linville@tuxdriver.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-06-03
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080603190943.GB28966@tuxdriver.com>
References: <20080603190943.GB28966@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Tue, 3 Jun 2008 15:09:43 -0400

> Kirill A. Shutemov (1):
>       wireless.h: improve userland include-ability

I'm not pulling this into my tree.  I've already replied
to that patch posting saying why I don't like this.

Even if I found this change as the only way to go and therefore
had to take it in, the commit log is way too terse about what
the problem is.  And it must describe the horrifics that are
now necessary to include this file in userspace after the change.

It needs to describe in detail what the conflicting types and
definitions in the kernel headers are that cause problems with
userspace, and the exact sequence of includes userland has to make in
order to get this right.

And I require such enormously scary details in order to make it clear
how bogus this change is.

There is zero point in us sanitizing kernel headers for userspace
usage if this kind of crap is still necessary.  I mean tell me, why
should we even bother in that case?  And this is why I'm not taking in
this changeset.
