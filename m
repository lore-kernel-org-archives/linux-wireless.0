Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53912 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab0GIDE7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 23:04:59 -0400
Date: Fri, 9 Jul 2010 04:56:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	Linux ACPI <linux-acpi@vger.kernel.org>,
	Linux PM List <linux-pm@lists.linux-foundation.org>,
	Linux SCSI List <linux-scsi@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	DRI <dri-devel@lists.sourceforge.net>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Shawn Starr <shawn.starr@rogers.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Dave Airlie <airlied@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Patrick McHardy <kaber@trash.net>, Jens Axboe <axboe@kernel.dk>
Subject: Re: 2.6.35-rc4-git3: Reported regressions from 2.6.34
Message-ID: <20100709025628.GK6405@nowhere>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera> <AANLkTiknnzWyVpqnPCpyiEVHLgkewd0zaGzLInABRe2G@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTiknnzWyVpqnPCpyiEVHLgkewd0zaGzLInABRe2G@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 08, 2010 at 06:34:25PM -0700, Linus Torvalds wrote:
> On Thu, Jul 8, 2010 at 4:33 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16334
> > Subject         : reiserfs locking (v2)
> > Submitter       : Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > Date            : 2010-07-02 9:34 (7 days old)
> > Message-ID      : <20100702093451.GA3973@swordfish.minsk.epam.com>
> > References      : http://marc.info/?l=linux-kernel&m=127806306303590&w=2
> 
> Frederic? Al? I assume this is some late fallout from the BKL removal
> ages ago.. It's the old filldir-vs-mmap crud, but normally it should
> be impossible to trigger because the inode for a directory should
> never be mmap'able, so we should never have the same i_mutex lock used
> for both mmap and for filldir protection.
> 
> We saw some of that oddity long ago, I wonder if it's lockdep being
> confused about some inodes.



I think it has been there from the beginning. At least it was there before
the reiserfs bkl removal in .32.


Indeed the readdir <-> unmap/release inversion problem can not happen.
But Al said that can happen between write and release. (Although I don't see
where write takes the inode mutex).

He also highlighted the fact that reiserfs refcounting based on i_count
was totally broken.

He has a fix the whole in the vfs tree, in the for-next branch on commit
6c2bdaf089a3876226893fab00dd83596c465ad2
"Fix reiserfs_file_release()"

No more uses of the i_mutex on release after that, nor i_count, but a private
openers refcount and a tailpack mutex per reiserfs inode.

