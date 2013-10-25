Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985Ab3JYKIK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Oct 2013 06:08:10 -0400
Date: Fri, 25 Oct 2013 12:04:40 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Dietmar Rudolph <dietmar@crlf.de>, linux-wireless@vger.kernel.org
Subject: Re: iwl3945 filling kern.log when HW switch is off
Message-ID: <20131025100436.GA16384@redhat.com> (sfid-20131025_120815_227787_7E9CE8D6)
References: <526795E1.90701@crlf.de>
 <20131024112750.GC1677@redhat.com>
 <1382626081.4328.3.camel@dcbw.foobar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1382626081.4328.3.camel@dcbw.foobar.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 24, 2013 at 09:48:01AM -0500, Dan Williams wrote:
> On Thu, 2013-10-24 at 13:27 +0200, Stanislaw Gruszka wrote:
> > On Wed, Oct 23, 2013 at 11:24:49AM +0200, Dietmar Rudolph wrote:
> > > Hello, I hope this is the correct place to put a bug report in. I do
> > > not subscribe to this mailing list, but feel free to send PM in case
> > > you need additional info. You shoudn't :-)
> > > 
> > > After installing Ubuntu 13.10, I noticed kern.log growing faster
> > > than you could look at. Within a few working hours, kern.log was
> > > >6GB!
> > > 
> > > The reason is that I intentionally disabled WiFi on this laptop by
> > > turning the HW switch off. However, this makes iwl3945 write a log
> > > entry into kern.log every few microseconds!
> > > 
> > > The workaround is to turn the HW switch on. The bug fix would be to
> > > write just a single line to kern.log.
> > 
> > This message is printed when someone try to UP device when RF kill
> > switch is on. Either you did not compile kernel with CONFIG_RFKILL or
> > your user space network management software does not handle rfkill .
> 
> Though maybe it shouldn't actually print a dmesg error when that
> happens?  Lots of software (scripts included) might try to open the
> device but not really know much about rfkill...  Is there a way to print
> it once-per-rfkill instead maybe?

I'll just remove this message. We can return ERFKILL error instead.
That will allow user to identify problem without message.

Thanks
Stanislaw 
