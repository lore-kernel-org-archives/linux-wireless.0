Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53271 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab3APXcS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 18:32:18 -0500
Message-ID: <1358379163.15012.69.camel@jlt4.sipsolutions.net> (sfid-20130117_003223_691688_5FD5DF69)
Subject: Re: [RFC] Fixes for problems with off-channel powersave
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 17 Jan 2013 00:32:43 +0100
In-Reply-To: <20130109134059.GC18778@thinkpad-t410>
References: <1357668645-5101-1-git-send-email-seth.forshee@canonical.com>
	 <20130109134059.GC18778@thinkpad-t410>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-09 at 07:40 -0600, Seth Forshee wrote:

> > It turns out that fixing problem #1 (i.e. patch 2) probably isn't
> > necessary with the other changes, as no frames should be sent while
> > off-channel PS is enabled. Does this still seem like a problem worth
> > fixing?
> 
> This is incorrect. We actually do need patch 2 for some hardware. I
> forgot that when I was testing with BCM43224 I found that PM gets
> actively set or cleared based on the device configuration. It's
> impossible to enable PS at the AP without informing the driver.

Hm, don't understand. If we're not sending any packets to the AP, why
does this matter?

Or are you saying it wants nullfunc frames generated in software, but
then changes the PM bit in them?

johannes

