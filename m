Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36389 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab0HHIBs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Aug 2010 04:01:48 -0400
Subject: Re: [PATCH 2/4] compat: move va_format to compat-2.6.36.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
In-Reply-To: <4C5D95C6.4060301@hauke-m.de>
References: <1281187941-7168-1-git-send-email-hauke@hauke-m.de>
	 <1281187941-7168-3-git-send-email-hauke@hauke-m.de>
	 <1281196236.4431.7.camel@jlt3.sipsolutions.net>
	 <4C5D95C6.4060301@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 Aug 2010 10:01:43 +0200
Message-ID: <1281254503.3697.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-08-07 at 19:20 +0200, Hauke Mehrtens wrote:
> Am 07.08.2010 17:50, schrieb Johannes Berg:
> > On Sat, 2010-08-07 at 15:32 +0200, Hauke Mehrtens wrote:
> >> This struct was introduced in kernel 2.6.36 and not 2.6.35.
> > 
> > I'm confused now:
> > 
> > $ git describe 7db6f5fb
> > v2.6.35-rc1-928-g7db6f5f
> > 
> > johannes
> > 
> Hi,
> 
> I am also confused. ;-) I get the same result for git describe 7db6f5fb
> as you.
> 
> But include/linux/kernel.h does not contain struct va_format in kernel
> 2.6.35 it was added sometime later.
> 
> Without adding struct va_format to compat-2.6.36.h I get build error
> with kernel 2.6.35.

Ok ... Hmm. I guess this patch got in multiple times or something, since
I can see it in wireless-testing that's based on .35 as well, which was
the reason we moved this to compat-2.6.35 because otherwise it failed
compilation there!

I'm starting to think that we should detect at compile time what
features are present, say by test-compiling a file that contains a use
of the struct.

johannes

