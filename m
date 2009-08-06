Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:32867 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402AbZHFQl2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 12:41:28 -0400
Subject: Re: CRDA and cross-compilation
From: Pavel Roskin <proski@gnu.org>
To: Jon Loeliger <jdl@bigfootnetworks.com>
Cc: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1249569993.6446.2.camel@jdl-desktop>
References: <4A7A8F7E.6020503@redfish-solutions.com>
	 <1249569993.6446.2.camel@jdl-desktop>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 12:41:26 -0400
Message-Id: <1249576886.14919.16.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-08-06 at 09:46 -0500, Jon Loeliger wrote:
> On Thu, 2009-08-06 at 01:08 -0700, Philip A. Prindeville wrote:
> > Who currently owns CRDA?
> > 
> > I started to stare at cross-compiling issues, but realized that we need
> > two versions of reglib.o and print-regdom.o...
> > 
> > One to link with regdumpdb (compiled with HOSTCC) and one to link with
> > everything else (compiled with TARGET_CC)...
> > 
> > No easy way to do this without a lot of changes.
> 
> I posted a 5-part patch series to address this issue.
> To the best of my knowledge, it has not been applied yet.
> 
> You can find it here:
> 
> http://article.gmane.org/gmane.linux.kernel.wireless.general/35350

I objected against using the misleading use of the "TARGET" work in some
variables, but there was no reaction.  Failure to react to objections is
the likely reason it wasn't applied.

I also think that you add too much complexity to the Makefile.

Also, the use of .config is not common.  Most valuables can be specified
on the command line.  That would override the definitions in Makefile,
and that's how it's done.

For instance, you can have this in Makefile:

HOSTCC = gcc
CC = $(HOSTCC)

Running "make CC=/opt/mips/bin/gcc" would override CC but not HOSTCC.

-- 
Regards,
Pavel Roskin
