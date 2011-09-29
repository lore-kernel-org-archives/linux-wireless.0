Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:61108 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157Ab1I2Krk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 06:47:40 -0400
Subject: Re: [PATCH] wireless: at76c50x: fix multithread access to hex2str
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Date: Thu, 29 Sep 2011 13:46:55 +0300
In-Reply-To: <20110928171909.6889916c@mj>
References: <21514bff06a915d2edd0a83c74ac512eb8b80b3f.1317215809.git.andriy.shevchenko@linux.intel.com>
	 <20110928171909.6889916c@mj>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1317293215.2676.111.camel@smile> (sfid-20110929_124745_806919_14CC4EF8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-09-28 at 17:19 -0400, Pavel Roskin wrote: 
> On Wed, 28 Sep 2011 16:17:31 +0300
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> 
> > The original hex2str uses finite array of buffers to keep output
> > data. It's a wrong approach, because we can't say at compile time how
> > many threads will be used.
> > 
> > This patch introduces one buffer and global mutex to access this
> > function. All calls of it are wrapped by locking this mutex. It saves
> > some memory as a side effect.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Cc: "John W. Linville" <linville@tuxdriver.com>
> 
> The reason for having 4 buffers is to allow using hex2str() more than
> once in the same printk() statement.
And even in this case it has a weird limitation. Why 4? Why not 5 or 20?

> As you can see, hex2str() is never used in one statement more than once.
Yeah, that's why it works in both cases.

> Your solution would make
> it impossible to use hex2str() twice in the same printk(), as the
> buffer would be reused.  Actually, wrong data would be printed with no
> warning!  Such code doesn't exist in the driver, but it could be added
> by somebody looking for a problem.  And that would hamper debugging
> instead of helping it.
You know, there is no statement, how to use the function for the 3rd
party developer. We have the mailing list not only for bots. I'm glad to
hear some explanations which I didn't catch from the code itself.

> I think we can live with a debug function printing wrong data if it's
> called by 5 callers at once.
I disagree with such attitude.

> And if you want a perfectly correct fix, I suggest that you use
> buffers allocated by the callers on the stack.  That's less intrusive
> than mutexes, and it would allow using more than one hex2str() in one
> statement as long as the buffers are different.
> Or maybe hex2str() should be replaced with calls to print_hex_dump_bytes()?
I thought about it. Actually I must write RFC prefix to the patch, my
bad.

> Or maybe you could develop an extension for printk() format that would
> dump strings of the given length?  Something like %pM, but with an
> extra argument (and make sure it would not trigger a gcc warning).
> This way, everybody would benefit.
I don't think it would be a noticeable benefit. On the other hand
vsnprintf() is hugely overloaded by many "extensions" to the C99
variant.

> Please rethink whether it's helpful to send such "fixes" for old and
> little maintained drivers.
Last copyright is 2010, TODO list actually suggests to remove hex2str at
all.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
