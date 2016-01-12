Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:56336 "EHLO
	relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbcALNIG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 08:08:06 -0500
Message-ID: <1452604081.17103.12.camel@hadess.net> (sfid-20160112_140809_761837_2C39F162)
Subject: Re: How to revert RFKILL_IOC_NOINPUT ioctl?
From: Bastien Nocera <hadess@hadess.net>
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Date: Tue, 12 Jan 2016 14:08:01 +0100
In-Reply-To: <1452603950.3473.6.camel@sipsolutions.net>
References: <1452600332.17103.10.camel@hadess.net>
	 <1452603950.3473.6.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-01-12 at 14:05 +0100, Johannes Berg wrote:
> On Tue, 2016-01-12 at 13:05 +0100, Bastien Nocera wrote:
> >  
> > I realised looking at the rfkill kernel configuration, and noticed
> > that it wasn't possible to disable CONFIG_RFKILL_INPUT without
> > enabling the expert mode. "Why" would be the first question in this
> > mail.
> 
> I guess the answer would be that at the time, you couldn't really get
> a
> fully functional setup without it, and there wasn't really any
> default
> userspace to deal with it. Perhaps there is now at least a bigger
> chance that userspace will deal with it.
> 
> That said, I don't really see a need to disable this code since
> userspace that wants to handle it should use the ioctl to disable the
> in-kernel code (if it's at all present.)

Right. I'll leave it there then.

> > See https://lists.fedoraproject.org/archives/list/kernel@lists.fedo
> > ra
> > project.org/thread/FWCOCU2ODZHK7AQVOWSFJLBXL744LYNO/
> > 
> > To make my GNOME code work, I'd need to disable rfkill-input. But
> > if
> > I still wanted to allow rfkill-input to work when GNOME isn't
> > running, such as when switching to a console, or another less-
> > capable 
> > desktop environment. But there doesn't seem to be a counterpart
> > for RFKILL_IOC_NOINPUT. Any reason why?
> 
> It's automatically released when you close the fd.

OK, good enough for me.

Cheers
