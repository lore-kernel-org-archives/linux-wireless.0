Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab3JXLbS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Oct 2013 07:31:18 -0400
Date: Thu, 24 Oct 2013 13:27:51 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Dietmar Rudolph <dietmar@crlf.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwl3945 filling kern.log when HW switch is off
Message-ID: <20131024112750.GC1677@redhat.com> (sfid-20131024_133135_197044_A2BC3B60)
References: <526795E1.90701@crlf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <526795E1.90701@crlf.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 23, 2013 at 11:24:49AM +0200, Dietmar Rudolph wrote:
> Hello, I hope this is the correct place to put a bug report in. I do
> not subscribe to this mailing list, but feel free to send PM in case
> you need additional info. You shoudn't :-)
> 
> After installing Ubuntu 13.10, I noticed kern.log growing faster
> than you could look at. Within a few working hours, kern.log was
> >6GB!
> 
> The reason is that I intentionally disabled WiFi on this laptop by
> turning the HW switch off. However, this makes iwl3945 write a log
> entry into kern.log every few microseconds!
> 
> The workaround is to turn the HW switch on. The bug fix would be to
> write just a single line to kern.log.

This message is printed when someone try to UP device when RF kill
switch is on. Either you did not compile kernel with CONFIG_RFKILL or
your user space network management software does not handle rfkill .

Stanislaw

