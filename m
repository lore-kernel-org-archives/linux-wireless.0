Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:34750 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbbI3MaF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 08:30:05 -0400
Date: Wed, 30 Sep 2015 17:59:22 +0530
From: Chandra Gorentla <csgorentla@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: dan.carpenter@oracle.com, johnny.kim@atmel.com,
	rachel.kim@atmel.com, dean.lee@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 1/2] drivers: staging: wilc1000: Replace message queue
 with standard Linux lists
Message-ID: <20150930122922.GA4704@gcs-HP-Notebook> (sfid-20150930_143027_036459_5B1DF7D1)
References: <1443464037-3591-1-git-send-email-csgorentla@gmail.com>
 <20150929004402.GB7811@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150929004402.GB7811@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 29, 2015 at 02:44:02AM +0200, Greg KH wrote:
> On Mon, Sep 28, 2015 at 11:43:55PM +0530, Chandra S Gorentla wrote:
> >  - The message queue is replaced with standard Linux linked list
> >  - kmem_cache is used for list members
> 
> Why?
The list entires are of fixed type and repeatedly allocated and deallocated
for messages.
> 
> >  - A check for return value of receive method is added
> >  - GFP_ATOMIC is changed to GFP_KERNEL
> 
> Why?  Are you sure that is safe?
The allocations are moved out of 'spin_lock_irqsave' and
'spin_unlock_irqrestore'.  Hence they are safe.
> 
> >  - A few other related minor changes
> 
> Be specific please.
OK.  I will try to send seperate patches.
> 
> thanks,
> 
> greg k-h

Thank you,
chandra
