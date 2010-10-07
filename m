Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50545 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760126Ab0JGHvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 03:51:19 -0400
Subject: Re: Bug#599345: linux-image-2.6.32-5-amd64: iwlagn allocation
 failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Julien Cristau <jcristau@debian.org>, 599345@bugs.debian.org,
	ilw@linux.intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <1286402043.2955.81.camel@localhost>
References: <20101006191947.GA3036@radis.liafa.jussieu.fr>
	 <1286402043.2955.81.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 09:51:10 +0200
Message-ID: <1286437870.3657.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-06 at 22:54 +0100, Ben Hutchings wrote:
> On Wed, 2010-10-06 at 21:19 +0200, Julien Cristau wrote:
> > Package: linux-2.6
> > Version: 2.6.32-23

> > Oct  6 21:05:02 radis kernel: [378665.326381] NetworkManager: page allocation failure. order:4, mode:0x40d0
> > Oct  6 21:05:02 radis kernel: [378665.326393] Pid: 25555, comm: NetworkManager Not tainted 2.6.32-5-amd64 #1
> [...]
> > Oct  6 21:05:02 radis kernel: [378665.363630] iwlagn 0000:0c:00.0: kmalloc for auxiliary BD structures failed
> [...]
> 
> This particular allocation is for an array which is not used for DMA and
> therefore could be stored in non-contiguous pages allocated with
> vmalloc().  But there may be some good reason not to do this.

I have, however much more recently than that kernel, cleaned this up in
commit ff0d91c3eea6e25b47258349b455671f98f1b0cd -- this particular
allocation is now 2048 or 4096 bytes depending on the architecture (32
vs 64 bit pointers). If you want to backport this, there are two or
three more commits right before it that would probably be required.

johannes

