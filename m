Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:52570 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbYIRPNg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 11:13:36 -0400
Subject: Re: [PATCH] iw: add kernel version checks for pending upstream
	kernel features
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1221748533-11000-1-git-send-email-linville@tuxdriver.com>
References: <>  <1221748533-11000-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 18 Sep 2008 11:13:33 -0400
Message-Id: <1221750813.5565.12.camel@dv> (sfid-20080918_171340_043885_B2DCC427)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-09-18 at 10:35 -0400, John W. Linville wrote:
> Add checks for kernel version to enable features in the iw tool.  This
> allows packagers to get pre-package the tool without requiring precise
> timing to stage the tool into their distributions.

I'm afraid it's not a good approach.  Suppose a distro takes this
version of iw and Linux 2.6.27.  Later it issues an update for the
kernel that updates it to 2.6.28.  Userspace tools don't normally depend
on the specific version of the kernel, and that's a good thing.  But in
this case, it means that iw won't be recompiled and updated unless the
distro has some mechanism in place to detect such need.  Since the
kernel version detection is done on the compiler level, I suspect such
need won't be detected.

The end result is that iw won't be able to access all functionality of
the kernel.

I believe userspace tools should always do the best effort to support
all functionality they can support, but fail gracefully if any kernel
functionality is not available.

Keeping a local version of nl80211.h in iw sources seems the most
sensible solution to me.  It has its downsides, but the upside is that
there is a clear separation between the userspace and the kernel code.

I know something about Fedora packaging and I assisted developers of
other userspace tools with similar issues.  Of course, opinions of the
actual package maintainers would have more weight.

-- 
Regards,
Pavel Roskin
