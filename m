Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38463 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905AbYJINb1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 09:31:27 -0400
Date: Thu, 9 Oct 2008 07:31:26 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andrey Borzenkov <arvidjaar@newmail.ru>
Cc: orinoco-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, linux-pcmcia@lists.infradead.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: rc9 + orinoco WPA patchset: BUG: scheduling while atomic loading firmware with PCMCIA adapter
Message-ID: <20081009133125.GW25780@parisc-linux.org> (sfid-20081009_153131_534730_71DF3DDE)
References: <200810091722.56812.arvidjaar@newmail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200810091722.56812.arvidjaar@newmail.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 09, 2008 at 05:22:55PM +0400, Andrey Borzenkov wrote:
> After loading orinoco and "inserting" adapter I get either BUG with
> endless loop (attached) or kernel panic on NULL pointer dereference
> (was not able capture). Adapter works fine with wlags49 driver.

It looks like you've fallen off the bottom of the kernel stack.  Do you
have 4k stacks enabled in your config?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
