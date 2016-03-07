Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbcCGKB6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 05:01:58 -0500
Date: Mon, 7 Mar 2016 10:59:46 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Vishal Thanki <vishalthanki@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rt2x00queue: rt2800usb: NULL pointer crash while during USB
 disconnect
Message-ID: <20160307095945.GD23699@redhat.com> (sfid-20160307_110208_748949_6DBE8692)
References: <20160301103612.GC29736@c50.bag.software>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160301103612.GC29736@c50.bag.software>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Mar 01, 2016 at 11:36:13AM +0100, Vishal Thanki wrote:
> I observed a NULL pointer access crash during my testing on a custom AM33xx
> based board with RT5572 USB wifi module. The kernel log is attached with
> the mail. With initial debugging, I think that the USB disconnect
> event was triggered while there was an pending/incomplete URB request
> present. As a part of USB disconnect, the driver cleanup deallocated
> queues. However the completion of pending URB tried to access the queue,
> which resulted in the NULL pointer crash.
> 
> I added a check in the queue helper routines and with that I did not see
> the problem. The patch for the same is also attached with the email.
> Please suggest if that is the right way to address the problem.

Fix is not correct as we can crash at any other point if we get callback
from pending urb after resources are freed. What should be done is
create a list of pending urbs (possibly using usb_anchor structure and
primitives) and kill urb's before freeing resources.

Stanislaw
