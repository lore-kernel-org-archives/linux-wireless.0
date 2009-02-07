Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35697 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbZBGH3v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Feb 2009 02:29:51 -0500
Date: Sat, 7 Feb 2009 02:29:35 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Daniel Mierswa <impulze@impulze.org>,
	linux-wireless@vger.kernel.org
Subject: Re: location of binaries and libraries of new wifi tools
Message-ID: <20090207072935.GA27869@infradead.org> (sfid-20090207_082954_324290_12F11949)
References: <498CC07F.3080800@impulze.org> <1233981671.3652.6.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1233981671.3652.6.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 06, 2009 at 11:41:11PM -0500, Dan Williams wrote:
> On Fri, 2009-02-06 at 23:58 +0100, Daniel Mierswa wrote:
> > Hey list, I was wondering where to put binaries for the new
> > wireless-stack based tools. Most default installations put libnl, crypto
> > and gcrypt into /usr. Applications like iw, wpa_supplicant and crda need
> > those to run, yet they do not link statically. So if the default
> > location for the new binaries is /sbin or /bin and the libraries it
> > links against are default installed somewhere into /usr things will
> > break. I wonder now what to do for consistency. Either statically link
> > libraries that are default installed into /usr, put those libs into /lib
> > or install the binaries into /usr aswell. I'd appreciate any comments on
> > that. :) Thanks and have a nice weekend.
> 
> Stuff in /bin or /sbin can certainly link to stuff in /usr without
> breaking.  The only time it breaks is when you're using network
> mounted /usr and you need the wireless stack to boot the machine and
> mount /usr.

Which is a tradeoff to make.  But when you decide mounting /usr using
wireless networks is not viable you shoiuld just move the tools to
/usr/bin & /usr/sbin instead.  Having tools in /bin and & /sbin that
need libraries from /usr/lib is not a good idea as it violates the basic
assumptions (and doesn't actually help anything over having the tools
in /usr/bin & /usr/sbin)
