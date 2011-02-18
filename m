Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:41557 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754938Ab1BRVbh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 16:31:37 -0500
Date: Fri, 18 Feb 2011 13:29:38 -0800
From: Greg KH <greg@kroah.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 01/15] staging: ath6kl: Fixing a NULL pointer exception
Message-ID: <20110218212938.GA21986@kroah.com>
References: <1298063596-2096-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1298063596-2096-1-git-send-email-vmehta@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 18, 2011 at 01:13:02PM -0800, Vipin Mehta wrote:
> The driver was dereferencing a NULL pointer because of the device instance
> being registered via the set_wiphy_dev() function. The function
> ar6000_avail_ev() was passing the argument as NULL instead of using the one
> returned by the MMC stack through the probe callback.

I've applied all of these, but note that some of them add whitespace
warnings.  In the future, I'll reject those that do this, please always
run your patches through scripts/checkpatch.pl to not have this happen.

thanks,

greg k-h
