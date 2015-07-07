Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbbGGEAr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 00:00:47 -0400
Date: Mon, 6 Jul 2015 19:31:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Chris Park <chris.park@atmel.com>, Dean Lee <dean.lee@atmel.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Julia Lawall <julia.lawall@lip6.fr>,
	kernel-janitors@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] staging: wilc1000: One function call less in
 mac_ioctl() after error detection
Message-ID: <20150707023150.GB22043@kroah.com> (sfid-20150707_060118_520768_CE4A009C)
References: <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <558EB32E.6090003@users.sourceforge.net>
 <558EB524.1050609@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <558EB524.1050609@users.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 27, 2015 at 04:37:24PM +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 27 Jun 2015 16:00:59 +0200

Again, please fix.

> 
> The kfree() function was called in two cases by the mac_ioctl() function
> during error handling even if the passed variable did not contain a pointer
> for a valid data item.
> 
> * This implementation detail could be improved by the introduction
>   of another jump label.
> 
> * Drop an unnecessary initialisation for the variable "buff" then.

That's a different issue, please fix it in a separate patch.

thanks,

greg k-h
