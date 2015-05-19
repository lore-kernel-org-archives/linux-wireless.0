Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbbESRFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 13:05:22 -0400
Date: Tue, 19 May 2015 10:05:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: ming.lei@canonical.com, tiwai@suse.de, rusty@rustcorp.com.au,
	torvalds@linux-foundation.org, dhowells@redhat.com,
	seth.forshee@canonical.com, linux-kernel@vger.kernel.org,
	pebolle@tiscali.nl, linux-wireless@vger.kernel.org, jlee@suse.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: Re: [PATCH v3 0/4] firmware: few fixes for name uses
Message-ID: <20150519170521.GA9213@kroah.com> (sfid-20150519_190540_422635_4D1A5566)
References: <1431467383-28540-1-git-send-email-mcgrof@do-not-panic.com>
 <20150519164533.GF23057@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150519164533.GF23057@wotan.suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2015 at 06:45:33PM +0200, Luis R. Rodriguez wrote:
> On Tue, May 12, 2015 at 02:49:39PM -0700, Luis R. Rodriguez wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > This v3 changes patch 1 to just return -ENOMEM and remove the
> > unlikely() optimization. It also drops the early truncation
> > checks.
> > 
> > Luis R. Rodriguez (4):
> >   firmware: fix __getname() missing failure check
> >   firmware: check for file truncation on direct firmware loading
> >   firmware: fix possible use after free on name on asynchronous request
> >   firmware: use const for remaining firmware names
> > 
> >  drivers/base/firmware_class.c | 61 +++++++++++++++++++++++++++++++------------
> >  1 file changed, 45 insertions(+), 16 deletions(-)
> 
> Ming, a review would be much appreciated. I also have a few other changes coming
> later, so should these go through Greg or Takashi first ? If its of any help
> I'm happy to take on co-maintenance on this module given that I am lookng
> to do quite a bit of surgery on the APIs later.

They should go through me.

thanks,

greg k-h
