Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:62298 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497Ab1I1VTT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 17:19:19 -0400
Date: Wed, 28 Sep 2011 17:19:09 -0400
From: Pavel Roskin <proski@gnu.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] wireless: at76c50x: fix multithread access to hex2str
Message-ID: <20110928171909.6889916c@mj> (sfid-20110928_231922_973092_C8F7E55D)
In-Reply-To: <21514bff06a915d2edd0a83c74ac512eb8b80b3f.1317215809.git.andriy.shevchenko@linux.intel.com>
References: <21514bff06a915d2edd0a83c74ac512eb8b80b3f.1317215809.git.andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 28 Sep 2011 16:17:31 +0300
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> The original hex2str uses finite array of buffers to keep output
> data. It's a wrong approach, because we can't say at compile time how
> many threads will be used.
> 
> This patch introduces one buffer and global mutex to access this
> function. All calls of it are wrapped by locking this mutex. It saves
> some memory as a side effect.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: "John W. Linville" <linville@tuxdriver.com>

The reason for having 4 buffers is to allow using hex2str() more than
once in the same printk() statement.  As you can see, hex2str() is
never used in one statement more than once.  Your solution would make
it impossible to use hex2str() twice in the same printk(), as the
buffer would be reused.  Actually, wrong data would be printed with no
warning!  Such code doesn't exist in the driver, but it could be added
by somebody looking for a problem.  And that would hamper debugging
instead of helping it.

I think we can live with a debug function printing wrong data if it's
called by 5 callers at once.

And if you want a perfectly correct fix, I suggest that you use
buffers allocated by the callers on the stack.  That's less intrusive
than mutexes, and it would allow using more than one hex2str() in one
statement as long as the buffers are different.

Or maybe hex2str() should be replaced with calls to
print_hex_dump_bytes()?  That would add extra lines to the kernel
output, but it's no big deal.  Of course, if you are concerned about 5
callers printing bytes in the same time, the output may be hard to
understand, but I don't think it a problem that needs addressing.

Or maybe you could develop an extension for printk() format that would
dump strings of the given length?  Something like %pM, but with an
extra argument (and make sure it would not trigger a gcc warning).
This way, everybody would benefit.

Please rethink whether it's helpful to send such "fixes" for old and
little maintained drivers.  There are few people who can work on them,
and they have little time for the old drivers.  Their time is better
spent fixing real problems than reviewing untested or badly conceived
patches for imaginary problems and style issues.  Besides, there are few
users who could test the driver and report breakage.

-- 
Regards,
Pavel Roskin
