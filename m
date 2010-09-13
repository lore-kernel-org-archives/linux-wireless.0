Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55472 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab0IMS62 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 14:58:28 -0400
Message-ID: <4C8E744A.2020906@lakedaemon.net>
Date: Mon, 13 Sep 2010 14:58:18 -0400
From: Jason <linuxdriverproject@lakedaemon.net>
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Mike Rapoport <mike@compulab.co.il>, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ANN] Full-source Broadcom wireless driver for 11n chips
References: <20100908150322.17dac9c3@nehalam>	<20100908225132.GA12490@kroah.com> <4C88F8CE.5090708@broadcom.com>	<4C8DD9F4.5090305@compulab.co.il> <20100913154227.GB24563@kroah.com>
In-Reply-To: <20100913154227.GB24563@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg,

Greg KH wrote:
> On Mon, Sep 13, 2010 at 09:59:48AM +0200, Mike Rapoport wrote:
>> Hi Henry,
>> 
>> Henry Ptasinski wrote:
>>> Broadcom would like to announce the initial release of a
>>> fully-open Linux driver for it's latest generation of 11n
>>> chipsets.  The driver, while still a work in progress, is
>>> released as full source and uses the native mac80211 stack.   It
>>> supports multiple current chips (BCM4313, BCM43224, BCM43225) as
>>> well as providing a framework for supporting additional chips in
>>> the future, including mac80211-aware embedded chips. The README
>>> and TODO files included with the sources provide more details
>>> about the current feature set, known issues, and plans for 
>>> improving the driver.
>>> 
>>> The driver is currently available in staging-next git tree,
>>> available at:
>>> 
>>> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
>>> 
>>> 
>>> 
>>> in the drivers/staging/brcm80211 directory.
>> Are there any plans to support BCM4319 and BCM4329 SDIO chipsets?
> 
> I think those are supported by the broadcom driver in the android
> kernel trees, right?

I know the BCM4329 is, it's in the Nexus One.  

> If so, yes, there are plans for merging them into the main kernel
> tree, and any help you can provide would be appreciated.
> 

I'm currently working through the checkpatch issues for staging/brcm80211/*, so far, I've done:

ERROR: "foo * bar" should be "foo *bar"
ERROR: open brace '{' following function dec...
ERROR: return is not a function, paren...
ERROR: do not use assignment in if condition
ERROR: trailing statements should be on next line
ERROR: that open brace { ... prev line
ERROR: while should follow close brace '}'
ERROR: do not initialise globals to 0 or NULL
ERROR: do not initialise statics to 0 or NULL
ERROR: Macros w/ complex values ... parenthesis
ERROR: Macros w/ mult. statements ... do - while loop

The only remaining errors are whitespace, then I'll move on to warnings.  

Since this is my first large (arguably trivial ;-) ) patchset, do you want them one by one as I finish them, or the whole thing in one shot?

btw, each "ERROR: ..." line above is one commit.

thx,

Jason.
