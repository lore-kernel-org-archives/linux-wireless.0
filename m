Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30040 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbbJBNjb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 09:39:31 -0400
Date: Fri, 2 Oct 2015 16:39:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chandra S Gorentla <csgorentla@gmail.com>
Cc: gregkh@linuxfoundation.org, rachel.kim@atmel.com,
	devel@driverdev.osuosl.org, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers: staging: wilc1000: Check for errors before
 kfree
Message-ID: <20151002133911.GP7289@mwanda> (sfid-20151002_153952_986529_87DE3E11)
References: <1443791857-7837-1-git-send-email-csgorentla@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443791857-7837-1-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 02, 2015 at 06:47:35PM +0530, Chandra S Gorentla wrote:
> During the clean-up of the function, it is need to check if
> errors occurred, not the memory pointer.
>

The bug here is that we have a use after free on the success path.  It
should have been mentioned in the changelog.

Anyway, this patch is buggy.  If result == -EFAULT then it will crash.
Also this patch is really ugly.  There is someone who is going to send a
correct fix (just add a return 0).

This driver usese "do everything" style error handling.  It is a bug
prone anti-pattern because doing everything is more complicated than
doing one thing.  You can easily see it is bug prone, because it made
you introduce a bug, right?

Instead the error handling should look like this:

	return 0;

err_free_msg:
	kfree(pstrMessage);

	return ret;

There are no error paths where we need to free "pstrMessage->pvBuffer"
but if we were to add one it would look like this:

	return 0;

err_pvbuffer:
	kfree(pstrMessage->pvBuffer);
err_msg:
	kfree(pstrMessage);

	return ret;

This is a minimal, uncomplicated, no indenting, no if statement way of
unwinding.

regards,
dan carpenter

