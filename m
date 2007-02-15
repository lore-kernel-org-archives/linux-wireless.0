Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:47238 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161575AbXBOWmU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 17:42:20 -0500
Date: Thu, 15 Feb 2007 14:40:57 -0800
From: Greg KH <greg@kroah.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: renaming in debugfs?
Message-ID: <20070215224057.GA20464@kroah.com>
References: <1171540374.20204.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1171540374.20204.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 15, 2007 at 12:52:53PM +0100, Johannes Berg wrote:
> For the wiphy stuff I wanted to provide a debugfs as well as a sysfs dir
> for drivers (or the d80211 stack).
> 
> But then I decided that stable wiphy names will be a good thing instead
> of just numbering them wiphy%d. Does anyone have any idea how to rename
> directories in debugfs? I guess that for sysfs it'll just work if I
> change the kobject name, but maybe that's wrong too?

No, use kobject_rename() if you want to rename a kobject in sysfs (or
the real device_rename() call if you have a struct device).

For debugfs, there is no rename function yet, but it would be pretty
trivial to add one if you wish.

thanks,

greg k-h
