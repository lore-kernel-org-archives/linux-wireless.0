Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:32780 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbbJCCOc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 22:14:32 -0400
Date: Sat, 3 Oct 2015 07:41:13 +0530
From: Chandra Gorentla <csgorentla@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, rachel.kim@atmel.com,
	devel@driverdev.osuosl.org, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers: staging: wilc1000: Check for errors before
 kfree
Message-ID: <20151003021112.GA9115@gcs-HP-Notebook> (sfid-20151003_041452_109913_6A80FCE1)
References: <1443791857-7837-1-git-send-email-csgorentla@gmail.com>
 <20151002133911.GP7289@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151002133911.GP7289@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 02, 2015 at 04:39:11PM +0300, Dan Carpenter wrote:
> On Fri, Oct 02, 2015 at 06:47:35PM +0530, Chandra S Gorentla wrote:
> > During the clean-up of the function, it is need to check if
> > errors occurred, not the memory pointer.
> >
> 
> The bug here is that we have a use after free on the success path.  It
> should have been mentioned in the changelog.
> 
> Anyway, this patch is buggy.  If result == -EFAULT then it will crash.
> Also this patch is really ugly.  There is someone who is going to send a
> correct fix (just add a return 0).
> 
> This driver usese "do everything" style error handling.  It is a bug
> prone anti-pattern because doing everything is more complicated than
> doing one thing.  You can easily see it is bug prone, because it made
> you introduce a bug, right?
> 
> Instead the error handling should look like this:
> 
> 	return 0;
> 
> err_free_msg:
> 	kfree(pstrMessage);
> 
> 	return ret;
> 
> There are no error paths where we need to free "pstrMessage->pvBuffer"
> but if we were to add one it would look like this:
> 
> 	return 0;
> 
> err_pvbuffer:
> 	kfree(pstrMessage->pvBuffer);
> err_msg:
> 	kfree(pstrMessage);
> 
> 	return ret;
> 
> This is a minimal, uncomplicated, no indenting, no if statement way of
> unwinding.
> 
> regards,
> dan carpenter
> 
OK.  There is a problem in this patch.  I will correct it, reorganize the
patch series.

Thank you,
chandra

