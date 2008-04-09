Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blaine.gmane.org ([80.91.229.8]:56047 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797AbYDIUbW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 16:31:22 -0400
Received: from public by hugh.gmane.org with local (Exim 4.63)
	(envelope-from <public@hugh.gmane.org>)
	id 1Jjgwx-0006mI-Gw
	for linux-wireless@vger.kernel.org; Wed, 09 Apr 2008 22:31:19 +0200
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [ANN] WiMAX stack and drivers for Intel WiMAX Link 5050
Date: Wed, 9 Apr 2008 11:09:24 -0700
Cc: Inaky Perez-Gonzalez
	<public-inaky-VuQAYsv1563Yd54FQh9/CA@hugh.gmane.org>,
	Stephen Hemminger
	<public-stephen.hemminger-ZtmgI6mnKB3QT0dZR+AlfA@hugh.gmane.org>,
	public-wimax-BPSAo7wm5JOHVYUYWc+uSQ@hugh.gmane.org,
	public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org,
	public-netdev-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org,
	public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org
References: <200804011107.38563.inaky@linux.intel.com> <200804081359.03611.inaky@linux.intel.com> <871w5fpnhs.fsf@basil.nowhere.org>
In-Reply-To: <871w5fpnhs.fsf@basil.nowhere.org>
MIME-Version: 1.0
Message-Id: <200804091109.25265.inaky@linux.intel.com> (sfid-20080409_213129_624161_D87BA407)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>




On Tuesday 08 April 2008, Andi Kleen wrote:

> > version: I anticipate the wimax API exported to user space is
> > going to undergo a lot of changes while we all agree on what
> > is the best interface. Because things might break, I want to
> > make sure user space stuff can detect that and fail cleanly. 
> > Hence the versioning. 
> 
> It's still a bad way to do that (I agree with Stephen on that).
> Was also always a mess on wireless.
> 
> If you don't want expandable TLAs another better alternative to 
> versions is ext2 style compatible/incompatible feature bitmaps.

Ain't that another way of saying versions? Sorry guys, but I am 
having a hard time understanding how the alternatives are better.

Expandable TLAs are fine, until we need to change the meaning of
an existing field/value. Then there is no way to change it without 
breaking existing code other than create a new message. And then 
we have a mess like wireless again. 

With simple versioning, we just bump up the major number and break.
In user space, the libwimax shim library would take care of  hiding
this for the user if so is needed.

-- 
Inaky



