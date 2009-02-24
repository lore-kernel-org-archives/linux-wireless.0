Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:57691 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751538AbZBXBn2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 20:43:28 -0500
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: Rahul <rahul@schmizz.net>
Subject: Re: IEEE 802.15.4
Date: Mon, 23 Feb 2009 17:42:39 -0800
Cc: linux-wireless@vger.kernel.org
References: <200902240144.13336.r.jain@jacobs-university.de>
In-Reply-To: <200902240144.13336.r.jain@jacobs-university.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200902231742.40074.inaky@linux.intel.com> (sfid-20090224_024331_983108_AF4F539A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 23 February 2009, Rahul Jain wrote:
> Hello all,
>
> I am working on implementing a Linux device driver for IEEE 802.15.4
> NanoLoc Chipset for my bachelor's thesis. Currently, I am writing the
> research proposal, and therefore am collecting background information on
> this topic so that I can come up with a concrete work plan. I have no
> previous experience with device drivers as such, however since this is
> something I really want to do I am more than willing to learn.

Haven't seen any doc written about it, but what you probably want to do 
is start at top level and figure out answers to:

- what are the usage models?
- what do I want to do with the device?

Once you have those answers, you start to break them down in "requirements",
for lack of a better word. Then you need to implement those "requirements",
which probably will be high level actions that a "client" application would
do, such as (quick dirty list):

- discover available adapters in the system
- have each adapter scan for available connection peers/nodes
- tx/rx information from those peers (this will probably expand a lot)
- etc...

and then you'll have to break the functionality in areas, where do you
implement which functionality?:

- a user space daemon/library/d-bus interface?
  (so many applications can be client of the service and take advantage
   of the high level functionality without reimplementing it); this
  would talk to a very low level kernel API...

- ...implemented by a kernel stack to abstract out the common parts that 
  all the drivers will have to offer

- the drivers themselves doing the bare minimum to expose the interface
  that the kernel stack needs drivers to have.

Sometimes there is no need to do some of those parts, or any (for example,
if all the devices will ever be USB, it could be implemented all in user
space with libusb), but there is normally no way to know that ahead of time
and you just take your best judgement at the time :)

Don't be shy on starting and then realizing you got it wrong from the start.
If you wait to learn everything, you'll never finish. You might have to go
over two or three whole redesign and reimplementation phases until you get
it right. That's not bad at all, as it gives you time to stop, rethink, 
put together all the accumulated knowledge that you lacked at the start and
clean up dead wood.

An example of that model, with things split out, is the bluetooth stack.
If I remember correctly how Zigbee worked, there might be some similarities
you might use for an starting point.

-- 
Inaky
