Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39634 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbbEaDDk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2015 23:03:40 -0400
Date: Sun, 31 May 2015 11:53:47 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: netdev@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, Stable <stable@vger.kernel.org>,
	Haggi Eran <haggai.eran@gmail.com>
Subject: Re: [PATCH] staging: r8712u: Fix kernel warning for improper call of
 del_timer_sync()
Message-ID: <20150531025347.GA8074@kroah.com> (sfid-20150531_050347_931995_1C142858)
References: <1432415812-1285-1-git-send-email-Larry.Finger@lwfinger.net>
 <55634793.4050002@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55634793.4050002@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 25, 2015 at 11:02:27AM -0500, Larry Finger wrote:
> On 05/23/2015 04:16 PM, Larry Finger wrote:
> >The driver is reporting a warning at kernel/time/timer.c:1096 due to calling
> >del_timer_sync() while in interrupt mode. Such warnings are fixed by calling
> >del_timer() instead.
> >
> >Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> >Cc: Stable <stable@vger.kernel.org>
> >Cc: Haggi Eran <haggai.eran@gmail.com>
> >---
> 
> Greg,
> 
> Please drop this patch. The same fixes were submitted as
> https://lkml.org/lkml/2015/5/15/226.

That's not working for me at the moment, what was the subject: name?  I
think I already applied it to the testing tree...

thanks,

greg k-h
