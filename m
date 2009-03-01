Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes.jacobs-university.de ([212.201.44.23]:50290 "EHLO
	hermes.jacobs-university.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755594AbZCAX4Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2009 18:56:24 -0500
From: Rahul Jain <rahul@schmizz.net>
Reply-To: Rahul Jain <rahul@schmizz.net>
To: "Inaky Perez-Gonzalez" <inaky@linux.intel.com>
Subject: Re: IEEE 802.15.4
Date: Mon, 2 Mar 2009 00:49:22 +0100
Cc: linux-wireless@vger.kernel.org
References: <200902240144.13336.r.jain@jacobs-university.de> <200902231742.40074.inaky@linux.intel.com>
In-Reply-To: <200902231742.40074.inaky@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903020049.24613.rahul@schmizz.net> (sfid-20090302_005630_388386_7EDB8061)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 24 February 2009 02:42:39 Inaky Perez-Gonzalez wrote:
> On Monday 23 February 2009, Rahul Jain wrote:
> > Hello all,
> >
> > I am working on implementing a Linux device driver for IEEE 802.15.4
> > NanoLoc Chipset for my bachelor's thesis. Currently, I am writing the
> > research proposal, and therefore am collecting background information on
> > this topic so that I can come up with a concrete work plan. I have no
> > previous experience with device drivers as such, however since this is
> > something I really want to do I am more than willing to learn.
>
> Haven't seen any doc written about it, but what you probably want to do
> is start at top level and figure out answers to:
>
> - what are the usage models?
> - what do I want to do with the device?
>
> Once you have those answers, you start to break them down in
> "requirements", for lack of a better word. Then you need to implement those
> "requirements", which probably will be high level actions that a "client"
> application would do, such as (quick dirty list):
>
> - discover available adapters in the system
> - have each adapter scan for available connection peers/nodes
> - tx/rx information from those peers (this will probably expand a lot)
> - etc...
>
> and then you'll have to break the functionality in areas, where do you
> implement which functionality?:
>
> - a user space daemon/library/d-bus interface?
>   (so many applications can be client of the service and take advantage
>    of the high level functionality without reimplementing it); this
>   would talk to a very low level kernel API...
>
> - ...implemented by a kernel stack to abstract out the common parts that
>   all the drivers will have to offer
>
> - the drivers themselves doing the bare minimum to expose the interface
>   that the kernel stack needs drivers to have.
>
> Sometimes there is no need to do some of those parts, or any (for example,
> if all the devices will ever be USB, it could be implemented all in user
> space with libusb), but there is normally no way to know that ahead of time
> and you just take your best judgement at the time :)
>
> Don't be shy on starting and then realizing you got it wrong from the
> start. If you wait to learn everything, you'll never finish. You might have
> to go over two or three whole redesign and reimplementation phases until
> you get it right. That's not bad at all, as it gives you time to stop,
> rethink, put together all the accumulated knowledge that you lacked at the
> start and clean up dead wood.
>
> An example of that model, with things split out, is the bluetooth stack.
> If I remember correctly how Zigbee worked, there might be some similarities
> you might use for an starting point.

Rather late response here, have been thinking about this a little and had a 
talk with my supervisor. 
Device to be basically used for range measurements (to measure the link 
distance between two nodes).

The work is currently divided between two students - I am supposed to be 
working on the PHY and MAC related part, as I understand it. The other guy is 
supposed to work on connecting USB devices to Linux and then figuring out a 
way to connect this nanoLOC chip through USB and registering it is a IEEE 
802.15.4 network device.

What I am supposed to figure out (or work on) is then the kernel API for IEEE 
802.15.4 devices. (at least that is how I understand the task distribution) 
Now, I had a look at the mac80211 project and that is a stack which is 
providing API for developing 802.11 drivers. (frankly speaking though, the 
project is too large for me to grasp properly within a week.) 

What I see now is to implement the PHY and the MAC layers based on the IEEE 
standard and then provide some sort of API for the driver to be able to use 
these functionalities.  Please correct me if I am mistaken. 

I found the NS-2 implementation of the MAC layer for 802.15.4 and am currently 
reading that, see how much I can understand for there is no documentation on 
it as such (or at least I cannot find any).

So, it would be a great help if someone could tell me whether this is the 
right approach - as in whether developing the kernel API does indeed mean 
writing an implementation of the MAC and the PHY layer. And if yes, is there a 
general approach that I should follow in implementing the MAC and the PHY 
layer for the kernel (if that sentence makes sense). 

I know I am still beating around the bush - but my focus right now is indeed 
on collecting and understanding as much background information as I can 
gather. This is so because I need to come up with a proposal that lists what 
exactly do I want to do and how I intend to do it. When I have a clear idea, I 
take the draft to the prof. for his edification pleasure.

Any help would be hugely appreciated, I am very new to this area of 
programming, but remain hugely interested in accomplishing this task.

Thanks
Rahul
