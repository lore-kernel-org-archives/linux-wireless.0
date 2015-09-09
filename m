Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40585 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195AbbIITwh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 15:52:37 -0400
Date: Wed, 9 Sep 2015 11:19:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, rachel.kim@atmel.com,
	glen.lee@atmel.com, leo.kim@atmel.com, austin.shin@atmel.com,
	adel.noureldin@atmel.com, adham.abozaeid@atmel.com,
	Nicolas.FERRE@atmel.com
Subject: Re: [PATCH 3/4] staging: wilc1000: delete wilc_oswrapper.h and
 wilc_platform.h
Message-ID: <20150909181912.GA30669@kroah.com> (sfid-20150909_215242_244608_AEBF9CC7)
References: <1441782493-11338-1-git-send-email-tony.cho@atmel.com>
 <1441782493-11338-3-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1441782493-11338-3-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 09, 2015 at 04:08:12PM +0900, Tony Cho wrote:
> From: Glen Lee <glen.lee@atmel.com>
> 
> wilc1000 driver runs on Linux. No need to have oswrapper or platform
> dependent files.
> Before delete two header files, move two structures in wilc_platform.h to
> wilc_msgqueue.h where it is used. Include linux header files where is needs
> since wilc_platform is deleted.
> Finally, remove wilc_oswrapper.h and wilc_platform.h.

That's a lot of different things to be doing all in one patch.  Please
break this up into individual patches.

And you can't just delete the oswrapper.h file, you still have things in
it, don't move it for no reason, get rid of those wrapper functions
properly first, making the file empty, and then you can delete it.
Moving them to a different .h file just hides the fact that this work
still needs to be done.

thanks,

greg k-h
